import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String secondPassword = '';

  void submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() => isLoading = true);
    try {
      final UserCredential response;
      if (isLogin) {
        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message ?? 'Neočakávaná chyba'),
            behavior: SnackBarBehavior.floating,
          ));
        } catch (e) {}
        response = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        try {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message ?? 'Neočakávaná chyba'),
            behavior: SnackBarBehavior.floating,
          ));
        } catch (e) {}
        response = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        FirebaseFirestore.instance
            .collection('users')
            .doc(response.user!.uid)
            .set({
          'email': email,
          'isAdmin': false,
        });
        FirebaseFirestore.instance
            .collection('users')
            .add({'userId': FirebaseAuth.instance.currentUser!});
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } catch (e) {
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
    // waiting for firebase to load in the data, need to use await as we need to first
    //wait for firebase then just continue in the method.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(217, 216, 218, 1),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              Container(
                  width: 300,
                  height: 200,
                  child: Image.asset('images/logo_auth.png')),
              const SizedBox(
                height: 35,
              ),
              Text(
                "Your Workout Companion",
                style: GoogleFonts.ptSerif(textStyle: TextStyle(fontSize: 35)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
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
                          if (!value.contains('@')) {
                            return 'Email not in correct format';
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
                      const SizedBox(
                        height: 8,
                      ),
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
                            label: Text(
                              'Password',
                            ),
                            border: OutlineInputBorder(),
                            isDense: true,
                            prefixIcon: Icon(Icons.vpn_key)),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (!isLogin)
                        TextFormField(
                          obscureText: true,
                          key: const ValueKey('confirm'),
                          onSaved: (newValue) => secondPassword = newValue!,
                          validator: (value) {
                            print(value);
                            if (password != secondPassword) {
                              return 'Passwords are not the same';
                            }
                          },
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
              isLoading
                  ? const CircularProgressIndicator()
                  : FilledButton(
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
