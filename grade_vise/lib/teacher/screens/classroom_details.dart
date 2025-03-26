import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/teacher/announcements/anncouncements.dart';
import 'package:grade_vise/teacher/submissions/submission.dart';
import 'package:grade_vise/teacher/assignments/assignment.dart';
import 'package:grade_vise/utils/colors.dart';
import 'package:grade_vise/widgets/classroom_details/announcement.dart';
import 'package:grade_vise/widgets/classroom_details/components.dart';
import 'package:grade_vise/widgets/classroom_details/custom_textfeild.dart';
import 'package:grade_vise/widgets/classroom_details/subject_container.dart';
import 'package:intl/intl.dart';

class ClassroomDetails extends StatefulWidget {
  final String username;
  final String classroomId;
  final String photoUrl;
  const ClassroomDetails({
    super.key,
    required this.classroomId,
    required this.photoUrl,
    required this.username,
  });

  @override
  State<ClassroomDetails> createState() => _ClassroomDetailsState();
}

class _ClassroomDetailsState extends State<ClassroomDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('classrooms')
                .doc(widget.classroomId)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Classroom not found.'));
          }

          final classroomData = snapshot.data!.data() as Map<String, dynamic>;

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: SubjectContainer(title: classroomData['name']),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Components(
                          ontap:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => AssignmentsPage(
                                        photUrl: widget.photoUrl,
                                        uid: classroomData['uid'],
                                        classroomId:
                                            classroomData['classroomId'],
                                      ),
                                ),
                              ),
                          imgpath: 'assets/images/teacher/tasks/assignment.png',
                          title: "Assignments",
                        ),
                        Components(
                          ontap: () {},
                          imgpath: 'assets/images/teacher/tasks/feedback.png',
                          title: "Feedback",
                        ),
                        Components(
                          ontap: () {},
                          imgpath: 'assets/images/teacher/tasks/time_table.png',
                          title: "Time Table",
                        ),
                        Components(
                          ontap:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => SubmissionsPage(
                                        photo: widget.photoUrl,
                                        classroomId:
                                            classroomData['classroomId'],
                                      ),
                                ),
                              ),
                          imgpath: 'assets/images/teacher/tasks/submision.png',
                          title: "Submissions",
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: CustomTextFieldWidget(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AnnouncementDialog(
                                classroomId: widget.classroomId,
                                profilePic: widget.photoUrl,
                                name: widget.username,
                                uid: classroomData['uid'],
                              ),
                        );
                      },
                      hintText: 'Announce something Here',
                      icon: Icons.announcement_outlined,
                    ),
                  ),

                  SizedBox(height: 20),

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
                        return Center(
                          child: Text('Error loading announcements'),
                        );
                      }

                      final docs = snapshot.data?.docs;
                      if (docs == null || docs.isEmpty) {
                        return Center(
                          child: Text('No announcements available.'),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: PostContainerWidget(
                              docId: docs[index]['announcementId'],
                              uploadTime:
                                  DateFormat('h:mm a')
                                      .format(
                                        (docs[index]['time'] as Timestamp)
                                            .toDate(),
                                      )
                                      .toString(),
                              image: docs[index]['profilePic'],
                              userName: docs[index]['announcedBy'],
                              date: DateFormat('dd-MM-yyyy').format(
                                (docs[index]['time'] as Timestamp).toDate(),
                              ),
                              message:
                                  docs[index]['message'] ??
                                  'No message available.',
                              linkText: 'View Assignment link',
                              linkIcon: Icons.link_off_outlined,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
