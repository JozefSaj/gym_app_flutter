import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String name;
  String email;
  String id;
  bool isAdmin;

  User({this.name = '', this.isAdmin = false, this.email = '', this.id = ''});

  Future<void> init({required id}) async {
    final response =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    isAdmin = response.data()!['isAdmin'];
    email = response.data()!['email'];
  }
}
