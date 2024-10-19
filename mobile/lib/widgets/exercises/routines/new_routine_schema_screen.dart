import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class NewRoutineSchemaScreen extends ConsumerStatefulWidget {
  final String routineUuid;

  const NewRoutineSchemaScreen({super.key, required this.routineUuid});

  @override
  ConsumerState<NewRoutineSchemaScreen> createState() =>
      _NewRoutineSchemaScreenState();
}

class _NewRoutineSchemaScreenState
    extends ConsumerState<NewRoutineSchemaScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Add new Routine"),
        ),
        body:
            // ref.watch(routinesProvider).when(
            //   error: (error, stack) => Text("Could not fetch routines. $error"),
            //   loading: () => const Center(child: CircularProgressIndicator()),
            //   data: (routines) => ListView.builder(
            //     padding: const EdgeInsets.all(8),
            //     itemCount: routines.length,
            //     itemBuilder: (context, index) => ListTile(
            //       title: Text(routines[index].name),
            //       subtitle: Text(routines[index].uuid),
            //     ),
            //   ),
            // ),

            Text("Tutaj wskakują workouty + ${widget.routineUuid}"),

        //   ref.watch(routinesProvider.notifier).getWorkouts(routineUuid);
        //   error: (error, stack) => Text("Could not fetch workouts. $error"),
        // loading: () => const Center(child: CircularProgressIndicator()),
        // data: (routines) => ListView.builder(
        // padding: const EdgeInsets.all(8),
        // itemCount: (routines)
        // itemBuilder: (context, index) => ListTile(
        // title: Text(routines[index].name),
        // subtitle: Text(routines[index].uuid),
        // ),
        // ),

        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       TextField(
        //         controller: _nameController,
        //         decoration: const InputDecoration(
        //           labelText: "Routine name:",
        //           border: OutlineInputBorder(),
        //         ),
        //       ),
        //       const SizedBox(height: 16.0),
        //       TextField(
        //         controller: _descriptionController,
        //         decoration: const InputDecoration(
        //           labelText: "Description:",
        //           border: OutlineInputBorder(),
        //         ),
        //         maxLines: 3,
        //       ),
        //       const SizedBox(height: 24.0),
        //       const Text(
        //         "Workouts:",
        //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //       ),
        //       const SizedBox(height: 8.0),
        //       // Expanded(
        //       //   child: GridView.count(
        //       //     crossAxisCount: 2,
        //       //     crossAxisSpacing: 10,
        //       //     mainAxisSpacing: 10,
        //       //     children: workoutSchemas
        //       //         .map(
        //       //           (workoutSchema) => ActivityTile(
        //       //         headline: workoutSchema.name,
        //       //         imagePath: "assets/backsquad.png",
        //       //         screen: const EditWorkoutSchemaScreen(),
        //       //       ),
        //       //     )
        //       //         .toList(),
        //       //   ),
        //       // ),
        //
        //       const SizedBox(height: 16.0),
        //       Center(
        //         child: ElevatedButton.icon(
        //           onPressed: () async {
        //             final result = await Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => const NewWorkoutSchemaScreen(),
        //               ),
        //             );
        //             workoutSchemas.add(result);
        //           },
        //           icon: const Icon(Icons.add),
        //           label: const Text("Add Workout"),
        //         ),
        //       ),
        //       const SizedBox(height: 24.0),
        //       Center(
        //         child: ElevatedButton(
        //           onPressed: () {
        //             String name = _nameController.text;
        //             String description = _descriptionController.text;
        //             RoutineSchema rs = RoutineSchema(
        //                 name: name,
        //                 description: description,
        //                 workouts: workoutSchemas);
        //
        //             if (name.isNotEmpty) {
        //               Navigator.pop(context, rs);
        //             } else {
        //               // Wskazanie, że nazwa jest wymagana
        //               ScaffoldMessenger.of(context).showSnackBar(
        //                 const SnackBar(
        //                   content: Text('Routine Name is required'),
        //                 ),
        //               );
        //             }
        //           },
        //           child: const Text('Save'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      );
}
