import 'package:first/pages/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/workout_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage>{

  final newWorkoutNameController = TextEditingController();

  void createNewWorkout(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Create new workout"),
          content: TextField(
            controller: newWorkoutNameController,
          ),
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

  void goToWorkoutPage(String workoutName){
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(workoutName: workoutName,)));
  }

  void save(){
  Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutNameController.text);
  Navigator.pop(context);
  newWorkoutNameController.clear();
  }

  void cancel(){
    Navigator.pop(context);
    newWorkoutNameController.clear();
  }


  @override
  Widget build(BuildContext context){
    return Consumer<WorkoutData>(builder: (context, value, child) => Scaffold(
      appBar: AppBar(title: Text("Podme si zacvicit jupiiii")
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewWorkout,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: value.getWorkoutList().length,
          itemBuilder: (context, index) => ListTile(
              title: Text(value.getWorkoutList()[index].name),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed:() =>
              goToWorkoutPage(value.getWorkoutList()[index].name),
            ),
          )
      ),

    ));
  }
}

