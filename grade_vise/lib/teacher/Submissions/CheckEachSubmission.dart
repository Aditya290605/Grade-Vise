import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/teacher/submissions/ai_methods.dart';
import 'package:grade_vise/teacher/submissions/pdfToText.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Checkeachsubmission extends StatefulWidget {
  final String title;
  final List status;
  final DocumentSnapshot<Map<String, dynamic>> snap;

  final DocumentSnapshot<Map<String, dynamic>> snap1;
  final String subject;
  const Checkeachsubmission({
    super.key,
    required this.snap1,
    required this.title,
    required this.subject,
    required this.snap,
    required this.status,
  });

  @override
  State<Checkeachsubmission> createState() => _CheckeachsubmissionState();
}

class _CheckeachsubmissionState extends State<Checkeachsubmission> {
  String aiMark = '';
  List<Map<String, dynamic>> submissions = [];
  List<String> users = [];
  List<String> fileUrls = [];

  @override
  void initState() {
    super.initState();
    fetchSubmissionsAndUsers();
  }

  Future<void> fetchSubmissionsAndUsers() async {
    final snap = await FirebaseFirestore.instance
        .collection('submissions')
        .where('submissionId', whereIn: widget.status)
        .get()
        .catchError((error) {
          debugPrint("Failed to fetch documents: $error");
        });
    setState(() {
      for (var i = 0; i < widget.status.length; i++) {
        users.add(snap.docs[i]['userId']);
        fileUrls.add(snap.docs[i]['fileUrl']);
      }
    });
    debugPrint('${users} /n ${fileUrls}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2839),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2839),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () {},
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: const CircleAvatar(
              backgroundColor: Color(0xFFD3D3D3),
              radius: 20,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Card with enhanced shadows and animations
          Container(
            margin: const EdgeInsets.all(16),
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE3DBFF), Color(0xFFFFB6C1)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative shape 1
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      color: Colors.pink.withOpacity(0.3),
                    ),
                  ),
                ),
                // Decorative shape 2
                Positioned(
                  right: 40,
                  bottom: 30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Colors.orange.withOpacity(0.3),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.5,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Mathematics tag with enhanced styling
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Chip(
                  label: Text(
                    widget.subject,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Table header with enhanced styling
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Student Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          Icons.arrow_upward_outlined,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    'Marks',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Colors.white, height: 1),
          ),

          // Exam list with enhanced styling
          Expanded(
            child: ListView.builder(
              itemCount: widget.snap['users'].length,
              itemBuilder: (context, index) {
                return StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.snap['users'][index])
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ExamListItem(
                      title: snapshot.data!['name'],
                      status:
                          users.contains(snapshot.data!['uid'])
                              ? "completed"
                              : 'pending',
                      statusColor:
                          users.contains(snapshot.data!['uid'])
                              ? Colors.green
                              : Colors.red,
                      marks: aiMark == '' ? '0' : aiMark,
                      shade: true,
                      aiFeedback: aiMark,
                    );
                  },
                );
              },
            ),
          ),

          // Bottom buttons with enhanced styling
          // Bottom buttons with enhanced styling
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // First Button (Upload Model Sheet)
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.white],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: const Offset(0, 3),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          offset: const Offset(0, 8),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(28),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFECEFF5),
                                ),
                                child: const Icon(
                                  Icons.upload,
                                  color: Color(0xFF3E4B6B),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Upload Sheet',
                                style: TextStyle(
                                  color: Color(0xFF272E3F),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Second Button (Check with AI)
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.white.withOpacity(0.9)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 3),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          offset: const Offset(0, 8),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(28),
                        onTap: () async {
                          try {
                            var res = await processAndExtractAssignments(
                              users,
                              fileUrls,
                            );
                            debugPrint('${res}');

                            if (widget.snap['users'] is List) {
                              for (var studentId in widget.snap['users']) {
                                var submissionSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('submissions')
                                        .where('userId', isEqualTo: studentId)
                                        .get();

                                if (submissionSnapshot.docs.isNotEmpty) {
                                  var submissionData =
                                      submissionSnapshot.docs.first.data();
                                  if (submissionData.containsKey('fileUrl')) {
                                    String fileUrl = submissionData['fileUrl'];

                                    debugPrint(
                                      "Processing student: $studentId, File URL: $fileUrl",
                                    );

                                    // Get AI feedback
                                    String aiFeedback = await AiMethods()
                                        .analyzeWithAI(fileUrl);
                                    setState(() {
                                      aiMark = aiFeedback;
                                    });
                                    debugPrint(
                                      "AI Feedback for $studentId: $aiFeedback",
                                    );

                                    // Update Firestore and trigger UI refresh
                                    await FirebaseFirestore.instance
                                        .collection('submissions')
                                        .where('userId', isEqualTo: studentId)
                                        .get()
                                        .then(
                                          (querySnapshot) => querySnapshot
                                              .docs
                                              .first
                                              .reference
                                              .update({
                                                'aiFeedback': aiFeedback,
                                              }),
                                        );
                                  }
                                } else {
                                  debugPrint(
                                    "No submission found for student: $studentId",
                                  );
                                }
                              }
                            } else {
                              debugPrint("Error: snap['users'] is not a List");
                            }
                          } catch (e) {
                            debugPrint("Error in onTap: $e");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFECEFF5),
                                ),
                                child: const Icon(
                                  Icons.smart_toy,
                                  color: Color(0xFF3E4B6B),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Check with AI',
                                style: TextStyle(
                                  color: Color(0xFF272E3F),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom navigation with enhanced styling
        ],
      ),
    );
  }
}

class ExamListItem extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;
  final String marks;
  final bool shade;
  final String aiFeedback; // Add AI Feedback

  const ExamListItem({
    super.key,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.marks,
    required this.shade,
    required this.aiFeedback, // Receive AI Feedback
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: shade ? Colors.grey.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  marks,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Display AI Feedback
        ],
      ),
    );
  }
}
