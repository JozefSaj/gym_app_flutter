import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../modules/exercise.dart';
import '../modules/workout.dart';

class WorkoutData extends ChangeNotifier{

  List<Workout> workoutList = [
    Workout(name: "Public Upper Body",
      exercise: [Exercise(
        name: "Lat Pulldown", weight: "50", reps: "10", sets: "3"),],
      isPublic: true,
    ),
    Workout(name: "Public Lower body",
      exercise: [Exercise(
          name: "Lat Pulldown", weight: "50", reps: "10", sets: "3"),],
      isPublic: true,
    ),

  ];



  List<Workout> getWorkoutList() {
    return workoutList;
  }

  void rename(String name){

  }

  void addWorkout(String name, {public = false}){
    workoutList.add(Workout(name: name, exercise: [], isPublic: public));
    notifyListeners();

  }

  int numberOfExercises(String workoutName){
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercise.length;
  }

  void addExercise(String workoutName, String exerciseName, String weight, String reps, String sets){
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercise.add(
        Exercise(name: exerciseName,
            weight: weight,
            reps: reps,
            sets: sets));

    notifyListeners();

  }


  void checkOffExercise(String workoutName, String exerciseName){
    Exercise exercise = getRelevantExercise(workoutName, exerciseName);
    exercise.isCompleted = !exercise.isCompleted;
    notifyListeners();

  }

  Workout getRelevantWorkout(String workoutName){
    return workoutList.firstWhere((workout) => workout.name == workoutName);
  }

  Exercise getRelevantExercise(String workoutName, String exerciseName){
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercise.firstWhere((exercise) => exercise.name == exerciseName);
  }





}