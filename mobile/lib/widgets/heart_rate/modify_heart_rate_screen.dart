import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/data/heart_rate_entry.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/heart_rate_list_provider.dart";

class ModifyHeartRateScreen extends ConsumerStatefulWidget {
  final HeartRateEntry? baseEntry;

  const ModifyHeartRateScreen({
    super.key,
    this.baseEntry,
  });

  @override
  ConsumerState<ModifyHeartRateScreen> createState() =>
      _ModifyHeartRateScreenState();
}

class _ModifyHeartRateScreenState extends ConsumerState<ModifyHeartRateScreen>
    with Logger {
  final _heartRateTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late DateTime _measurementDate;

  @override
  void initState() {
    super.initState();
    _measurementDate = widget.baseEntry?.dateTime ?? DateTime.now();
    final beatsPerMinute = widget.baseEntry?.beatsPerMinute ?? 60;

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
    final newMeasurementDate = await showDatePicker(
      context: context,
      initialDate: _measurementDate,
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
    final newEntry = HeartRateEntry(
      dateTime: _measurementDate,
      beatsPerMinute: heartRate,
    );

    final notifier = ref.read(heartRateListProvider.notifier);
    if (widget.baseEntry == null) {
      logger.debug("Adding a new heart rate entry: $newEntry");
      await notifier.addEntry(newEntry);
    } else {
      logger.debug("Replacing heart rate entry ${widget.baseEntry} with $newEntry");
      await notifier.replace(widget.baseEntry!, newEntry);
    }

    if (mounted) {
      context.pop();
    }
  }

  void _onCancelPressed() {
    context.pop();
  }
}
