import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/responsive_layout/responsive_screen.dart';
import 'package:grade_vise/student/Student_meet.dart';
import 'package:grade_vise/student/classroom_screen.dart';
import 'package:grade_vise/student/my_grades.dart';
import 'package:grade_vise/teacher/profile.dart';
import 'package:grade_vise/teacher/screens/meet.dart';
import 'package:grade_vise/teacher/screens/uses_list.dart';
import 'package:grade_vise/utils/colors.dart';

class MainPageScreen extends StatefulWidget {
  final String photoUrl;
  final String classroomId;
  final String name;
  final String teahername;
  final String teacherPhoto;
  final Map<String, dynamic> classData;

  const MainPageScreen({
    super.key,
    required this.photoUrl,
    required this.teahername,
    required this.classData,
    required this.teacherPhoto,
    required this.name,
    required this.classroomId,
  });

  @override
  State<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
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
      drawer: Drawer(
        backgroundColor: bgColor,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  child: ClipOval(child: Image.network(widget.teacherPhoto)),
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuSection('CLASSROOM', [
                _buildMenuItem(Icons.home_outlined, 'View profile', 0, () {}),
                _buildMenuItem(Icons.info, 'About', 1, () {}),
              ]),

              _buildMenuItem(Icons.info, 'Log Out', 1, () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResponsiveScreen()),
                );
              }),
            ],
          ),
        ),
      ),
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Builder(
                  builder: (context) {
                    return Expanded(
                      child: IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Image.asset(
                          "assets/images/teacher/components/more_options.png",
                        ),
                      ),
                    );
                  },
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
                    backgroundImage: NetworkImage(widget.photoUrl),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              child: IndexedStack(
                index: selectedIndex,
                children: [
                  ClassroomStudentScreen(
                    classData: widget.classData,
                    classroomId: widget.classroomId,
                    photoUrl: widget.photoUrl,
                    name: widget.name,
                  ),
                  MyGrades(),
                  Student_Meet(),
                  MyProfilePage(),
                  // PeoplePage(
                  //   classroomId: widget.classroomId,
                  //   name: widget.name,
                  //   teachername: widget.teahername,
                  //   photoUrl: widget.photoUrl,
                  //   teacherPhoto: widget.teacherPhoto,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        height: 75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 10, spreadRadius: 2),
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

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  // Build Menu Item (same as previous implementation)
  Widget _buildMenuItem(
    IconData icon,
    String title,
    int index,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}
