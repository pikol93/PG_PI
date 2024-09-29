import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:pi_mobile/logger.dart";

class RecordTrackScreen extends StatelessWidget with Logger {
  const RecordTrackScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: context.colors.scaffoldBackground,
          title: const Text("Record track"), // TODO: I18N
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onStopRecordingPressed(context),
          child: const Icon(Icons.stop),
        ),
        body: const Center(
          child: Text("TODO"),
        ),
      );

  void _onStopRecordingPressed(BuildContext context) {
    logger.debug("Stopped recording pressed");
    // TODO: Stop recording and move to track record result screen.
  }
}
