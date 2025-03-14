import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class JoinClassDialog extends StatefulWidget {
  const JoinClassDialog({Key? key}) : super(key: key);

  @override
  _JoinClassDialogState createState() => _JoinClassDialogState();
}

class _JoinClassDialogState extends State<JoinClassDialog> {
  final TextEditingController _classCodeController = TextEditingController();
  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _classCodeController.dispose();
    super.dispose();
  }

  Future<bool> _verifyClassCode(String code) async {
    try {
      // Query the classrooms collection to check if the code exists
      final querySnapshot =
          await _firestore
              .collection('classrooms')
              .where('room', isEqualTo: code)
              .limit(1)
              .get();

      // If we have a document, the class code is valid
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error verifying class code: $e');
      return false;
    }
  }

  Future<void> _joinClassroom(BuildContext context, String code) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Verify if the class code exists
      final isValidCode = await _verifyClassCode(code);

      if (isValidCode) {
        // Get the classroom document
        final querySnapshot =
            await _firestore
                .collection('classrooms')
                .where('room', isEqualTo: code)
                .limit(1)
                .get();

        final classroomDoc = querySnapshot.docs.first;
        final classroomData = classroomDoc.data();
        final classroomId = classroomDoc.id;

        // Navigate to the ClassroomDetailScreen with the classroom data
        Navigator.pop(context); // Close the dialog
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ClassroomDetailScreen(
                  classroomId: classroomId,
                  classroomData: classroomData,
                ),
          ),
        );
      } else {
        // Show error message if the class code is invalid
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid class code. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error joining classroom: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Join Class',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _classCodeController,
            decoration: InputDecoration(
              hintText: 'Enter class code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.class_),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed:
                    _isLoading
                        ? null
                        : () async {
                          if (_classCodeController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a class code'),
                              ),
                            );
                            return;
                          }

                          await _joinClassroom(
                            context,
                            _classCodeController.text,
                          );
                        },
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text('Join'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2937),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ClassroomDetailScreen extends StatefulWidget {
  final String classroomId;
  final Map<String, dynamic> classroomData;

  const ClassroomDetailScreen({
    Key? key,
    required this.classroomId,
    required this.classroomData,
  }) : super(key: key);

  @override
  State<ClassroomDetailScreen> createState() => _ClassroomDetailScreenState();
}

// This is a placeholder for the ClassroomDetailScreen
// You should replace this with your actual implementation
class _ClassroomDetailScreenState extends State<ClassroomDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  String _academicYear = '2020-2021';
  String _userName = '';
  List<Map<String, dynamic>> _classes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _fetchClasses();
  }

  Future<void> _fetchUserDetails() async {
    if (_currentUser != null) {
      try {
        final userDoc =
            await _firestore.collection('users').doc(_currentUser.uid).get();
        if (userDoc.exists) {
          setState(() {
            _userName = userDoc.data()?['firstName'] ?? 'Student';
          });
        }
      } catch (e) {
        print('Error fetching user details: $e');
        setState(() {
          _userName = 'Student';
        });
      }
    } else {
      setState(() {
        _userName = 'Student';
      });
    }
  }

  Future<void> _fetchClasses() async {
    try {
      // For demo purposes, we'll create sample data similar to the image
      // In a real application, you would fetch this from Firestore
      setState(() {
        _classes = [
          {
            'name': 'Graphic Fundamentals - ART101',
            'startTime': '08:15am',
            'endTime': '9:00am',
            'teacher': 'Cherise James',
            'color': Colors.purple.shade100,
          },
          {
            'name': 'Mathematics',
            'startTime': '09:00am',
            'endTime': '09:45am',
            'teacher': 'Rivka Steadman',
            'color': Colors.amber.shade100,
          },
          {
            'name': 'English',
            'startTime': '09:45am',
            'endTime': '10:30am',
            'teacher': 'Marta Magana',
            'color': Colors.blue.shade100,
          },
          {
            'name': 'Lunch Break',
            'startTime': '10:30am',
            'endTime': '11:00am',
            'teacher': '',
            'color': Colors.green.shade100,
          },
          {
            'name': 'Science',
            'startTime': '11:00am',
            'endTime': '11:45am',
            'teacher': 'Danica Partridge',
            'color': Colors.red.shade200,
          },
        ];
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching classes: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi $_userName',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  _academicYear,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Profile avatar
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade300,
                            // You can add a profile image here
                            // backgroundImage: NetworkImage('https://your-image-url.com'),
                          ),
                        ],
                      ),
                    ),
                    // Class schedule
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: _classes.length,
                          itemBuilder: (context, index) {
                            final classItem = _classes[index];
                            return _buildClassCard(classItem);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new class functionality
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: classItem['color'],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              classItem['name'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${classItem['startTime']} - ${classItem['endTime']}',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            if (classItem['teacher'].isNotEmpty)
              Text(
                classItem['teacher'],
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // View classroom functionality
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('View Classroom'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
