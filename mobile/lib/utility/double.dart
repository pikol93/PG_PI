extension DoubleExtension on double {
  bool almostEquals(double other) => (this - other).abs() < 0.0001;
}
