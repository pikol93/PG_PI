import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:pi_mobile/widgets/common/app_navigation_drawer.dart";
import "package:pi_mobile/widgets/tracks/tracks_list.dart";

class TracksScreen extends ConsumerWidget with Logger {
  const TracksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        drawer: const AppNavigationDrawer(),
        appBar: AppBar(
          backgroundColor: context.colors.scaffoldBackground,
          title: Text(context.t.tracks.title),
        ),
        body: const TracksList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onRecordButtonPressed(context),
          child: const Icon(Icons.add),
        ),
      );

  void _onRecordButtonPressed(BuildContext context) {
    logger.debug("Record button pressed");
    const RecordTrackRoute().go(context);
  }
}
