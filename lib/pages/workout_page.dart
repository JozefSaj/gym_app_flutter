import 'package:flutter/material.dart';
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
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      exerciseNameController.text,
      exerciseWeightController.text,
      exerciseRepsController.text,
      exerciseSetsController.text);
    Navigator.pop(context);
    exerciseNameController.clear();
    exerciseWeightController.clear();
    exerciseRepsController.clear();
    exerciseSetsController.clear();
  }

  void cancel(){
    Navigator.pop(context);
    exerciseNameController.clear();
    exerciseWeightController.clear();
    exerciseRepsController.clear();
    exerciseSetsController.clear();
  }

  final exerciseNameController = TextEditingController();
  final exerciseWeightController = TextEditingController();
  final exerciseRepsController = TextEditingController();
  final exerciseSetsController = TextEditingController();
  void createNewExercise(){
    showDialog(context: context,
        builder: (context) => AlertDialog(
          title: Text('Add  a new exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

          TextField(
            controller: exerciseNameController,
          ),
          TextField(
            controller: exerciseWeightController,
          ),
          TextField(
            controller: exerciseRepsController,
          ),

          TextField(
            controller: exerciseSetsController,
          ),

          ],),
          actions: [
            MaterialButton(
                onPressed: save,
                child: Text("save")),
            MaterialButton(
                onPressed: cancel,
                child: Text("cancel")),
          ],
        ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: Icon(Icons.add),
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
