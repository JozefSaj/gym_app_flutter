import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  final void Function(bool?)? onChangedCheckbox;

  const ExerciseTile({super.key, required this.exerciseName,
                                  required this.weight, required this.reps,
                                  required this.sets, required this.isCompleted,
                                  required this.onChangedCheckbox});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: ListTile(
        title: TextButton(
          onPressed: () {  },
          child: Text(exerciseName, style: TextStyle(fontSize: 25)
          ),
        ),
        subtitle: Row(
          children: [
            Chip(
                label: SizedBox(
                  height: 40,
                  width: 70,
                  child: TextButton(
                    onPressed: () {  },
                    child: Text("$weight  kg"),

                  ),
                )
            ),
            Chip(
                label:SizedBox(
                  height: 40,
                  width: 70,
                  child: TextButton(
                    onPressed: () {  },
                    child: Text("$reps  reps"),

                  ),
                )
            ),
            Chip(
                label: SizedBox(
                  height: 40,
                  width: 70,
                  child: TextButton(
                    onPressed: () {  },
                    child: Text("$sets  sets"),
                  ),
                )
            )
          ],
        ),
        trailing: SizedBox(
          child: Checkbox(
            value: isCompleted,
            onChanged: (value) => onChangedCheckbox!(value), //null check
          ),
        ),),
    );
  }
}
