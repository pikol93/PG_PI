import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pi_mobile/logger.dart';
import 'package:pi_mobile/provider/auth_provider.dart';
import 'package:pi_mobile/routing/routes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with Logger {
  final textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: const Text("Login"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("login route"),
            TextField(
              controller: textController,
            ),
            ElevatedButton(
              onPressed: _onLoginButtonPressed,
              child: const Text("Log in"),
            )
          ],
        ),
      ),
    );
  }

  void _onLoginButtonPressed() async {
    final username = textController.text;
    if (username.isEmpty) {
      logger.debug("Cannot log in with empty username.");
      return;
    }

    logger.debug("Login button pressed. Username = $username");
    await ref.read(authProvider.notifier).logIn(username);

    // TODO: As of now, every attempt to login is successful. Handle cases where logging in fails.
    if (mounted) {
      const RootRoute().go(context);
    }
  }
}
