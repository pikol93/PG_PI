import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/session/active_session.dart";
import "package:pi_mobile/widgets/routines/bottom_sheet/shown/active_session_bottom_sheet_shown_header.dart";
import "package:pi_mobile/widgets/routines/bottom_sheet/shown/sheet_body.dart";

class ActiveSessionBottomSheetShown extends ConsumerWidget {
  final ActiveSession activeSession;
  final void Function() onHidePressed;

  const ActiveSessionBottomSheetShown({
    super.key,
    required this.activeSession,
    required this.onHidePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          const SizedBox(height: 32.0),
          ActiveSessionBottomSheetShownHeader(
            activeSession: activeSession,
            onHidePressed: onHidePressed,
          ),
          SheetBody(activeSession: activeSession),
        ],
      );
}
