import 'package:flutter/material.dart';
import 'package:grade_vise/teacher/screens/assignments.dart';

import 'package:grade_vise/teacher/screens/classroom_details.dart';
import 'package:grade_vise/teacher/screens/meet.dart';
import 'package:grade_vise/teacher/screens/uses_list.dart';
import 'package:grade_vise/utils/colors.dart';

class MainPage extends StatefulWidget {
  final String classroomId;
  final String userPhoto;
  const MainPage({
    super.key,
    required this.classroomId,
    required this.userPhoto,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index1 = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index1,
        children: [
          ClassroomDetails(
            classroomId: widget.classroomId,
            photoUrl: widget.userPhoto,
          ),

          Assignments(),
          Meet(),
          UsesList(),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory, // Removes splash effect
          ),
          child: BottomNavigationBar(
            currentIndex: index1,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: bgColor,
            unselectedItemColor: Colors.grey,

            iconSize: 30,
            onTap: (index) {
              setState(() {
                index1 = index;
              });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(
                icon: Icon(Icons.verified_user),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
