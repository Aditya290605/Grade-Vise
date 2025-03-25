import 'package:flutter/material.dart';
import 'package:grade_vise/student/assignment_details.dart';

import 'package:grade_vise/teacher/assignments_list.dart';
import 'package:grade_vise/utils/colors.dart';

class AssignmentCard extends StatelessWidget {
  final String subject;
  final String title;
  final String date;
  final bool isTeacher;
  final String classroomId;
  String? assignmentId;
  String? des;
  String? uid;
  String? fileUrl;
  String? fileType;
  AssignmentCard({
    super.key,

    required this.title,
    required this.subject,
    required this.date,
    required this.isTeacher,
    this.assignmentId,
    this.des,
    this.uid,
    this.fileType,
    this.fileUrl,
    required this.classroomId,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAssignmentCard(
      context,
      subject,
      title,
      date,
      assignmentId!,
      uid!,
      isTeacher,
      des!,
      fileType!,
      fileUrl!,
      classroomId,
    );
  }
}

Widget _buildAssignmentCard(
  BuildContext context,
  String subject,
  String title,
  String date,
  String assignmentId,
  String uid,
  bool isTeacher,
  String des,
  String fileType,
  String fileUrl,
  String classroomId,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3EAFC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF666666),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 15),
          // Progress Bar
          isTeacher
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Submissions',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      Text(
                        '0/0',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 0,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF1F2937),
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              )
              : Container(),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Last Submission Date',
                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (!isTeacher) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => AssignmentDetailScreen(
                          assignmentId: assignmentId,
                          uid: uid,
                          bgColor: bgColor,
                          title: title,
                          dueDate: date,
                          content: des,
                          fileUrl: fileUrl,
                          fileType: fileType,
                          classroomId: classroomId,
                          isTeacher: true,
                        ),
                  ),
                );
              }

              if (isTeacher) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => SubmissionsOverviewScreen(
                          bgColor: bgColor,
                          classroomId: classroomId,
                        ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F2937),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fact_check_outlined),
                SizedBox(width: 10),
                Text(
                  isTeacher ? 'View Submissions' : 'View Assignment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
