import "package:fpdart/fpdart.dart";

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

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> uniqueByKey<U>(U Function(T t) keyMapper) {
    final set = <U>{};

    return where((item) {
      final key = keyMapper(item);

      final setLengthBefore = set.length;
      set.add(key);
      final setLengthAfter = set.length;

      return setLengthBefore != setLengthAfter;
    });
  }

  Iterable<T> unique() => uniqueByKey((item) => item);
}

extension MapEntryIterableExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => Map.fromEntries(this);
}

extension OptionIterableExtension<T> on Iterable<Option<T>> {
  Iterable<T> flattenOptions() => map((item) => item.toNullable())
      .where((item) => item != null)
      .map((item) => item!);
}
