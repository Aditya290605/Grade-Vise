import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/services/firebase_auth_methods.dart';
import 'package:grade_vise/teacher/landing_page.dart';
import 'package:grade_vise/utils/colors.dart';
import 'package:grade_vise/utils/fonts.dart';
import 'package:grade_vise/widgets/bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
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
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }

              debugPrint(snapshot.hasData.toString());
              return snapshot.data!.docs.isEmpty
                  ? SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Hello ${userData['name'].split(' ')[0]}",
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge!.copyWith(
                                  color: Colors.white,
                                  fontFamily: sourceSans,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  FirebaseAuthMethods(
                                    FirebaseAuth.instance,
                                  ).signOut();
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    userData['photoURL'].isEmpty
                                        ? "https://i.pinimg.com/474x/59/af/9c/59af9cd100daf9aa154cc753dd58316d.jpg"
                                        : userData['photoURL'],
                                  ),
                                  radius: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(45),
                                topRight: Radius.circular(45),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                  ),
                                  child: Image.asset('assets/images/image.png'),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 60,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Future.delayed(
                                        const Duration(milliseconds: 100),
                                        () {
                                          BottomDailog().showCreateDailog(
                                            context,
                                          ); // Delayed bottom sheet
                                        },
                                      );
                                    },
                                    style: ButtonStyle(
                                      fixedSize: WidgetStatePropertyAll(
                                        Size(
                                          MediaQuery.of(context).size.width *
                                              0.6,
                                          50,
                                        ),
                                      ),
                                      backgroundColor: WidgetStatePropertyAll(
                                        bgColor,
                                      ),
                                      padding: WidgetStatePropertyAll(
                                        const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Create new",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge!.copyWith(
                                            color: Colors.white,
                                            fontFamily: sourceSans,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : LandingPage();
            },
          );
        },
      ),
    );
  }
}
