import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/utils/colors.dart';

class PeoplePage extends StatefulWidget {
  final String classroomId;
  final String name;
  final String photoUrl;
  final String teacherPhoto;
  final String teachername;

  const PeoplePage({
    super.key,
    required this.classroomId,
    required this.name,
    required this.photoUrl,
    required this.teacherPhoto,
    required this.teachername,
  });

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('classrooms')
              .doc(widget.classroomId)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const Center(child: Text('No data available'));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final users = List<String>.from(data['users'] ?? []);

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),

                // Teacher Section
                _buildHeader('Teacher', Icons.person_add_alt),
                _buildDivider(),
                _buildTeacherInfo(widget.teacherPhoto, widget.teachername),

                // Student Section
                _buildHeader('Student', Icons.add, '${users.length} Student'),
                _buildDivider(),
                const SizedBox(height: 12),

                // Student List
                Expanded(
                  child:
                      users.isEmpty
                          ? const Center(child: Text('No students available'))
                          : ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final userId = users[index];
                              return _buildStudentItem(userId, index);
                            },
                          ),
                ),
              ],
            ),
          ),
        );
      },
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

  Widget _buildTeacherInfo(String photoUrl, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              photoUrl.isEmpty
                  ? 'https://i.pinimg.com/474x/59/af/9c/59af9cd100daf9aa154cc753dd58316d.jpg'
                  : photoUrl,
            ),
            radius: 22,
          ),
          const SizedBox(width: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentItem(String userId, int index) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }

        if (!snap.hasData || snap.data?.data() == null) {
          return const Center(child: Text('No user data available'));
        }

        final userData = snap.data!.data() as Map<String, dynamic>;
        final photoURL =
            userData['photoURL']?.isEmpty ?? true
                ? 'https://i.pinimg.com/474x/59/af/9c/59af9cd100daf9aa154cc753dd58316d.jpg'
                : userData['photoURL'];
        final email = userData['email'] ?? 'No email';

        return Container(
          color:
              index % 2 == 0
                  ? const Color(0xFF3A4553)
                  : const Color(0xFF1E2530),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(photoURL)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    email,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(Icons.more_vert_outlined, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }
}
