import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Function() onTap;
  final Widget? endWidget;

  const Setting({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.endWidget,
  });

  @override
  Widget build(BuildContext context) {
    final rowWidgets = <Widget>[];
    if (icon != null) {
      rowWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(icon),
        ),
      );
    }

    rowWidgets.add(
      buildTextWidgetsColumn(context),
    );

    if (endWidget != null) {
      rowWidgets.add(endWidget!);
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Row(
          children: rowWidgets,
        ),
      ),
    );
  }

  Widget buildTextWidgetsColumn(BuildContext context) {
    final columnWidgets = <Widget>[
      Text(
        title,
        style: context.textStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      )
    ];

    if (subtitle != null) {
      columnWidgets.add(
        Text(
          subtitle!,
          style: context.textStyles.bodyMedium,
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnWidgets,
        ),
      ),
    );
  }
}