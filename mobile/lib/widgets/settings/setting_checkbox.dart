import "package:flutter/material.dart";
import "package:pi_mobile/widgets/settings/setting.dart";

class SettingCheckbox extends StatelessWidget {
  final IconData? icon;
  final String title;
  final bool currentValue;
  final void Function(bool) onConfirmed;

  const SettingCheckbox({
    super.key,
    this.icon,
    required this.title,
    required this.currentValue,
    required this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) => Setting(
        icon: icon,
        title: title,
        onTap: () => _onSettingTapped(context),
        endWidget: Checkbox(value: currentValue, onChanged: _onCheckboxChanged),
      );

  void _onSettingTapped(BuildContext context) {
    onConfirmed(!currentValue);
  }

  void _onCheckboxChanged(bool? newValue) {
    onConfirmed(newValue ?? false);
  }
}
