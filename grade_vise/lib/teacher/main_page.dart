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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
              blurRadius: 80,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined),
              _buildNavItem(1, Icons.show_chart),
              _buildNavItem(2, Icons.videocam_outlined),
              _buildNavItem(3, Icons.person_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int itemIndex, IconData iconData) {
    final bool isSelected = index1 == itemIndex;

    return InkWell(
      onTap: () {
        setState(() {
          index1 = itemIndex;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration:
            isSelected
                ? BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                )
                : null,
        child: Icon(
          iconData,
          size: 28,
          color: isSelected ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}
