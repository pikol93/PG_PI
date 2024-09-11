import 'package:flutter/material.dart';
import 'package:pi_mobile/routes/logged_off/welcome_route.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeRoute(),
    ),
  );
}
