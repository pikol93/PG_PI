import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';

class LoginRoute extends StatelessWidget {
  const LoginRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: const Text("Login"),
      ),
      body: const Center(
        child: Column(
          children: [
            Text("login route"),
            TextField(),
          ],
        ),
      ),
    );
  }
}
