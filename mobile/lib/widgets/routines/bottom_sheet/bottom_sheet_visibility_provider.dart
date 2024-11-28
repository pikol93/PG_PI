import "package:flutter_riverpod/flutter_riverpod.dart";

enum BottomSheetVisibility {
  collapsed,
  visible,
}

final bottomSheetVisibilityProvider = StateProvider<BottomSheetVisibility>(
  (ref) => BottomSheetVisibility.visible,
);
