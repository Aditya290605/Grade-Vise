import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grade_vise/student/classroom_details.dart';
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

