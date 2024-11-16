import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/date_formatter_provider.dart";
import "package:pi_mobile/provider/one_rep_max_service_provider.dart";

class ExerciseModifySpecificOneRepMaxScreen extends ConsumerStatefulWidget {
  final int exerciseId;
  final DateTime? date;

  const ExerciseModifySpecificOneRepMaxScreen({
    super.key,
    required this.exerciseId,
    this.date,
  });

  @override
  ConsumerState<ExerciseModifySpecificOneRepMaxScreen> createState() =>
      _ExerciseModifySpecificOneRepMaxScreenState();
}

class _ExerciseModifySpecificOneRepMaxScreenState
    extends ConsumerState<ExerciseModifySpecificOneRepMaxScreen> with Logger {
  static const _defaultOneRepMax = 60.0;
  static const _buttonSizedBoxWidget = SizedBox(width: 16.0);

  final _heartRateTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late DateTime _measurementDate;

  @override
  void initState() {
    super.initState();
    _measurementDate = widget.date ?? DateTime.now();
    _heartRateTextEditingController.text = _defaultOneRepMax.toString();
    unawaited(
      _fetchAndSetOneRepMax(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = ref.watch(dateFormatterProvider);

    final buttons = [
      ElevatedButton(
        onPressed: _onSavePressed,
        child: Text(context.t.common.save),
      ),
      _buttonSizedBoxWidget,
      ElevatedButton(
        onPressed: _onCancelPressed,
        child: Text(context.t.common.cancel),
      ),
    ];

    if (widget.date != null) {
      buttons.add(_buttonSizedBoxWidget);
      buttons.add(
        ElevatedButton(
          onPressed: _onDeletePressed,
          child: Text(context.t.common.delete),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Modify"), // TODO: I18N
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Text(context.t.common.date),
            TextButton(
              onPressed: _onDatePressed,
              child: Text(dateFormatter.fullDate(_measurementDate)),
            ),
            TextFormField(
              controller: _heartRateTextEditingController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: _validateOneRepMax,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buttons,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchAndSetOneRepMax() async {
    final oneRepMax = await _fetchOneRepMax() ?? _defaultOneRepMax;

    // TODO: This is awful
    _heartRateTextEditingController.text = oneRepMax.toStringAsFixed(1);
  }

  Future<double?> _fetchOneRepMax() async {
    final service = await ref.read(oneRepMaxServiceProvider.future);
    if (widget.date != null) {
      return service
          .getOneRepMax(widget.exerciseId, widget.date!)
          .map((item) => item.getOrElse(() => _defaultOneRepMax))
          .run();
    }

    return _defaultOneRepMax;
  }

  String? _validateOneRepMax(String? value) {
    if (value == null || value.isEmpty) {
      return "${context.t.error.noValue}.";
    }

    final heartRateValue = double.tryParse(value);
    if (heartRateValue == null) {
      return "${context.t.error.cannotParse}.";
    }

    return null;
  }

  Future<void> _onDatePressed() async {
    final now = DateTime.now();
    final newMeasurementDate = await showDatePicker(
      context: context,
      initialDate: _measurementDate.isAfter(now) ? now : _measurementDate,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime.now(),
    );

    if (newMeasurementDate == null) {
      logger.debug("No date picked.");
      return;
    }

    setState(() {
      _measurementDate = newMeasurementDate;
    });
  }

  Future<void> _onSavePressed() async {
    final isValidated = _formKey.currentState!.validate();
    if (!isValidated) {
      logger.debug("Form is not validated.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.heartRate.invalidForm)),
      );
      return;
    }

    final oneRepMax = double.parse(_heartRateTextEditingController.text);
    final service = await ref.read(oneRepMaxServiceProvider.future);

    await service
        .insertEntry(widget.exerciseId, _measurementDate, oneRepMax)
        .run();

    if (mounted) {
      context.pop();
    }
  }

  void _onCancelPressed() {
    context.pop();
  }

  Future<void> _onDeletePressed() async {
    if (widget.date == null) {
      logger.debug("Cannot remove entry without a date.");
      return;
    }

    final service = await ref.read(oneRepMaxServiceProvider.future);
    await service.removeEntry(widget.exerciseId, widget.date!).run();

    if (mounted) {
      context.pop();
    }
  }
}
