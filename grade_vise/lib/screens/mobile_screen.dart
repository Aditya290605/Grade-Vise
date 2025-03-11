import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/pages/sign_up.dart';

import 'package:grade_vise/student/student_home.dart';
import 'package:grade_vise/teacher/home_screen.dart';

import 'package:provider/provider.dart';

class MobileScreen extends StatelessWidget {
  const MobileScreen({super.key});

  Future<String?> getRole() async {
    try {
      var userSnap =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

      if (userSnap.exists) {
        return userSnap.data()?['role'];
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching role: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser == null) {
      return const SignUp();
    }

    return FutureBuilder<String?>(
      future: getRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Error retrieving role"));
        }

        final role = snapshot.data;
        debugPrint("User role: $role");

        if (role == 'Teacher') {
          return const HomeScreen();
        } else if (role == 'Student') {
          return const StudentHome();
        }

        return const SignUp();
      },
    );
  }
}
