import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/heart_rate/heart_rate.dart";
import "package:pi_mobile/data/heart_rate/heart_rate_list_provider.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/widgets/heart_rate/modify_heart_rate_page.dart";

class ModifyHeartRateScreen extends ConsumerStatefulWidget {
  final int? entryId;

  const ModifyHeartRateScreen({
    super.key,
    this.entryId,
  });

  @override
  ConsumerState<ModifyHeartRateScreen> createState() =>
      _ModifyHeartRateScreenState();
}

class _ModifyHeartRateScreenState extends ConsumerState<ModifyHeartRateScreen>
    with Logger {
  late final Future<HeartRate?> _readEntryFuture;

  @override
  void initState() {
    super.initState();
    _readEntryFuture = _readEntry();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _readEntryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ModifyHeartRatePage(
            entry: snapshot.data,
          );
        },
      );

  Future<HeartRate?> _readEntry() async {
    if (widget.entryId == null) {
      return null;
    }
    final heartRateManager = await ref.read(heartRateManagerProvider.future);

    return heartRateManager.getById(widget.entryId!);
  }
}
