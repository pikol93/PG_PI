import 'package:flutter/material.dart';
import 'package:pi_mobile/app_route.dart';

class NavigationDrawerEntry extends StatelessWidget {
  final AppRoute appRoute;
  final IconData icon;
  final String text;
  final Function(AppRoute route) onTap;

  const NavigationDrawerEntry({
    super.key,
    required this.appRoute,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: _onTap,
    );
  }

  void _onTap() {
    onTap(appRoute);
  }
}
