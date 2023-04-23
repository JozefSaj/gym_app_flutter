import 'package:flutter/material.dart';

class User with ChangeNotifier{
  final String name;
  final String email;
  bool isAdmin;

  User({required this.name, required this.email, this.isAdmin = false});


  User.fromSnapshot(String email, String password) {

  }

}