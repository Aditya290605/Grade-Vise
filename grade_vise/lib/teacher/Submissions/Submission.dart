import 'package:flutter/material.dart';
import 'package:grade_vise/teacher/Submissions/CheckEachSubmission.dart';

// Note: Since we're using a placeholder for the custom navigation import,
// I'll include the CustomNavigation class directly in this file
// In your actual implementation, use the import statement:
import 'package:grade_vise/widgets/classroom_details/custom_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: const SubmissionsPage(),
    );
  }
}

class SubmissionsPage extends StatelessWidget {
  const SubmissionsPage({super.key});

  Widget _buildAssignmentHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3D1EF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFF8D7A4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Submissions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF2D3142), size: 30),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF2D3142), size: 30),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFD9D9D9),
              radius: 20,
              child: Container(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAssignmentHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  SubmissionCard(
                    subject: 'Mathematics',
                    title: 'Surface Areas and Volumes',
                    submitted: '107',
                    total: '140',
                  ),
                  const SizedBox(height: 16),
                  SubmissionCard(
                    subject: 'Science',
                    title: 'Structure of Atoms',
                    submitted: '203',
                    total: '276',
                  ),
                  const SizedBox(height: 16),
                  SubmissionCard(
                    subject: 'English',
                    title: 'My Bestfriend Essay',
                    submitted: '67',
                    total: '70',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigation(
        icons: [
          Icons.home_outlined,
          Icons.show_chart,
          Icons.videocam_outlined,
          Icons.person_outline,
        ],
        selectedIndex: 1,
      ),
    );
  }
}

// Including the CustomNavigation class for reference

class SubmissionCard extends StatelessWidget {
  final String subject;
  final String title;
  final String submitted;
  final String total;

  const SubmissionCard({
    super.key,
    required this.subject,
    required this.title,
    required this.submitted,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EEFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              subject,
              style: const TextStyle(
                color: Color(0xFF2D3142),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2D3142),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Students Submitted',
                style: TextStyle(color: Color(0xFF8D8D8D), fontSize: 16),
              ),
              Text(
                '$submitted/$total',
                style: const TextStyle(
                  color: Color(0xFF2D3142),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Checkeachsubmission(),
                ),
              );
            },
            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
            label: const Text(
              'Check Submissions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D3142),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }
}
