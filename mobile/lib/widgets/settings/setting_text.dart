import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/i18n/strings.g.dart';
import 'package:pi_mobile/widgets/settings/setting.dart';

class SettingText extends StatefulWidget {
  final IconData? icon;
  final String title;
  final String alertTitle;
  final String currentValue;
  final void Function(String) onConfirmed;

  const SettingText({
    super.key,
    this.icon,
    required this.title,
    this.alertTitle = "",
    required this.currentValue,
    required this.onConfirmed,
  });

  @override
  State<SettingText> createState() => _SettingTextState();
}

class _SettingTextState extends State<SettingText> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.currentValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Setting(
      icon: widget.icon,
      title: widget.title,
      subtitle: widget.currentValue,
      onTap: () => _onSettingTapped(context),
    );
  }

  Widget _builder(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.alertTitle,
        style: context.textStyles.bodyLarge,
      ),
      content: TextField(
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: () => _onConfirmPressed(context),
          child: Text(context.t.general.alert.confirm),
        ),
        TextButton(
          onPressed: () => _onCancelPressed(context),
          child: Text(context.t.general.alert.cancel),
        ),
      ],
    );
  }

  void _onSettingTapped(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: _builder,
    );
  }

  void _onConfirmPressed(BuildContext context) {
    context.navigator.pop();
    widget.onConfirmed(controller.text);
  }

  void _onCancelPressed(BuildContext context) {
    context.navigator.pop();
  }
}