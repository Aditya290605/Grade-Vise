import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/utils/show_error.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final _firestore = FirebaseFirestore.instance;

  Future<String> createUser(
    BuildContext context,
    String uid,
    String fname,
    String email,
  ) async {
    String res = "";
    try {
      await _firestore.collection('users').doc(uid).set({
        "uid": uid,
        'name': fname,
        'email': email,
        "photoURL": "",
        'createdAt': DateTime.now(),
        'role': "",
        'classrooms': [],
      });
      res = "success";
    } catch (e) {
      if (context.mounted) {
        res = e.toString();
        showSnakbar(context, e.toString());
      }
    }
    return res;
  }

  Future<void> createClassroom(
    String name,
    String section,
    String subject,
    String room,
  ) async {
    try {
      String classroomId = Uuid().v1();

      await FirebaseFirestore.instance
          .collection('classrooms')
          .doc(classroomId)
          .set({
            'uid': FirebaseAuth.instance.currentUser!.uid,
            'name': name,
            'section': section,
            'subject': subject,
            'room': room,
            'classroomId': classroomId,
            'createdAt': DateTime.now(),
            'users': [],
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
