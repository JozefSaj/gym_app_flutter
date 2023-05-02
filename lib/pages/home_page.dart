import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:gym_app_flutter/data/feedback_data.dart';
import 'package:gym_app_flutter/pages/workout_page.dart';
import 'package:provider/provider.dart';

import '../data/workout_data.dart';
import '../modules/user.dart';
import '../modules/workout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String newWorkoutNameController = '';
  String feedback = '';
  final _formKeyFeedback = GlobalKey<FormState>();
  final _formKeyNewWorkout = GlobalKey<FormState>();
  final _formKeyNewPublicWorkout = GlobalKey<FormState>();

  void refresh() {
    setState(() {

    });
  }

  void createNewWorkout(String? rename) {
    String oldName = '';

    if (rename != null) {
      oldName = rename;
    }
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title:  Text(rename == null ? "Create new workout" : "Rename your workout"),
            content: Form(
              key: _formKeyNewWorkout,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: rename,
                    onSaved: (newValue) => newWorkoutNameController = newValue!,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      label: Text('Workout Name'),
                      prefixIcon: Icon(Icons.subject),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Workout Name should not be empty";
                      }
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: cancel, child: const Text("cancel")),
              if (rename != null)
                TextButton(onPressed: () {
                  bool result = validateRename();
                  if (result) {
                    print(rename);
                    _formKeyNewWorkout.currentState!.save();
                    renameWorkout(newWorkoutNameController, oldName);
                    Navigator.of(context).pop();
                    refresh();
                  }

                }, child: const Text("save")),
              if (rename == null)
              TextButton(onPressed: save, child: const Text("save"))
            ],
          ),
        ),
      ),
    );
  }

  bool validateRename(){
    return _formKeyNewWorkout.currentState!.validate();

  }

  void renameWorkout(String newName, String oldName){
      Workout current = Provider.of<WorkoutData>(context, listen: false).getRelevantWorkout(oldName);
      current.name = newName;
  }


  void giveFeedBack(FeedbackData data) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: const Text("Give us Feedback!"),
            content: Form(
              key: _formKeyFeedback,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onSaved: (newValue) => feedback = newValue!,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      label: Text('Feedback'),
                      prefixIcon: Icon(Icons.create),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Feedback should not be empty";
                      }
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: cancel, child: const Text("cancel")),
              TextButton(onPressed: () => saveFeedback(data), child: const Text("save"))
            ],
          ),
        ),
      ),
    );
  }

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutPage(
                  workoutName: workoutName,
                )));
  }

  void saveFeedback(FeedbackData data) {
    if (!_formKeyFeedback.currentState!.validate()) {
      return;
    }
    _formKeyFeedback.currentState!.save();
    data.addFeedback(feedback);
    Navigator.pop(context);
  }

  void save() {
    if (!_formKeyNewWorkout.currentState!.validate()) {
      return;
    }
    _formKeyNewWorkout.currentState!.save();
    Provider.of<WorkoutData>(context, listen: false)
        .addWorkout(newWorkoutNameController);
    Navigator.pop(context);
  }

  void savePublic() {
    if (!_formKeyNewPublicWorkout.currentState!.validate()) {
      return;
    }
    _formKeyNewPublicWorkout.currentState!.save();
      Provider.of<WorkoutData>(context, listen: false)
          .addWorkout(newWorkoutNameController, public: true);
    Navigator.pop(context);
  }

  void cancel() {
    Navigator.pop(context);
  }

  void addPublicWorkOut() {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: const Text("Create new public workout"),
            content: Form(
              key: _formKeyNewPublicWorkout,
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
                      if (value == null || value.isEmpty) {
                        return "Workout Name should not be empty";
                      }
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: cancel, child: const Text("cancel")),
              TextButton(onPressed: savePublic, child: const Text("save"))
            ],
          ),
        ),
      ),
    );
  }

  void showFeedback(FeedbackData data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Padding(
          padding: EdgeInsets.only(left: 14),
          child: Text("Feedbacks from users"),
        ),
        content: SizedBox(
          height: 300,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: data.feedbackList.length,
              itemBuilder: (context, index) => ListTile(
                title: Row(
                  children:  [
                    const Align(
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(
                      width: 240,
                      child: Text(
                         softWrap: true,
                        data.feedbackList[index].content,
                      ),
                    )
                  ],
                ),
              )
            ),
        ),
        actions: [
          TextButton(onPressed: cancel, child: const Text("cancel")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    FeedbackData data = Provider.of<FeedbackData>(context);
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
          backgroundColor: const Color.fromRGBO(217, 216, 218, 1),
              appBar: AppBar(
                  title: const Text(
                    "Workout tracker",
                    style: TextStyle(fontSize: 28),
                  ),
                  actions: [
                    if (user.isAdmin)
                      OutlinedButton(
                        onPressed: () => showFeedback(data),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.sticky_note_2_sharp),
                            SizedBox(width: 4),
                            Text('Feedbacks'),
                          ],
                        ),
                      ),
                    IconButton(
                        onPressed: () => FirebaseAuth.instance.signOut(),
                        icon: const Icon(Icons.logout))
                  ]),
              floatingActionButton: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  if (!user.isAdmin)
                    TextButton.icon(
                      onPressed: () => giveFeedBack(data),
                      icon: const Icon(Icons.create_outlined),
                      label: const Text('Give feedback'),
                    ),
                  if (!user.isAdmin) const SizedBox(width: 100),
                  if (user.isAdmin)
                    FloatingActionButton.extended(
                      onPressed: addPublicWorkOut,
                      icon: const Icon(Icons.add),
                      label: const Text('add Public Workout'),
                    ),
                  if (user.isAdmin) const SizedBox(width: 50),
                  FloatingActionButton.extended(
                    onPressed: () => createNewWorkout(null),
                    icon: const Icon(Icons.add),
                    label: const Text('Add workout'),
                  ),
                ],
              ),
              body: ListView.builder(
                  itemCount: value.getWorkoutList().length,
                  itemBuilder: (context, index) => ListTile(
                        title: Row(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                            ),
                            if (value.getWorkoutList()[index].isPublic)
                              Text(
                              value.getWorkoutList()[index].name,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 22),
                            ),
                            if (!value.getWorkoutList()[index].isPublic)
                            TextButton(
                                onPressed: () {
                                  print(value.getWorkoutList()[index].name);
                                  createNewWorkout(value.getWorkoutList()[index].name);
                                },
                                child: Text(
                                  value.getWorkoutList()[index].name,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 22),
                                )
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: () => goToWorkoutPage(
                              value.getWorkoutList()[index].name),
                        ),
                      )
              ),
            ));
  }
}
