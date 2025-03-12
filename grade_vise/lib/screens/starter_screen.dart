import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grade_vise/student/student_home.dart';
import 'package:grade_vise/teacher/home_screen.dart';

import 'package:grade_vise/utils/fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> addRole(String role) async {
    String res = 'something went wrong';

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'role': role});
      res = 'Success';
      return res;
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Container(),
            elevation: 3,
          ),
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(45),
                topLeft: Radius.circular(45),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF293241),
                  Color.fromARGB(255, 51, 62, 72),
                  Color.fromARGB(255, 107, 119, 131),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  "What is your role?",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontFamily: dmSans,
                  ),
                ).animate().fade(duration: 500.ms),

                const Spacer(),

                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });

                    String res = await addRole('Student');

                    if (res == 'Success') {
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => StudentHome(),
                          ),
                        );
                      }
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: RoleCard(
                    imageUrl:
                        "https://i.pinimg.com/474x/a6/9e/db/a69edb28c7ff8521a3fb8825b56a995c.jpg",
                    label: "Student",
                  ),
                ),

                const Spacer(),

                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });

                    String res = await addRole('Teacher');

                    if (res == 'Success') {
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      }
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: RoleCard(
                    imageUrl:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4Bwz8-TWJNKPdLhikrDm97LAOm7OJQgCIgQ&s",
                    label: "Teacher",
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        );
  }
}

class RoleCard extends StatelessWidget {
  final String imageUrl;
  final String label;

  const RoleCard({super.key, required this.imageUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.18,
            width: MediaQuery.of(context).size.width * 0.38,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 3,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(child: Image.network(imageUrl, fit: BoxFit.cover)),
          ),
        ).animate().scale(
          duration: Duration(milliseconds: 850),
          curve: Curves.easeInOut,
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.white,
            fontFamily: dmSans,
          ),
        ).animate().fade(duration: 600.ms),
      ],
    );
  }
}
