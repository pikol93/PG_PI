import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/i18n/strings.g.dart';
import 'package:pi_mobile/widgets/settings/setting.dart';

class SettingButton extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final bool requiresConfirmation;
  final String alertTitle;
  final String? alertContent;
  final void Function() onConfirmed;

  const SettingButton({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.requiresConfirmation = false,
    this.alertTitle = "",
    this.alertContent,
    required this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Setting(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: () => _onSettingTapped(context),
    );
  }

  Widget _builder(BuildContext context) {
    return AlertDialog(
      title: Text(
        alertTitle,
        style: context.textStyles.bodyLarge,
      ),
      content: alertContent == null
          ? null
          : Text(
              alertContent!,
              style: context.textStyles.bodySmall,
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
    if (requiresConfirmation) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: _builder,
      );
    } else {
      onConfirmed();
    }
  }

  void _onConfirmPressed(BuildContext context) {
    context.navigator.pop();
    onConfirmed();
  }

  void _onCancelPressed(BuildContext context) {
    context.navigator.pop();
  }
}
