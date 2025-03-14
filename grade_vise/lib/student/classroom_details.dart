import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grade_vise/student/classroom_screen.dart';

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
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),
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
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classItem) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClassroomScreen(classData: classItem, classroomId: '',),
          ),
          
        );
      },
      child: Container(
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
                    onPressed: () { debugPrint('this is clicked');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ClassroomScreen(classData: classItem, classroomId: '',),
                                
                        ),
                      );
                    },
                    icon: const Icon(Icons.class_, size: 16),
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
      ),
    );
  }
}

// New ClassroomScreen Page
// class ClassroomScreen extends StatelessWidget {
//   final Map<String, dynamic> classData;

//   const ClassroomScreen({Key? key, required this.classData}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(classData['name'])),
//       body: Center(child: Text('Welcome to ${classData['name']} class!')),
//     );
//   }
// }
