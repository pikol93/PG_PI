import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

extension AsyncValueExtension<T> on AsyncValue<T> {
  Widget whenDataOrDefault(
    BuildContext context,
    Widget Function(T data) widgetBuilder,
  ) =>
      when(
        data: widgetBuilder,
        error: (error, stack) => Text("$error $stack"),
        loading: () => const Center(child: CircularProgressIndicator()),
      );

  Widget whenDataOrEmptyScaffold(
    BuildContext context,
    Widget Function(T data) widgetBuilder,
  ) =>
      when(
        data: widgetBuilder,
        error: (error, stack) => Scaffold(
          body: Center(child: Text("$error $stack")),
        ),
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
}
