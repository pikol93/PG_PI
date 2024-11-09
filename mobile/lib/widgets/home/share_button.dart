import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/sharing_service_provider.dart";

class ShareButton extends ConsumerWidget with Logger {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      FloatingActionButton(onPressed: () => _onSharePressed(ref));

  Future<void> _onSharePressed(WidgetRef ref) async {
    final sharingService = await ref.read(sharingServiceProvider.future);
    final result = await sharingService
        .share(
          ShareRequest(
            validityMillis: const Duration(days: 7).inMilliseconds,
            dataToShare: const DataToShare(
              something: "something",
              something2: "something2",
            ),
          ),
        )
        .run();

    logger.debug("Result: $result");
  }
}
