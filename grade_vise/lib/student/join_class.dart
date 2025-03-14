import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/student/join_class_dialog.dart';
import 'package:intl/intl.dart';

class JoinClassScreen extends StatefulWidget {
  const JoinClassScreen({Key? key}) : super(key: key);

  @override
  _JoinClassScreenState createState() => _JoinClassScreenState();
}

class _JoinClassScreenState extends State<JoinClassScreen> {
  final TextEditingController _classCodeController = TextEditingController();
  bool _isJoining = false;

  @override
  void dispose() {
    _classCodeController.dispose();
    super.dispose();
  }

  void _joinClass() async {
    // Show the dialog to enter class code
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) => const JoinClassDialog(),
    );

    // If the user entered a class code and pressed Join
    if (result != null && result is String) {
      setState(() {
        _isJoining = true;
      });

      // Simulate API call to join class
      await Future.delayed(const Duration(seconds: 2));

      // Here you would add your actual API call to join the class
      // For example:
      // final success = await ClassService.joinClass(result);

      setState(() {
        _isJoining = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully joined the class: $result')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          backgroundColor: const Color(0xFF1F2937),

          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with profile picture
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi ${snapshot.data!['name']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${int.parse(DateFormat('yyyy').format(DateTime.now()))}-${int.parse(DateFormat('yyyy').format(DateTime.now())) + 1}',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          snapshot.data!['photoURL'].isEmpty
                              ? "https://i.pinimg.com/474x/59/af/9c/59af9cd100daf9aa154cc753dd58316d.jpg"
                              : snapshot.data!['photoURL'],
                        ),
                        // You can replace this with actual profile image
                        // backgroundImage: AssetImage('assets/images/profile.png'),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                Center(
                  child: Image.asset(
                    'assets/images/community_illustration.png',
                    // If you don't have this image, you can replace it with a placeholder
                    // or another image you have
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.people,
                        size: 100,
                        color: Colors.white54,
                      );
                    },
                  ),
                ),

                // Join button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: SizedBox(
                      width: 240,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _isJoining ? null : _joinClass,
                        icon: const Icon(Icons.add),
                        label:
                            _isJoining
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'Let\'s Start',
                                  style: TextStyle(fontSize: 18),
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          // Add bottom navigation here if needed
        );
      },
    );
  }
}
