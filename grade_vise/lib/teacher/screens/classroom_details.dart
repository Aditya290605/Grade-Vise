import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/teacher/Assignments/assignment.dart';
import 'package:grade_vise/utils/colors.dart';
import 'package:grade_vise/widgets/classroom_details/announcement.dart';
import 'package:grade_vise/widgets/classroom_details/components.dart';
import 'package:grade_vise/widgets/classroom_details/custom_textfeild.dart';
import 'package:grade_vise/widgets/classroom_details/subject_container.dart';

class ClassroomDetails extends StatefulWidget {
  final String classroomId;
  final String photoUrl;
  const ClassroomDetails({
    super.key,
    required this.classroomId,
    required this.photoUrl,
  });

  @override
  State<ClassroomDetails> createState() => _ClassroomDetailsState();
}

class _ClassroomDetailsState extends State<ClassroomDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('classrooms')
                .doc(widget.classroomId)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          "assets/images/teacher/components/more_options.png",
                        ),
                      ),
                    ),

                    IconButton(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.5,
                      ),
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/images/teacher/components/search.png",
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          widget.photoUrl.isEmpty
                              ? "https://i.pinimg.com/474x/59/af/9c/59af9cd100daf9aa154cc753dd58316d.jpg"
                              : widget.photoUrl,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: SubjectContainer(title: snapshot.data!['name']),
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
                                builder: (context) => AssignmentsPage(),
                              ),
                            ),
                        imgpath: 'assets/images/teacher/tasks/assignment.png',
                        title: "Assignments",
                      ),
                      Components(
                        ontap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AssignmentsPage(),
                              ),
                            ),
                        imgpath: 'assets/images/teacher/tasks/feedback.png',
                        title: "Feedback",
                      ),
                      Components(
                        ontap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AssignmentsPage(),
                              ),
                            ),
                        imgpath: 'assets/images/teacher/tasks/time_table.png',
                        title: "Time table",
                      ),
                      Components(
                        ontap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AssignmentsPage(),
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
                    hintText: 'Announce something to your class',
                    icon: Icons.announcement_outlined,
                  ),
                ),

                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: PostContainerWidget(
                    userName: 'Aditya',
                    date: 'yesterday',
                    message:
                        'Hello everyone, I have uploaded the assignment for this week. Please check it out.',
                    linkText: 'View Assignment link',
                    linkIcon: Icons.link_off_outlined,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
