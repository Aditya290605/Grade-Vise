import 'package:flutter/material.dart';
import 'package:grade_vise/student/join_class_dialog.dart';

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

    // Show success message and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Successfully joined the class: $result')),
    );
    
    // You can navigate to the class details page here
    // For example:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ClassDetailsScreen(classCode: result)),
    // );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                      const Text(
                        'Hi Akshay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '2020-2021',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    // You can replace this with actual profile image
                    // backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == 0 ? Colors.white : Colors.white30,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            
            // const SizedBox(height: 24),
            
            
            // const SizedBox(height: 24),
            
            // Illustration
            Expanded(
              child: Center(
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
                    label: _isJoining
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Let\'s Start',
                            style: TextStyle(fontSize: 18),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F2937),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Add bottom navigation here if needed
    );
  }
}