import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/session/active_session_service_provider.dart";
import "package:pi_mobile/widgets/routines/bottom_sheet/active_session_bottom_sheet.dart";

class AppScaffold extends ConsumerWidget {
  final AppBar appBar;
  final Widget body;
  final Widget? drawer;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.appBar,
    required this.body,
    this.drawer,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: appBar,
        body: body,
        bottomSheet: ref
            .watch(activeSessionOrNoneProvider)
            .map(
              (activeSession) => ActiveSessionBottomSheet(
                activeSession: activeSession,
              ),
            )
            .toNullable(),
        extendBodyBehindAppBar: true,
        drawer: drawer,
        floatingActionButton: floatingActionButton,
      );
}
