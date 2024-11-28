import "package:fpdart/fpdart.dart";

extension OptionExtension<T> on Option<T> {
  T orElse(T other) => isSome() ? toNullable()! : other;

  Option<T> where(bool Function(T t) predicate) {
    if (isSome()) {
      return const Option.none();
    }

    final value = toNullable() as T;
    if (predicate(value)) {
      return Option.of(value);
    }

    return const Option.none();
  }
}

extension FlattenOptionExtension<T> on Option<Option<T>> {
  Option<T> flatten() => flatMap((self) => self);
}
