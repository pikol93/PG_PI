import "package:fl_location/fl_location.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "location_permissions_provider.g.dart";

@riverpod
class LocationPermissions extends _$LocationPermissions with Logger {
  @override
  Future<LocationPermission> build() async {
    final locationPermission = await FlLocation.checkLocationPermission();
    logger.debug("Location permission: $locationPermission");

    return locationPermission;
  }

  Future<void> request() async {
    final locationPermissions = await FlLocation.requestLocationPermission();
    logger.debug("Permission after requesting: $locationPermissions");

    ref.invalidateSelf();
  }
}
