import "dart:math";

extension RandomExtension on Random {
  Duration nextDuration(Duration min, Duration max) {
    final range = max.inMilliseconds - min.inMilliseconds;
    final diff = nextInt(range);
    return min + Duration(milliseconds: diff.ceil());
  }

  int nextRange(int min, int max) {
    final range = max - min;
    final diff = nextInt(range);
    return min + diff;
  }

  double nextRangeDouble(double min, double max) {
    final range = max - min;
    final diff = nextDouble() * range;
    return min + diff;
  }
}
