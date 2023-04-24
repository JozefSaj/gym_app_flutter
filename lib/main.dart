import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:gym_app_flutter/data/feedback_data.dart';
import 'package:gym_app_flutter/pages/auth_page.dart';
import 'package:provider/provider.dart';
import 'data/workout_data.dart';
import 'pages/home_page.dart';
import 'modules/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => WorkoutData(),
        ),
        ChangeNotifierProvider(create: (context) => FeedbackData(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return AuthPage();
            }
            final user = User();
            return FutureBuilder(
              future: user.init(id: FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ChangeNotifierProvider.value(
                  value: user,
                  child: HomePage(),
                );
              },
            );

            return snapshot.hasData ? const HomePage() : const AuthPage();
          },
        ),
        theme: ThemeData(useMaterial3: true),
      ),
    );
  }
}
