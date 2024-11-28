import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/routine/active_session.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/widgets/routines/bottom_sheet/active_session_bottom_sheet_hidden.dart";
import "package:pi_mobile/widgets/routines/bottom_sheet/bottom_sheet_visibility_provider.dart";
import "package:pi_mobile/widgets/routines/bottom_sheet/shown/active_session_bottom_sheet_shown.dart";

class ActiveSessionBottomSheet extends ConsumerStatefulWidget {
  final ActiveSession activeSession;

  const ActiveSessionBottomSheet({super.key, required this.activeSession});

  @override
  ConsumerState<ActiveSessionBottomSheet> createState() =>
      _ActiveSessionBottomSheetState();
}

class _ActiveSessionBottomSheetState
    extends ConsumerState<ActiveSessionBottomSheet> with Logger {
  static const Duration animationDuration = Duration(milliseconds: 300);
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
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: context.colors.scheme.primaryContainer,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            controller: scrollController,
            child: AnimatedCrossFade(
              duration: animationDuration,
              crossFadeState: crossFadeState,
              firstChild: ActiveSessionBottomSheetShown(
                activeSession: widget.activeSession,
                onHidePressed: _onHidePressed,
              ),
              secondChild: ActiveSessionBottomSheetHidden(
                activeSession: widget.activeSession,
                onShowPressed: _onShowPressed,
              ),
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

  void _onShowPressed() {
    controller.animateTo(
      maxSnapSize,
      duration: animationDuration,
      curve: Curves.easeInOutCubic,
    );
  }

  void _onHidePressed() {
    controller.animateTo(
      minSnapSize,
      duration: animationDuration,
      curve: Curves.easeInOutCubic,
    );
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
