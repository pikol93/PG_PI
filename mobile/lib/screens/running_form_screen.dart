import 'package:flutter/material.dart';

class RunningFormScreen extends StatelessWidget {
  const RunningFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Field 1'),
            const TextField(),
            const TextField(
              decoration: InputDecoration(labelText: 'Field 2'),
            ),
            ElevatedButton(
              onPressed: () {
                print("XD");
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
