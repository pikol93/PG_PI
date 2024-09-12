import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_mobile/routes/logged_in/logged_in_app_route.dart';

class NavigationDrawerEntry extends StatelessWidget {
  final LoggedInAppRoute appRoute;
  final IconData icon;
  final String text;

  const NavigationDrawerEntry({
    super.key,
    required this.appRoute,
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
    context.go(appRoute.getName());
  }
}
