import "package:fpdart/fpdart.dart";

extension ListExtension<T> on List<T> {
  Option<T> get(int index) {
    if (index < 0 || index >= length) {
      return const Option.none();
    }

    return Option.of(this[index]);
  }

  List<T> rebuildAtIndex(int index, T Function(T t) mapper) {
    final cloned = toList();
    cloned[index] = mapper(cloned[index]);
    return cloned;
  }
}
