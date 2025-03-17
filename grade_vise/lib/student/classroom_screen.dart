import 'package:flutter/material.dart';
import 'package:grade_vise/student/assignment_page.dart';

class ClassroomScreen extends StatefulWidget {
  final Map<String, dynamic> classData;
  final String classroomId;

  const ClassroomScreen({
    Key? key,
    required this.classData,
    required this.classroomId,
  }) : super(key: key);

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(backgroundColor: Colors.grey.shade300),
          ),
        ],
      ),
      body: Column(
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
                        widget.classData['name'] ??
                            'Graphic Fundamentals - ART101',
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                          builder: (context) => AssignmentPage(assignments: getSampleAssignments()),
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
                  onTap: () {},
                ),
                _buildRoundMenuButton(
                  icon: Icons.bar_chart,
                  iconColor: Colors.white,
                  backgroundColor: Color(0xFF5CB85C),
                  label: 'Submissions',
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Announcement input
          Padding(
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
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: const Icon(Icons.mic, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Announcement card
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with profile
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          radius: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Akshay',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Yesterday',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.more_vert),
                      ],
                    ),
                  ),

                  // Announcement content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Explore your interests and meet like-minded students by joining one of our many clubs. Whether you\'re into sports, arts, or academics, there\'s a club for you. Find your community!\nExplore your interests and meet like-minded students by joining one and many',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  // Link button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.link),
                          SizedBox(width: 8),
                          Text(
                            'Link: Assignment for Graphic AI Lesson',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom navigation
          Container(
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavButton(Icons.home, isSelected: false),
                _buildNavButton(Icons.trending_up, isSelected: true),
                _buildNavButton(Icons.video_call, isSelected: false),
                _buildNavButton(Icons.person, isSelected: false),
              ],
            ),
          ),
        ],
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

  Widget _buildNavButton(IconData icon, {required bool isSelected}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2D3748) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: isSelected ? Colors.white : Colors.black54),
    );
  }
}
