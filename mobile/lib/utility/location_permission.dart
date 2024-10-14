import "package:fl_location/fl_location.dart";

extension LocationPermissionExtension on LocationPermission {
  bool get isSuccess =>
      this == LocationPermission.always ||
      this == LocationPermission.whileInUse;

  bool get isFailure => !isSuccess;
}
