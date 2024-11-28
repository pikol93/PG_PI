import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/provider/preferences/development_mode_provider.dart";

class DevelopmentSetting extends ConsumerWidget {
  final Widget child;

  const DevelopmentSetting({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final developmentMode = ref.watch(developmentModeProvider);
    return developmentMode ? child : const SizedBox.shrink();
  }
}
