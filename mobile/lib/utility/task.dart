import "package:fpdart/fpdart.dart";

extension IterableTask<T> on Iterable<Task<T>> {
  Task<List<T>> joinAll() => Task(
        () => map((item) => item.run()).wait,
      );
}
