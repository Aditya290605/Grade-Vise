import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/teacher/Submissions/CheckEachSubmission.dart';
import 'package:grade_vise/utils/colors.dart';

class SubmissionsPage extends StatelessWidget {
  final String classroomId;
  final String photo;

  const SubmissionsPage({
    super.key,
    required this.classroomId,
    required this.photo,
  });

  Widget _buildAssignmentHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3D1EF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFFF8D7A4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
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
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF2D3142), size: 30),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF2D3142), size: 30),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                photo.isEmpty
                    ? "https://i.pinimg.com/474x/59/af/9c/59af9cd100daf9aa154cc753dd58316d.jpg"
                    : photo,
              ),
              backgroundColor: const Color(0xFFD9D9D9),
              radius: 20,
              child: Container(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildAssignmentHeader(),
          const SizedBox(height: 20),

          StreamBuilder(
            stream:
                FirebaseFirestore.instance
                    .collection('classrooms')
                    .doc(classroomId)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                return const Center(child: Text("Error loading data"));
              }

              var assignments = snapshot.data!.data()?['assignments'] ?? [];

              if (assignments.isEmpty) {
                return Center(
                  child: Image.network(
                    "https://i.pinimg.com/736x/a8/1e/3d/a81e3d8e4abb9b68c624e9738d61b7f4.jpg",
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: assignments.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                      stream:
                          FirebaseFirestore.instance
                              .collection('assignments')
                              .where('fileId', isEqualTo: assignments[index])
                              .snapshots(),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snap.hasError ||
                            !snap.hasData ||
                            snap.data == null ||
                            snap.data!.docs.isEmpty) {
                          return const Center(
                            child: Text("No assignment found"),
                          );
                        }

                        // Instead of using `index`, use `snap.data!.docs.first`
                        var assignmentData = snap.data!.docs.first;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 10,
                          ),
                          child: SubmissionCard(
                            snap: snapshot.data!,
                            snap1: assignmentData,
                            subject: snapshot.data!['subject'],
                            title: assignmentData['title'],
                            submitted: assignmentData['submissions'].length,
                            total: '${snapshot.data!['users'].length}',
                            submissions: assignmentData['submissions'],
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Including the CustomNavigation class for reference

class SubmissionCard extends StatelessWidget {
  final String subject;
  final String title;
  final int submitted;
  final String total;
  final DocumentSnapshot<Map<String, dynamic>> snap1;
  final List submissions;
  final DocumentSnapshot<Map<String, dynamic>> snap;

  const SubmissionCard({
    super.key,
    required this.subject,
    required this.submissions,
    required this.title,
    required this.submitted,
    required this.total,
    required this.snap1,
    required this.snap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EEFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              subject,
              style: const TextStyle(
                color: Color(0xFF2D3142),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2D3142),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Students Submitted',
                style: TextStyle(color: Color(0xFF8D8D8D), fontSize: 16),
              ),
              Text(
                '$submitted/$total',
                style: const TextStyle(
                  color: Color(0xFF2D3142),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Checkeachsubmission(
                        title: title,
                        subject: subject,
                        snap: snap,
                        snap1: snap1,
                        status: submissions,
                      ),
                ),
              );
            },
            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
            label: Text(
              'Check Submissions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D3142),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }
}
