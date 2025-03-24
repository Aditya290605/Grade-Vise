import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/teacher/Assignments/addAssignment.dart';
import 'package:grade_vise/teacher/Assignments/animated_submission_sheet.dart';
import 'package:grade_vise/utils/colors.dart';
import 'package:grade_vise/widgets/assignment_card.dart';

class AssignmentsPage extends StatelessWidget {
  final String photUrl;
  final String uid;
  final String classroomId;
  const AssignmentsPage({
    super.key,
    required this.photUrl,
    required this.classroomId,
    required this.uid,
  });

  // Function to handle checking submissions
  void _checkSubmissions(
    BuildContext context,
    String subject,
    String assignment,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Simulate loading data (in real app, this would be fetch the data from firebase)
    Future.delayed(const Duration(seconds: 2), () {
      // Dismiss the loading dialog
      Navigator.pop(context);

      // Show submission details with auto-scrolling container
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder:
            (context) => AnimatedSubmissionSheet(
              subject: subject,
              assignment: assignment,
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('assignments')
                .where("classroomId", isEqualTo: classroomId)
                .snapshots(),
        builder: (context, snap) {
          if (snap.data != null) {
            return Scaffold(
              backgroundColor: bgColor,
              body: Column(
                children: [
                  _buildAppBar(context),
                  buildAssignmentHeader(),
                  Expanded(
                    child:
                        snap.data!.docs.isEmpty
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/teacher/assignment.png",
                                ),

                                Text(
                                  "No asssingments uploaded yet",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                            : ListView.builder(
                              itemCount: snap.data!.docs.length,
                              itemBuilder: (context, index) {
                                return AssignmentCard(
                                  title: snap.data!.docs[index]['title'],
                                  subject:
                                      snap.data!.docs[index]['description'],
                                  date: snap.data!.docs[index]['dueDate'],
                                  classroomId: classroomId,
                                  isTeacher: true,
                                  assignmentId: '',
                                  des: '',
                                  uid: '',
                                  fileType: '',
                                  fileUrl: '',
                                );
                              },
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AssignmentCreationPage(
                              uid: uid,
                              classroomId: classroomId,
                            ),
                      ),
                    ),
                backgroundColor: const Color(0xFFE3D1EF),
                child: const Icon(
                  Icons.add,
                  color: Color(0xFF1F2937),
                  size: 30,
                ),
                tooltip: 'Create Assignment',
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(
              photUrl.isEmpty
                  ? "https://i.pinimg.com/474x/59/af/9c/59af9cd100daf9aa154cc753dd58316d.jpg"
                  : photUrl,
            ),
          ),
          const SizedBox(width: 15),
          // Search Field
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF2D3748),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search assignments...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAssignmentHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3D1EF),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFF8D7A4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assignments',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Manage your class assignments',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                  ),
                ],
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
}
