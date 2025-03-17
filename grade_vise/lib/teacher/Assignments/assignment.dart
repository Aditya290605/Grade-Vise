import 'package:flutter/material.dart';
import 'package:grade_vise/teacher/Assignments/addAssignment.dart';
import 'package:grade_vise/teacher/Assignments/animated_submission_sheet.dart';

class AssignmentsPage extends StatelessWidget {
  final String photUrl;
  const AssignmentsPage({super.key, required this.photUrl});

  // Modified function to handle checking submissions
  void _checkSubmissions(
    BuildContext context,
    String subject,
    String assignment,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Simulate loading data (in real app, this would be fetch the data from firebase)
    Future.delayed(const Duration(seconds: 2), () {
      // Dismiss the loading dialog
      Navigator.pop(context);

      // Show submission details with auto-scrolling container
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder:
            (context) => AnimatedSubmissionSheet(
              subject: subject,
              assignment: assignment,
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF1F2937),

        body: Column(
          children: [
            const SizedBox(height: 10),

            /// + Button added before the search icon
            IconButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssignmentCreationPage(),
                    ),
                  ),
              icon: Icon(
                Icons.add,
                size: 28,
                color: const Color.fromARGB(255, 255, 255, 255),
              ), // "+" icon
            ),

            IconButton(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.4,
              ),
              onPressed: () {},
              icon: Image.asset("assets/images/teacher/components/search.png"),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  photUrl.isEmpty
                      ? "https://i.pinimg.com/474x/59/af/9c/59af9cd100daf9aa154cc753dd58316d.jpg"
                      : photUrl,
                ),
              ),
            ),

            buildAssignmentHeader(),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _buildAssignmentCard(
                    context,
                    'Mathematics',
                    'Surface Areas and Volumes',
                  ),
                  _buildAssignmentCard(context, 'Physics', 'Force and Motion'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAssignmentHeader() {
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
                'Assignment',
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

  Widget _buildAssignmentCard(
    BuildContext context,
    String subject,
    String title,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE3EAFC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                subject,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Students Submitted',
                  style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                ),
                Text(
                  '107/140',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last Submission Date',
                  style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                ),
                Text(
                  '10 Dec 20',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _checkSubmissions(context, subject, title),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F2937),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                'Check Submissions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Color(0xFF1F2937)),
            onPressed: () {},
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.bar_chart, color: Colors.white),
              onPressed: () {},
            ),
          ),
          IconButton(
            icon: const Icon(Icons.video_call, color: Color(0xFF1F2937)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFF1F2937)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
