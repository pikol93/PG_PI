import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/widgets/settings/setting.dart';

class SettingOption<T> extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String alertTitle;
  final List<T> possibleValues;
  final T currentValue;
  final String Function(T) itemToDisplayMapper;
  final void Function(T?) onConfirmed;

  const SettingOption({
    super.key,
    this.icon,
    required this.title,
    required this.alertTitle,
    required this.possibleValues,
    required this.currentValue,
    required this.itemToDisplayMapper,
    required this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    final currentValueString = itemToDisplayMapper.call(currentValue);
    return Setting(
      icon: icon,
      title: title,
      subtitle: currentValueString,
      onTap: () => _onSettingTapped(context),
    );
  }

  Widget _builder(BuildContext context) {
    return SimpleDialog(
      title: Text(alertTitle),
      children: possibleValues
          .map(
            (value) => RadioListTile<T>(
          value: value,
          groupValue: currentValue,
          title: Text(itemToDisplayMapper.call(value)),
          onChanged: (value) => _onConfirmPressed(context, value),
        ),
      )
          .toList(),
    );
  }

  void _onSettingTapped(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: _builder,
    );
  }

  void _onConfirmPressed(BuildContext context, T? value) {
    context.navigator.pop();
    onConfirmed(value);
  }
}