import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/utils/show_error.dart';

class FirestoreMethods {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createUser(
    BuildContext context,
    String uid,
    String fname,
    String lname,
    String email,
    String pass,
  ) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        "uid": uid,
        'fname': fname,
        'lname': lname,
        'email': email,
        'password': pass,
      });
    } catch (e) {
      if (context.mounted) {
        showSnakbar(context, e.toString());
      }
    }
  }
}
