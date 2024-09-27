import "package:pi_mobile/data/connection_settings_state.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/utility/shared_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "connection_settings_provider.g.dart";

@Riverpod(keepAlive: true)
class ConnectionSettings extends _$ConnectionSettings with Logger {
  static const keyName = "connection_settings";

  @override
  Future<ConnectionSettingsState> build() async {
    final preferences = SharedPreferencesAsync();
    return await preferences.getFromJson(
          keyName,
          ConnectionSettingsState.fromJson,
        ) ??
        const ConnectionSettingsState(serverAddress: "server.xyz");
  }

  Future<void> updateServerAddress(String serverAddress) async {
    // TODO: This operation probably does not require us
    //  to write and read from shared preferences.
    logger.debug("Setting server address as $serverAddress...");
    final preferences = SharedPreferencesAsync();
    await preferences.setToJson(
      keyName,
      ConnectionSettingsState(serverAddress: serverAddress),
    );

    ref.invalidateSelf();
  }
}
