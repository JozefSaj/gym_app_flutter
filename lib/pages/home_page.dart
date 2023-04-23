import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_app_flutter/pages/workout_page.dart';
import 'package:provider/provider.dart';

import '../data/workout_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage>{

  String newWorkoutNameController = '';
  final _formKey = GlobalKey<FormState>();

  void createNewWorkout(){
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: Text("Create new workout"),
            content: Form(
              key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onSaved: (newValue) => newWorkoutNameController = newValue!,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        label: Text('Workout Name'),
                        prefixIcon: Icon(Icons.subject),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty){
                          return "Workout Name should not be empty";
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

  void goToWorkoutPage(String workoutName){
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(workoutName: workoutName,)));
  }

  void save(){
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutNameController);
    Navigator.pop(context);
  }

  void cancel(){
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context){
    return Consumer<WorkoutData>(builder: (context, value, child) => Scaffold(
      appBar: AppBar(title: Text("Workout tracker"), actions: [IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: Icon(Icons.logout))]
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
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed:() =>
                  goToWorkoutPage(value.getWorkoutList()[index].name),
            ),
          )
      ),

    ));
  }
}

