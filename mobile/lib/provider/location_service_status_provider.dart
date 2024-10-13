import "package:fl_location/fl_location.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "location_service_status_provider.g.dart";

@riverpod
class LocationServiceStatus extends _$LocationServiceStatus {
  @override
  Future<LocationServicesStatus> build() async {
    final isLocationServiceEnabled = await FlLocation.isLocationServicesEnabled;

    if (isLocationServiceEnabled) {
      return LocationServicesStatus.enabled;
    } else {
      return LocationServicesStatus.disabled;
    }
  }

  void invalidate() {
    ref.invalidateSelf();
  }
}
