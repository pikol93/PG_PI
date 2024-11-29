import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:loggy/loggy.dart";
import "package:pi_mobile/data/connection/connection_settings.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/utility/shared_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "connection_settings_provider.g.dart";

const serverAddressKeyName = "server_address";

@riverpod
Future<String> serverAddress(Ref ref) async {
  final connectionSettings = await ref.watch(connectionSettingsProvider.future);
  final serverAddress = connectionSettings.getAddress();
  logDebug("Read server address: $serverAddress");
  return serverAddress;
}

@riverpod
Future<bool> connectionSecure(Ref ref) async {
  final connectionSettings = await ref.watch(connectionSettingsProvider.future);
  return connectionSettings.isSecure;
}

@riverpod
Future<ConnectionSettings> connectionSettings(Ref ref) async {
  final storedConnectionSettings = await SharedPreferencesAsync().getFromJson(
    serverAddressKeyName,
    ConnectionSettings.fromJson,
  );

  return storedConnectionSettings ??
      const ConnectionSettings(
        serverAddress: "server.xyz",
        isSecure: true,
      );
}

@riverpod
ConnectionSettingsService connectionSettingsService(Ref ref) =>
    ConnectionSettingsService(ref: ref);

class ConnectionSettingsService with Logger {
  final Ref ref;

  ConnectionSettingsService({required this.ref});

  Future<void> updateServerAddress(String newValue) async {
    logger.debug("Updating server address: $newValue");
    final current = await ref.read(connectionSettingsProvider.future);
    await SharedPreferencesAsync().setToJson(
      serverAddressKeyName,
      current.copyWith(serverAddress: newValue),
    );

    ref.invalidate(connectionSettingsProvider);
  }

  Future<void> updateSecure(bool newValue) async {
    logger.debug("Updating secure: $newValue");
    final current = await ref.read(connectionSettingsProvider.future);
    await SharedPreferencesAsync().setToJson(
      serverAddressKeyName,
      current.copyWith(isSecure: newValue),
    );

    ref.invalidate(connectionSettingsProvider);
  }
}
