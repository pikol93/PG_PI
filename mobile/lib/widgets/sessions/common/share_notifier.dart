import "package:flutter/material.dart";
import "package:pi_mobile/utility/map.dart";
import "package:pi_mobile/utility/option.dart";

class ShareNotifier extends ChangeNotifier {
  final Map<int, bool> _pressedMap = {};

  bool isPressed(int sessionId) => _pressedMap.get(sessionId).orElse(false);

  void set(int sessionId, bool value) {
    _pressedMap[sessionId] = value;
    notifyListeners();
  }

  List<int> getSelectedSessions() => _pressedMap.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();

  bool isAnySelected() => _pressedMap.values.any((value) => value);

  int getSelectedCount() => _pressedMap.values.where((value) => value).length;
}
