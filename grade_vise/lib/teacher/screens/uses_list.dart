import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/utils/colors.dart';

class PeoplePage extends StatefulWidget {
  final String classroomId;
  final String name;
  final String photoUrl;
  const PeoplePage({
    super.key,
    required this.classroomId,
    required this.name,
    required this.photoUrl,
  });

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  // Static data for now, later will come from Firebase

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('classrooms')
              .doc(widget.classroomId)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          backgroundColor: bgColor, // Dark navy background
          body: SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                ),

                const SizedBox(height: 30),

                // Teacher Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F0FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Teacher',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const Icon(
                        Icons.person_add_alt,
                        color: Color(0xFF2D3142),
                        size: 22,
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  height: 1,
                  color: Colors.grey[700],
                  margin: const EdgeInsets.only(top: 10),
                ),

                // Teacher List Item
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.photoUrl),
                          ),
                          color: Color(0xFFD3D3D3),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Student Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F0FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Student',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${snapshot.data!['users'].length} Student',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFF2D3142),
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  height: 1,
                  color: Colors.grey[700],
                  margin: const EdgeInsets.only(top: 10),
                ),

                const SizedBox(height: 12),

                // Filter Button with Selection Indicator

                // Student List
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!['users'].length,
                    itemBuilder: (context, index) {
                      // Calculate different background colors for alternating items
                      Color backgroundColor;
                      if (index % 2 == 0) {
                        backgroundColor = const Color(
                          0xFF3A4553,
                        ); // Lighter gray
                      } else {
                        backgroundColor = const Color(0xFF1E2530); // Dark navy
                      }

                      return StreamBuilder(
                        stream:
                            FirebaseFirestore.instance
                                .collection('users')
                                .where(
                                  'uid',
                                  isEqualTo: snapshot.data!['users'][index],
                                )
                                .snapshots(),
                        builder: (context, snap) {
                          if (snap.data == null) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(color: backgroundColor),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 16.0,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        snap.data!.docs[index]['photoURL'] == ''
                                            ? "https://i.pinimg.com/474x/59/af/9c/59af9cd100daf9aa154cc753dd58316d.jpg"
                                            : snap
                                                .data!
                                                .docs[index]['photoURL'],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        snap.data!.docs[index]['email'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.more_vert_outlined),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
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
}
