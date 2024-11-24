import "package:flutter/material.dart";
import "package:pi_mobile/data/routine/active_session.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/widgets/routines/common/active_session_bottom_sheet_hidden.dart";
import "package:pi_mobile/widgets/routines/common/active_session_bottom_sheet_shown.dart";

class ActiveSessionBottomSheet extends StatefulWidget {
  final ActiveSession activeSession;

  const ActiveSessionBottomSheet({super.key, required this.activeSession});

  @override
  State<ActiveSessionBottomSheet> createState() =>
      _ActiveSessionBottomSheetState();
}

class _ActiveSessionBottomSheetState extends State<ActiveSessionBottomSheet>
    with Logger {
  static const double minSnapSize = 0.1;
  static const double maxSnapSize = 1.0;
  static const double sizeThreshold = 0.2;
  static const double startingSize = maxSnapSize;
  static const List<double> snapSizes = [
    minSnapSize,
    maxSnapSize,
  ];

  final controller = DraggableScrollableController();

  CrossFadeState crossFadeState = _sizeToCrossFadeState(startingSize);

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerUpdated);
  }

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        initialChildSize: startingSize,
        minChildSize: minSnapSize,
        maxChildSize: maxSnapSize,
        snapSizes: snapSizes,
        snap: true,
        expand: false,
        controller: controller,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: crossFadeState,
            firstChild: ActiveSessionBottomSheetShown(
              activeSession: widget.activeSession,
            ),
            secondChild: ActiveSessionBottomSheetHidden(
              activeSession: widget.activeSession,
            ),
          ),
        ),
      );

  void _onControllerUpdated() {
    final newCrossFadeState = _sizeToCrossFadeState(controller.size);

    if (newCrossFadeState != crossFadeState) {
      logger.debug(
        "Setting bottom sheet cross fade: "
        "$crossFadeState -> $newCrossFadeState",
      );
      setState(() {
        crossFadeState = newCrossFadeState;
      });
    }
  }

  static CrossFadeState _sizeToCrossFadeState(double size) =>
      size < sizeThreshold
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst;
}
