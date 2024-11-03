import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/data/collections/heart_rate.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/heart_rate_list_provider.dart";

class ModifyHeartRatePage extends ConsumerStatefulWidget {
  final HeartRate? entry;

  const ModifyHeartRatePage({
    super.key,
    this.entry,
  });

  @override
  ConsumerState<ModifyHeartRatePage> createState() =>
      _ModifyHeartRatePageState();
}

class _ModifyHeartRatePageState extends ConsumerState<ModifyHeartRatePage>
    with Logger {
  final _heartRateTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late DateTime _measurementDate;

  @override
  void initState() {
    super.initState();
    _measurementDate = widget.entry?.time ?? DateTime.now();
    final beatsPerMinute = widget.entry?.beatsPerMinute ?? 60;

    _heartRateTextEditingController.text = beatsPerMinute.toString();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Modify heart rate"), // TODO: I18N
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const Text("Date"), // TODO: I18N
              TextButton(
                onPressed: _onDatePressed,
                child: Text("$_measurementDate"),
              ),
              TextFormField(
                controller: _heartRateTextEditingController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: _validateHeartRate,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: _onSavePressed,
                    child: const Text("Save"), // TODO: I18N
                  ),
                  TextButton(
                    onPressed: _onCancelPressed,
                    child: const Text("Cancel"), // TODO: I18N
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  String? _validateHeartRate(String? value) {
    if (value == null || value.isEmpty) {
      return "No value."; // TODO: I18N
    }

    final heartRateValue = double.tryParse(value);
    if (heartRateValue == null) {
      return "Cannot parse."; // TODO: I18N
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
        const SnackBar(content: Text("Invalid form")), // TODO: I18N
      );
      return;
    }

    final heartRate = double.parse(_heartRateTextEditingController.text);
    final newEntry = (widget.entry?.clone() ?? HeartRate())
      ..time = _measurementDate
      ..beatsPerMinute = heartRate;

    logger.debug("Saving $newEntry");
    final manager = await ref.read(heartRateManagerProvider.future);
    final savedId = await manager.save(newEntry);
    logger.debug("Saved heart rate entry by ID $savedId");

    if (mounted) {
      context.pop();
    }
  }

  void _onCancelPressed() {
    context.pop();
  }
}