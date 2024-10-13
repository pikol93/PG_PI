extension IterableNumberExtension on Iterable<num> {
  double get averageOrDefault {
    var result = 0.0;
    var count = 0;
    for (var value in this) {
      count += 1;
      result += (value - result) / count;
    }
    return result;
  }
}
