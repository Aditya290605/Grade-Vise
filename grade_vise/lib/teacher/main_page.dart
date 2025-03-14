import 'package:flutter/material.dart';
import 'package:grade_vise/teacher/screens/Grading.dart';
import 'package:grade_vise/teacher/screens/classroom_details.dart';
import 'package:grade_vise/teacher/screens/meet.dart';
import 'package:grade_vise/teacher/screens/uses_list.dart';

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
  int selectedIndex = 0;
  final List<IconData> icons = [
    Icons.home_outlined,
    Icons.show_chart,
    Icons.videocam_outlined,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          ClassroomDetails(
            classroomId: widget.classroomId,
            photoUrl: widget.userPhoto,
          ),
          Grading(),
          Meet(),
          UsesList(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Animated background effect
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left:
                  (MediaQuery.of(context).size.width / 4.45) * selectedIndex +
                  30, // Move based on index
              top: 12,
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  icons.length,
                  (index) => _buildNavItem(index, icons[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int itemIndex, IconData iconData) {
    final bool isSelected = selectedIndex == itemIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = itemIndex;
        });
      },
      child: Container(
        width: 55, // Match background width
        height: 55,
        alignment: Alignment.center,
        child: Icon(
          iconData,
          size: 28,
          color: isSelected ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}
