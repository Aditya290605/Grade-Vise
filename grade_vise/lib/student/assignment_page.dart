import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/widgets/assignment_card.dart';

// Assignment data model
class Assignment {
  final String subject;
  final String title;
  final int submittedCount;
  final int totalCount;
  final String lastSubmissionDate;

  Assignment({
    required this.subject,
    required this.title,
    required this.submittedCount,
    required this.totalCount,
    required this.lastSubmissionDate,
  });
}

class AssignmentPage extends StatelessWidget {
  final String classroomId;

  const AssignmentPage({super.key, required this.classroomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2936),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Assignment',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('assignments')
                .where('classroomId', isEqualTo: classroomId)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return AssignmentCard(
                title: snapshot.data!.docs[index]['title'],
                subject: snapshot.data!.docs[index]['description'],
                classroomId: classroomId,
                date: snapshot.data!.docs[index]['dueDate'],
                isTeacher: false,
                assignmentId: snapshot.data!.docs[index]['fileId'],
                uid: snapshot.data!.docs[index]['userId'],
                fileUrl: snapshot.data!.docs[index]['fileUrl'],
                des: snapshot.data!.docs[index]['description'],
                fileType: snapshot.data!.docs[index]['fileType'],
              );
            },
          );
        },
      ),
    );
  }
}
