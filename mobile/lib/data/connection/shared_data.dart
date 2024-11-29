import "package:freezed_annotation/freezed_annotation.dart";

part "shared_data.g.dart";
part "shared_data.freezed.dart";

@freezed
class SharedData with _$SharedData {
  const factory SharedData({
    required String something,
    required String something2,
  }) = _SharedData;

  factory SharedData.fromJson(Map<String, Object?> json) =>
      _$SharedDataFromJson(json);
}
