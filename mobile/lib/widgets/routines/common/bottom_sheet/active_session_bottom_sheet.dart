import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/routine/active_session.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/widgets/routines/common/bottom_sheet/active_session_bottom_sheet_hidden.dart";
import "package:pi_mobile/widgets/routines/common/bottom_sheet/bottom_sheet_visibility_provider.dart";
import "package:pi_mobile/widgets/routines/common/bottom_sheet/shown/active_session_bottom_sheet_shown.dart";

class ActiveSessionBottomSheet extends ConsumerStatefulWidget {
  final ActiveSession activeSession;

  const ActiveSessionBottomSheet({super.key, required this.activeSession});

  @override
  ConsumerState<ActiveSessionBottomSheet> createState() =>
      _ActiveSessionBottomSheetState();
}

class _ActiveSessionBottomSheetState
    extends ConsumerState<ActiveSessionBottomSheet> with Logger {
  static const double minSnapSize = 0.1;
  static const double maxSnapSize = 1.0;
  static const double sizeThreshold = 0.2;
  static const double startingSize = maxSnapSize;
  static const List<double> snapSizes = [
    minSnapSize,
    maxSnapSize,
  ];

  late final double initialChildSize;

  final controller = DraggableScrollableController();

  CrossFadeState crossFadeState = _sizeToCrossFadeState(startingSize);

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerUpdated);
    crossFadeState = _visibilityToCrossFadeState(
      ref.read(bottomSheetVisibilityProvider),
    );
    initialChildSize = _crossFadeStateToSize(crossFadeState);
    logger.debug("$crossFadeState, $initialChildSize");
  }

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minSnapSize,
        maxChildSize: maxSnapSize,
        snapSizes: snapSizes,
        snap: true,
        expand: false,
        controller: controller,
        builder: (context, scrollController) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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

      ref.read(bottomSheetVisibilityProvider.notifier).state =
          _crossFadeStateToVisibility(newCrossFadeState);
    }
  }

  static CrossFadeState _sizeToCrossFadeState(double size) =>
      size < sizeThreshold
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst;

  static double _crossFadeStateToSize(
    CrossFadeState value,
  ) =>
      switch (value) {
        CrossFadeState.showFirst => maxSnapSize,
        CrossFadeState.showSecond => minSnapSize,
      };

  static CrossFadeState _visibilityToCrossFadeState(
    BottomSheetVisibility value,
  ) =>
      switch (value) {
        BottomSheetVisibility.visible => CrossFadeState.showFirst,
        BottomSheetVisibility.collapsed => CrossFadeState.showSecond,
      };

  static BottomSheetVisibility _crossFadeStateToVisibility(
    CrossFadeState value,
  ) =>
      switch (value) {
        CrossFadeState.showFirst => BottomSheetVisibility.visible,
        CrossFadeState.showSecond => BottomSheetVisibility.collapsed,
      };
}
