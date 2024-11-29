import "package:fpdart/fpdart.dart";

extension EitherExtensions<L, R> on Either<L, R> {
  R unwrap() => fold(
        (value) => throw StateError("Could not unwrap on a Left() value."),
        (value) => value,
      );
}
