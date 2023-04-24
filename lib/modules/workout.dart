import 'exercise.dart';

class Workout{
  late final String name;
  late final List<Exercise> exercise;
  bool isPublic;

  Workout({required this.name, required this.exercise, this.isPublic = false});
}