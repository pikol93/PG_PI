import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";

class NumberValueNotifier with ChangeNotifier {
  final double delta;
  final int minValue;
  final int maxValue;

  int _value;

  NumberValueNotifier({
    required double initialValue,
    required this.delta,
    double? minValueRaw,
    double? maxValueRaw,
  })  : _value = (initialValue / delta).round(),
        minValue =
            minValueRaw != null ? (minValueRaw / delta).round() : -999999999,
        maxValue =
            maxValueRaw != null ? (maxValueRaw / delta).round() : 999999999;

  double get value => _value * delta;

  void increment() {
    _value = (_value + 1).clamp(minValue, maxValue);
    notifyListeners();
  }

  void decrement() {
    _value = (_value - 1).clamp(minValue, maxValue);
    notifyListeners();
  }
}

class NumberInput extends StatelessWidget {
  final String? title;
  final String Function(double) formatter;
  final NumberValueNotifier valueNotifier;
  final double horizontalSize;

  const NumberInput({
    super.key,
    required this.title,
    required this.formatter,
    required this.valueNotifier,
    this.horizontalSize = 72.0,
  });

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    if (title != null) {
      widgets.add(
        Text(
          title!,
          style: context.textStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    widgets.add(
      Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(4),
              ),
            ),
            child: Center(
              child: IconButton(
                onPressed: _onDecrementPressed,
                icon: const Icon(Icons.remove),
              ),
            ),
          ),
          SizedBox(
            width: horizontalSize,
            child: Center(
              child: _NumberInputInternal(
                formatter: formatter,
                valueNotifier: valueNotifier,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(4),
              ),
            ),
            child: Center(
              child: IconButton(
                onPressed: _onIncrementPressed,
                icon: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );

    return Column(
      children: widgets,
    );
  }

  void _onIncrementPressed() => valueNotifier.increment();

  void _onDecrementPressed() => valueNotifier.decrement();
}

class _NumberInputInternal extends StatelessWidget {
  final String Function(double) formatter;
  final NumberValueNotifier valueNotifier;

  const _NumberInputInternal({
    required this.formatter,
    required this.valueNotifier,
  });

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: valueNotifier,
        builder: (context, child) {
          final value = formatter(valueNotifier.value);
          return Text(value);
        },
      );
}
