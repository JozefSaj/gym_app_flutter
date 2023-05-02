import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../data/workout_data.dart';
import '../component/exercise_tile.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  void onChangedCheckbox(String workoutName, String exercise){
    Provider.of<WorkoutData>(context, listen: false).checkOffExercise(workoutName, exercise);
  }

  void save(){
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      exerciseNameController,
      exerciseWeightController,
      exerciseRepsController,
      exerciseSetsController);
    Navigator.pop(context);
  }

  void cancel(){
    Navigator.pop(context);

  }

  String exerciseNameController = '';
  String exerciseWeightController = '';
  String exerciseRepsController = '';
  String exerciseSetsController = '';
  final _formKey = GlobalKey<FormState>();
  void createNewExercise(){
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: const Text("Add a new exercise"),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    onSaved: (newValue) => exerciseNameController = newValue!,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      label: Text('Exercise Name'),
                      prefixIcon: Icon(Icons.subject, size: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return "Exercise Name should not be empty";
                      }
                    },
                  ),
                  const SizedBox(height: 10
                  ),
                  TextFormField(
                    onSaved: (newValue) => exerciseWeightController = newValue!,
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      label: Text('Weight'),
                      prefixIcon: Container(child: Center
                        (child: FaIcon(FontAwesomeIcons.weightHanging),
                      ),
                        width: 40,

                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return "Weight should not be empty";
                      }
                      if (int.tryParse(value) == null) {
                        return 'Only Number are allowed';
                      }
                    },
                  ),
                  const SizedBox(height: 10
                    ),
                  TextFormField(
                    onSaved: (newValue) => exerciseRepsController = newValue!,
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      label: Text('Reps'),
                      prefixIcon: Container(child: Center
                        (child: FaIcon(FontAwesomeIcons.dumbbell),
                      ),
                        width: 40,

                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return "Reps should not be empty";
                      }
                      if (int.tryParse(value) == null) {
                        return 'Only Number are allowed';
                      }
                    },
                  ),
                  const SizedBox(height: 10
                  ),
                  TextFormField(
                    onSaved: (newValue) => exerciseSetsController = newValue!,
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      label: Text('Sets'),
                      prefixIcon: Container(child: Center
                        (child: FaIcon(FontAwesomeIcons.repeat),
                      ),
                        width: 40,

                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return "Sets should not be empty";
                      }
                      if (int.tryParse(value) == null) {
                        return 'Only Number are allowed';
                      }
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: cancel,
                  child: Text("cancel")),
              TextButton(
                  onPressed: save,
                  child: Text("save"))

            ],
          ),
        ),
      ),
    );

  }
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName, style: TextStyle(fontSize: 35),
        ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: createNewExercise,
          icon: const Icon(Icons.add),
          label: const Text('Add new exercise'),
        ),
        body: ListView.builder(
          itemCount: value.numberOfExercises(widget.workoutName),
            itemBuilder: (context, index) => ExerciseTile(
             exerciseName: value.getRelevantWorkout(widget.workoutName).exercise[index].name,
              weight: value.getRelevantWorkout(widget.workoutName).exercise[index].weight,
              reps: value.getRelevantWorkout(widget.workoutName).exercise[index].reps,
              sets: value.getRelevantWorkout(widget.workoutName).exercise[index].reps,
              isCompleted: value.getRelevantWorkout(widget.workoutName).exercise[index].isCompleted,
              onChangedCheckbox: (val) {
                onChangedCheckbox(widget.workoutName,
                    value
                        .getRelevantWorkout(widget.workoutName)
                        .exercise[index].name);
              },


              ),
        ),
      ),
    );
  }
}
