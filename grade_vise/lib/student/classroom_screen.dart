import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:grade_vise/student/assignment_page.dart';
import 'package:grade_vise/student/timetables.dart';
import 'package:grade_vise/teacher/announcements/anncouncements.dart';

import 'package:grade_vise/utils/colors.dart';
import 'package:grade_vise/widgets/classroom_details/announcement.dart';
import 'package:intl/intl.dart';

class ClassroomStudentScreen extends StatefulWidget {
  final Map<String, dynamic> classData;
  final String photoUrl;
  final String classroomId;
  final String name;

  const ClassroomStudentScreen({
    super.key,
    required this.classData,
    required this.classroomId,
    required this.photoUrl,
    required this.name,
  });

  @override
  State<ClassroomStudentScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Course banner with gradient background
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE6D5FF), // Light purple
                    Color(0xFFE6A0BA), // Pink
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    right: -30,
                    top: -30,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.pink.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -10,
                    bottom: -40,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange.withOpacity(0.3),
                      ),
                    ),
                  ),
                  // Title
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.classData['name'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Menu buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRoundMenuButton(
                    icon: Icons.edit,
                    iconColor: Colors.white,
                    backgroundColor: Color(0xFF2AB7CA),
                    label: 'Assignments',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AssignmentPage(
                                classroomId: widget.classData['classroomId'],
                              ),
                        ),
                      );
                    },
                  ),

                  _buildRoundMenuButton(
                    icon: Icons.check_circle,
                    iconColor: Colors.white,
                    backgroundColor: Color(0xFF22CAAC),
                    label: 'Feedback',
                    onTap: () {},
                  ),
                  _buildRoundMenuButton(
                    icon: Icons.calendar_today,
                    iconColor: Colors.white,
                    backgroundColor: Color(0xFF667080),
                    label: 'TimeTable',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SchedulePage(),
                        ),
                      );
                    },
                  ),
                  _buildRoundMenuButton(
                    icon: Icons.bar_chart,
                    iconColor: Colors.white,
                    backgroundColor: Color(0xFF5CB85C),
                    label: 'Submissions',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Scaffold()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Announcement input
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AnnouncementDialog(
                        classroomId: widget.classroomId,
                        name: widget.name,
                        profilePic: widget.photoUrl,
                        uid: widget.classData['uid'],
                      ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFF2D3748),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 24.0),
                          child: Text(
                            'Announce something to your class',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: const Icon(
                          Icons.announcement,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Announcement card
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('announcements')
                      .where('classroomId', isEqualTo: widget.classroomId)
                      .orderBy('time', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading announcements'));
                }

                final docs = snapshot.data?.docs;
                if (docs == null || docs.isEmpty) {
                  return Center(child: Text('No announcements available.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: PostContainerWidget(
                        uploadTime:
                            DateFormat('h:mm a')
                                .format(
                                  (docs[index]['time'] as Timestamp).toDate(),
                                )
                                .toString(),
                        image: docs[index]['profilePic'],
                        userName: docs[index]['announcedBy'],
                        date: DateFormat(
                          'dd-MM-yyyy',
                        ).format((docs[index]['time'] as Timestamp).toDate()),
                        message:
                            docs[index]['message'] ?? 'No message available.',
                        linkText: 'View Assignment link',
                        linkIcon: Icons.link_off_outlined,
                      ),
                    );
                  },
                );
              },
            ),
            // Bottom navigation
          ],
        ),
      ),
    );
  }

  Widget _buildRoundMenuButton({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
