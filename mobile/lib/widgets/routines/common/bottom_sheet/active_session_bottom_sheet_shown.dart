import "package:flutter/material.dart";
import "package:pi_mobile/data/routine/active_session.dart";

class ActiveSessionBottomSheetShown extends StatelessWidget {
  final ActiveSession activeSession;

  const ActiveSessionBottomSheetShown({
    super.key,
    required this.activeSession,
  });

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Active session shown."),
        ],
      );
}
