import "package:flutter/material.dart";
import "package:pi_mobile/data/routine/active_session.dart";

class ActiveSessionBottomSheetHidden extends StatelessWidget {
  final ActiveSession activeSession;

  const ActiveSessionBottomSheetHidden({
    super.key,
    required this.activeSession,
  });

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Active session hidden."),
        ],
      );
}
