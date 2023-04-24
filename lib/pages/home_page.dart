import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:gym_app_flutter/data/feedback_data.dart';
import 'package:gym_app_flutter/pages/workout_page.dart';
import 'package:provider/provider.dart';

import '../data/workout_data.dart';
import '../modules/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String newWorkoutNameController = '';
  String feedback = '';
  final _formKey = GlobalKey<FormState>();

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: const Text("Create new workout"),
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
              TextButton(onPressed: save, child: const Text("save"))
            ],
          ),
        ),
      ),
    );
  }

  void giveFeedBack(FeedbackData data) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: const Text("Give us Feedback!"),
            content: Form(
              key: _formKey,
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
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    data.addFeedback(feedback);
    Navigator.pop(context);
  }

  void save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    Provider.of<WorkoutData>(context, listen: false)
        .addWorkout(newWorkoutNameController);
    Navigator.pop(context);
  }

  void cancel() {
    Navigator.pop(context);
  }

  void addPublicWorkOut() {}

  void showFeedback(FeedbackData data) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(height: 300 ,child: ListView.builder(itemBuilder: (context, index) => Text(data.feedbackList[index].content), itemCount: data.feedbackList.length,)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    FeedbackData data = Provider.of<FeedbackData>(context);

    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
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
                    onPressed: createNewWorkout,
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
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  value.getWorkoutList()[index].name,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 22),
                                )),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: () => goToWorkoutPage(
                              value.getWorkoutList()[index].name),
                        ),
                      )),
            ));
  }
}
