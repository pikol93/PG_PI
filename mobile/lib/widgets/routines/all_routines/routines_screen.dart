import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/routine/routine_with_usage.dart";
import "package:pi_mobile/provider/routine/routines_with_usage_provider.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/widgets/common/app_navigation_drawer.dart";
import "package:pi_mobile/widgets/common/scaffold/app_scaffold.dart";
import "package:pi_mobile/widgets/routines/all_routines/single_routine_entry_widget.dart";

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppScaffold(
        appBar: AppBar(
          title: Text(context.t.routines.title),
        ),
        drawer: const AppNavigationDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              _RecentRoutinesSection(),
              _OtherRoutinesSection(),
            ],
          ),
        ),
      );
}

class _RecentRoutinesSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
          .watch(routinesWithUsageLastMonthSortedByTimeProvider)
          .whenDataOrDefault(context, (data) {
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }

        return _Section(
          sectionName: context.t.routines.yourRoutines,
          entryNames: data,
        );
      });
}

class _OtherRoutinesSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(routinesWithUsageSortedByNameProvider).whenDataOrDefault(
            context,
            (data) => _Section(
              sectionName: context.t.routines.otherRoutines,
              entryNames: data,
            ),
          );
}

class _Section extends StatelessWidget {
  final String sectionName;
  final List<RoutineWithUsage> entryNames;

  const _Section({
    required this.sectionName,
    required this.entryNames,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(sectionName: sectionName),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: entryNames
                .map(
                  (routine) => SingleRoutineEntryWidget(
                    routineName: routine.routine.name,
                    routineId: routine.routine.id,
                    author: routine.routine.author,
                    lastUsageTime: routine.getMostRecentDateTime(),
                  ),
                )
                .toList(),
          ),
        ],
      );
}

class _SectionHeader extends StatelessWidget {
  final String sectionName;

  const _SectionHeader({required this.sectionName});

  @override
  Widget build(BuildContext context) => Text(
        sectionName,
        style: context.textStyles.headlineLarge,
      );
}
