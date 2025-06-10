import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/student/feedback/complaint_track.dart';
import 'package:grade_vise/student/feedback/feed_submission.dart';
import 'package:grade_vise/utils/colors.dart';

class FeedbackPage extends StatelessWidget {
  final String classroomId;
  final String userPhoto;
  final String email;
  const FeedbackPage({
    super.key,
    required this.classroomId,
    required this.email,
    required this.userPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text('FeedBack', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Illustration and Interactive Elements
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Dotted circular background

                // Illustration People
                StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection('feedbacks')
                          .where('classroomId', isEqualTo: classroomId)
                          .snapshots(),

                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return snapshot.data!.docs.isEmpty
                          ? Center(
                            child: Text(
                              "No feedbacks",
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return FeedbackCard(
                                createdAt:
                                    (snapshot.data!.docs[index]['time']
                                            as Timestamp)
                                        .toDate()
                                        .toString(),
                                description:
                                    snapshot.data!.docs[index]['description'],
                                onDelete: () {
                                  FirebaseFirestore.instance
                                      .collection('feedbacks')
                                      .doc(
                                        snapshot
                                            .data!
                                            .docs[index]['feedbackId'],
                                      )
                                      .delete();
                                },
                                onViewDetails: () {},
                                title: snapshot.data!.docs[index]['title'],
                              );
                            },
                          );
                    }

                    return Center(child: CircularProgressIndicator());
                  },
                ),

                // Speech Bubbles and Emojis
              ],
            ),
          ),

          // Feedback/Doubt Button
          // Feedback/Doubt Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => FeedbackSubmissionPage(
                          classroomId: classroomId,
                          userPhoto: userPhoto,
                          email: email,
                        ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'FeedBack/Dought',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.add, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
      //     BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: ''),
      //     BottomNavigationBarItem(icon: Icon(Icons.videocam), label: ''),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      //   ],
      // ),
    );
  }
}
