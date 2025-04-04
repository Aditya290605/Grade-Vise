import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/teacher/screens/persoanl_details.dart';
import 'package:grade_vise/utils/colors.dart';

class Grading extends StatefulWidget {
  final String classroomId;
  final int students;

  final int assignment;

  const Grading({
    super.key,
    required this.classroomId,
    required this.students,
    required this.assignment,
  });

  @override
  GradingState createState() => GradingState();
}

class GradingState extends State<Grading> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterStudents);
  }

  void _filterStudents() {}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // App Bar

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),

              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.notifications, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildStatCard(
                    icon: Icons.people,
                    value: widget.students.toString(),
                    label: 'Total Students',
                    color: const Color(0xFF3B82F6),
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    icon: Icons.task,
                    value: '${widget.assignment}',
                    label: 'Total assignments',
                    color: const Color(0xFF8B5CF6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildStatCard(
                    icon: Icons.timer,
                    value: '64%',
                    label: 'Activity Ratio',
                    color: const Color(0xFFFACC15),
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    icon: Icons.star,
                    value: '245',
                    label: 'Reward Points',
                    color: const Color(0xFFF43F5E),
                  ),
                ],
              ),
            ),
            _buildDivider(),

            const SizedBox(height: 20),

            _buildHeader('Students', Icons.person),
            _buildDivider(),

            const SizedBox(height: 20),

            // Student List
            Expanded(child: _buildStudentList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon, [String? subtitle]) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F0FF),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D3142),
            ),
          ),
          Row(
            children: [
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(icon, color: const Color(0xFF2D3142), size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey[700],
      margin: const EdgeInsets.only(top: 10),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList() {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .where(
                'uid',
                isNotEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
              .where('classrooms', arrayContains: widget.classroomId)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: snapshot.data!.docs.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final student = snapshot.data!.docs[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () async {
                  var snap1 =
                      await FirebaseFirestore.instance
                          .collection('assignments')
                          .where('classroomId', isEqualTo: widget.classroomId)
                          .get();

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => StudentDashboard(
                            name: student['name'],
                            uid: student['uid'],
                            length: snap1.docs.length,
                            classroom: widget.classroomId,
                            email: student['email'],
                            assignements: snap1.docs,
                          ),
                    ),
                  );
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    student["name"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '0',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
