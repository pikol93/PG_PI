import "package:package_info_plus/package_info_plus.dart" as package_info_plus;
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "package_info_provider.g.dart";

@Riverpod(keepAlive: true)
class PackageInfo extends _$PackageInfo with Logger {
  package_info_plus.PackageInfo packageInfo = package_info_plus.PackageInfo(
    appName: "",
    packageName: "",
    version: "",
    buildNumber: "",
  );

  @override
  package_info_plus.PackageInfo build() {
    logger.debug("Read package info: $packageInfo");
    return packageInfo;
  }

  Future<void> init() async {
    final newInstance = await package_info_plus.PackageInfo.fromPlatform();
    packageInfo = newInstance;
    ref.invalidateSelf();
  }
}
