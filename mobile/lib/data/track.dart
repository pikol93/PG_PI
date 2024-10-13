import "dart:convert";
import "dart:typed_data";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/data/location.dart";

part "track.g.dart";

part "track.freezed.dart";

@freezed
class Track with _$Track {
  const Track._();

  const factory Track({
    required String uuid,
    required DateTime startTime,
    @LocationsConverter() required List<Location> locations,
  }) = _Track;

  factory Track.fromJson(Map<String, Object?> json) => _$TrackFromJson(json);

  Duration getTotalTime() {
    // Assumption: locations are sorted chronologically.
    final lastLocation = locations.lastOrNull;
    if (lastLocation == null) {
      return Duration.zero;
    }

    return startTime.difference(lastLocation.dateTime);
  }

  double getTotalLength() {
    var result = 0.0;
    for (var i = 0; i < locations.length - 1; i++) {
      final locationA = locations[i];
      final locationB = locations[i + 1];
      final distance = Location.getMetersBetweenLocations(locationA, locationB);
      result += distance;
    }

    return result;
  }
}

class LocationsConverter implements JsonConverter<List<Location>, String> {
  static const delimiter = "-";
  static const expectedSplits = 2;

  const LocationsConverter();

  @override
  List<Location> fromJson(String json) {
    final split = json.split(delimiter);
    final splitCount = split.length;
    if (splitCount != expectedSplits) {
      throw ArgumentError(
        "Invalid JSON. Expected $expectedSplits splits."
        " Found $splitCount. \"$json\".",
      );
    }
    final timeSplit = split[0];
    final positionSplit = split[1];

    final timeDecoded = base64Decode(timeSplit);
    final positionDecoded = base64Decode(positionSplit);

    final timeList = timeDecoded.buffer.asUint64List();
    final positionList = positionDecoded.buffer.asFloat64x2List();

    final timeListLength = timeList.length;
    final positionListLength = positionList.length;
    if (timeListLength != positionListLength) {
      throw ArgumentError(
        "Invalid JSON. Time list length ($timeListLength) does"
        " not match position list ($positionListLength). \"$json\"",
      );
    }

    return List.generate(
      timeListLength,
      (i) => Location(
        dateTime: DateTime.fromMillisecondsSinceEpoch(timeList[i]),
        longitude: positionList[i].x,
        latitude: positionList[i].y,
      ),
    );
  }

  @override
  String toJson(List<Location> object) {
    final timeList = Uint64List.fromList(
      object
          .map((item) => item.dateTime.millisecondsSinceEpoch)
          .toList(growable: false),
    );

    final positionsList = Float64x2List.fromList(
      object
          .map((item) => Float64x2(item.longitude, item.latitude))
          .toList(growable: false),
    );

    final timeEncoded = base64Encode(timeList.buffer.asUint8List());
    final positionsEncoded = base64Encode(positionsList.buffer.asUint8List());

    return "$timeEncoded$delimiter$positionsEncoded";
  }
}
