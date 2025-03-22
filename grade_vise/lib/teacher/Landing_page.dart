import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/screens/mobile_screen.dart';
import 'package:grade_vise/teacher/main_page.dart';

import 'package:grade_vise/utils/colors.dart';
import 'package:grade_vise/utils/fonts.dart';
import 'package:grade_vise/widgets/bottom_sheet.dart';
import 'package:grade_vise/widgets/classroom_container.dart';
import 'package:intl/intl.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23293A),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BottomDailog().showCreateDailog(context);
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white, size: 36),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting ||
              snapshots.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          var userData = snapshots.data!;

          return StreamBuilder(
            stream:
                FirebaseFirestore.instance
                    .collection('classrooms')
                    .where(
                      'uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                    )
                    .snapshots(),
            builder: (context, snapshot) {
              // Check if snapshot has data and it's not null
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return SafeArea(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Top Bar with Profile
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hi ${userData['name'].split(" ")[0]}',
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: sourceSans,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${int.parse(DateFormat('yyyy').format(DateTime.now()))}-${int.parse(DateFormat('yyyy').format(DateTime.now())) + 1}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => MobileScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        userData['photoURL'].isEmpty
                                            ? "https://i.pinimg.com/474x/59/af/9c/59af9cd100daf9aa154cc753dd58316d.jpg"
                                            : userData['photoURL'],
                                      ),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Class Schedule Card with Scroll Fix
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(45),
                              topRight: Radius.circular(45),
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(45),
                                  topRight: Radius.circular(45),
                                ),
                              ),
                              child: ListView.builder(
                                padding: const EdgeInsets.only(top: 20),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 8,
                                    ),
                                    child: InkWell(
                                      splashColor: Colors.grey,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) => MainPage(
                                                  username: userData['name'],
                                                  userPhoto:
                                                      userData['photoURL'],
                                                  classroomId:
                                                      snapshot
                                                          .data!
                                                          .docs[index]['classroomId'],
                                                ),
                                          ),
                                        );
                                      },
                                      child: ClassroomContainer(
                                        classroomName:
                                            snapshot.data!.docs[index]['name'],
                                        room:
                                            snapshot.data!.docs[index]['room'],
                                        section:
                                            snapshot
                                                .data!
                                                .docs[index]['section'],
                                        subject:
                                            snapshot
                                                .data!
                                                .docs[index]['subject'],
                                        color:
                                            colors[Random().nextInt(
                                              colors.length,
                                            )],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
