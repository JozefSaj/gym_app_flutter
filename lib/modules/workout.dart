import 'exercise.dart';

class Workout{
  String name;
  final List<Exercise> exercise;
  bool isPublic;

  Workout({required this.name, required this.exercise, this.isPublic = false});
}