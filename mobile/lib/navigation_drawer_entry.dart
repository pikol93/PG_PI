import 'package:flutter/material.dart';
import 'package:pi_mobile/screen_view.dart';

class NavigationDrawerEntry extends StatelessWidget {
  final ScreenView screenView;
  final IconData icon;
  final String text;
  final Function(ScreenView view) onTap;

  const NavigationDrawerEntry({
    super.key,
    required this.screenView,
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
    onTap(screenView);
  }
}
