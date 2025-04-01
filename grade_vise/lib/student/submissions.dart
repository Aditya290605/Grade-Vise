import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grade_vise/student/evaluation.dart';
import 'package:intl/intl.dart';
import 'package:grade_vise/utils/colors.dart';

class AssignmentListScreen extends StatelessWidget {
  final String classroomId;

  const AssignmentListScreen({super.key, required this.classroomId});

  Widget _buildAssignmentHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3D1EF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Submissions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const CircleAvatar(backgroundColor: Color(0xFF333333), radius: 6),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildAssignmentHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream:
                    FirebaseFirestore.instance
                        .collection('classrooms')
                        .doc(classroomId)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var assignments = snapshot.data!['assignments'];

                  return ListView.builder(
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future:
                            FirebaseFirestore.instance
                                .collection('submissions')
                                .where(
                                  'assignmentId',
                                  isEqualTo: assignments[index],
                                )
                                .where(
                                  'userId',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid,
                                )
                                .where('classroomId', isEqualTo: classroomId)
                                .get(),
                        builder: (context, submissionSnapshot) {
                          if (submissionSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!submissionSnapshot.hasData ||
                              submissionSnapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text('No submissions found'),
                            );
                          }

                          var submissionData =
                              submissionSnapshot.data!.docs.first;

                          return _buildAssignmentCard(context, submissionData);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(
    BuildContext context,
    DocumentSnapshot<Map<String, dynamic>> submissionData,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                Icons.assignment,
                submissionData['title'] ?? 'Untitled Assignment',
                20.0,
                Colors.blueAccent,
              ),
              _buildInfoRow(
                Icons.description,
                submissionData['description'] ?? 'No description available',
                16.0,
                Colors.grey.shade600,
              ),

              _buildInfoRow(
                Icons.check_circle,
                'Submitted at: ${DateFormat('dd MMMM yyyy').format((submissionData['uploadedAt'] as Timestamp).toDate())}',
                14.0,
                Colors.green,
              ),

              StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('evaluations')
                        .doc(submissionData['userId'])
                        .snapshots(),
                builder: (context, snap) {
                  if (snap.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => StudentEvaluation(
                                  assignmentTitle: submissionData['title'],
                                  marks: snap.data!.data()!['mark'],
                                  totalMarks: 10,
                                  feedback: snap.data!.data()!['feedback'],
                                  isChecked: true,
                                ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Text(
                          'View results',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text,
    double fontSize,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
