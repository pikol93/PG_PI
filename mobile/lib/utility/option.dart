import "package:fpdart/fpdart.dart";

extension OptionExtension<T> on Option<T> {
  T orElse(T other) => isSome() ? toNullable()! : other;
}

extension FlattenOptionExtension<T> on Option<Option<T>> {
  Option<T> flatten() => flatMap((self) => self);
}
