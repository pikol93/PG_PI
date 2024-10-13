import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/provider/selected_track_provider.dart";

class TrackDetailsScreen extends ConsumerWidget {
  const TrackDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(
          backgroundColor: context.colors.scaffoldBackground,
          title: const Text("Track details"), // TODO: I18N
        ),
        body: ref.watch(selectedTrackProvider).when(
              data: (track) => Center(
                child: Text("${track?.averageVelocity}"),
              ),
              error: (a, b) => Center(
                child: Text("Error $b"),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
      );
}
