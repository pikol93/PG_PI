import 'package:flutter/material.dart';

class NavigationDrawerEntry extends StatelessWidget {
  final Function(BuildContext) goMethod;
  final IconData icon;
  final String text;

  const NavigationDrawerEntry({
    super.key,
    required this.goMethod,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () => _onTap(context),
    );
  }

  void _onTap(BuildContext context) {
    goMethod(context);
  }
}
