import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool isLoading = false;
  String email = '';
  String password = '';

  void submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() => isLoading = true);
    try {
      final UserCredential response;
      if (isLogin) {
        response = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      } else {
        response = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

        FirebaseFirestore.instance.collection('users').doc(response.user!.uid).set({
          'email': email,
          'isAdmin': true,
        });
        FirebaseFirestore.instance.collection('users').add({'userId': FirebaseAuth.instance.currentUser!});
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } catch (e) {} finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text("Workout Tracker"),
              const SizedBox(
                height: 300,
              ),
              SizedBox(
                width: 250,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        key: const ValueKey('email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email should not be empty';
                          }

                          return null;
                        },
                        onSaved: (newValue) => email = newValue!,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          label: Text('Email'),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 8,),
                      TextFormField(
                        key: const ValueKey('password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password should not be empty';
                          }

                          if (value.length < 6) {
                            return 'Password should be longer than\n6 characters';
                          }
                        },
                        onSaved: (newValue) => password = newValue!,
                        decoration: const InputDecoration(
                          label: Text('Password',),
                          border: OutlineInputBorder(),
                          isDense: true,
                          prefixIcon: Icon(Icons.vpn_key)
                        ),
                      ),
                      const SizedBox(height: 8,),
                      if (!isLogin)
                        TextFormField(
                          obscureText: true,
                          key: const ValueKey('confirm'),
                          decoration: const InputDecoration(
                            label: Text('Confirm password'),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading ? const CircularProgressIndicator() : FilledButton(
                  onPressed: submitForm,
                  child: Text(isLogin ? "Login" : "Register")),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  style: ButtonStyle(),
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(isLogin
                      ? "I don't have an account"
                      : "I already have an account"))
            ],
          ),
        ),
      ),
    );
  }
}
