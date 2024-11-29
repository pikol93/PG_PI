import "dart:core";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/session/session_service_provider.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/widgets/common/app_navigation_drawer.dart";
import "package:pi_mobile/widgets/sessions/common/share_notifier.dart";
import "package:pi_mobile/widgets/sessions/sessions_history/session_history_bottom_sheet.dart";
import "package:pi_mobile/widgets/sessions/sessions_history/session_history_entry.dart";

class SessionsHistoryScreen extends ConsumerStatefulWidget {
  const SessionsHistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SessionsHistoryScreenState();
}

class _SessionsHistoryScreenState extends ConsumerState<SessionsHistoryScreen> {
  final shareNotifier = ShareNotifier();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.t.sessions.history.title),
        ),
        drawer: const AppNavigationDrawer(),
        body: ref.watch(sessionsProvider).whenDataOrDefault(
              context,
              (sessions) => ListView(
                children: sessions
                    .map(
                      (session) => SessionHistoryEntry(
                        shareNotifier: shareNotifier,
                        session: session,
                      ),
                    )
                    .toList(),
              ),
            ),
        bottomSheet: SessionsHistoryBottomSheet(shareNotifier: shareNotifier),
      );
}
