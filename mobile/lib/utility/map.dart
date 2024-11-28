import "package:fpdart/fpdart.dart";

extension MapExtension<K, V> on Map<K, V> {
  Option<V> get(K key) {
    final value = this[key];
    if (value == null) {
      return Option.none();
    }

    return Option.of(value);
  }
}
