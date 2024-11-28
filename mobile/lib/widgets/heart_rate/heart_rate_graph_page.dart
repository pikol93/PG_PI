import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/heart_rate/heart_rate_list_provider.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/widgets/common/x_axis_scrollable_chart.dart";

class HeartRateGraphPage extends ConsumerWidget with Logger {
  const HeartRateGraphPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultVisibleXSize = const Duration(days: 30).inMilliseconds;

    return ref.watch(heartRateChartDataProvider).when(
          data: (data) {
            if (data.isEmpty) {
              return Center(
                child: Text(context.t.general.noData),
              );
            }

            final minX = data.first.x;
            final maxX = data.last.x;
            final currentDataSize = (maxX - minX).toInt();
            final visibleXSize = currentDataSize < defaultVisibleXSize
                ? currentDataSize
                : defaultVisibleXSize;

            return Center(
              child: Column(
                children: [
                  Expanded(
                    // aspectRatio: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: XAxisScrollableChart(
                        minX: minX,
                        maxX: maxX,
                        visibleXSize: visibleXSize,
                        // TODO: This should not be a constant value
                        xScrollOffset: 0.001,
                        itemBuilder: (minX, maxX) =>
                            _chartBuilder(data, minX, maxX),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stack) => Center(
            child: Text("$error"),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }

  Widget _chartBuilder(List<FlSpot> spots, double minX, double maxX) =>
      LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _getBottomAxisTitle,
                reservedSize: 80,
                minIncluded: false,
                maxIncluded: false,
              ),
            ),
          ),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              color: Colors.red,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.redAccent.withAlpha(48),
              ),
            ),
          ],
          minY: 0.0,
          maxY: 80.0,
          minX: minX,
          maxX: maxX,
          clipData: const FlClipData.horizontal(),
        ),
      );

  Widget _getBottomAxisTitle(double value, TitleMeta meta) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final dateString = date.toIso8601String().split("T").first;
    return Transform.translate(
      offset: const Offset(0, 15),
      child: Transform.rotate(
        angle: -pi / 4.0,
        child: Text(dateString),
      ),
    );
  }
}
