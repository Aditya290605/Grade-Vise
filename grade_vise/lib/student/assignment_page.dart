import 'package:flutter/material.dart';

// Assignment data model
class Assignment {
  final String subject;
  final String title;
  final int submittedCount;
  final int totalCount;
  final String lastSubmissionDate;

  Assignment({
    required this.subject,
    required this.title,
    required this.submittedCount,
    required this.totalCount,
    required this.lastSubmissionDate,
  });
}

// Sample data
List<Assignment> getSampleAssignments() {
  return [
    Assignment(
      subject: 'Mathematics',
      title: 'Surface Areas and Volumes',
      submittedCount: 107,
      totalCount: 140,
      lastSubmissionDate: '10 Dec 20',
    ),
    Assignment(
      subject: 'Science',
      title: 'Structure of Atoms',
      submittedCount: 203,
      totalCount: 276,
      lastSubmissionDate: '30 Oct 20',
    ),
    Assignment(
      subject: 'English',
      title: 'My Bestfriend Essay',
      submittedCount: 67,
      totalCount: 70,
      lastSubmissionDate: '30 Sep 20',
    ),
  ];
}

// Assignment page
class AssignmentPage extends StatelessWidget {
  final List<Assignment> assignments;

  AssignmentPage({
    Key? key,
    required this.assignments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2936),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Assignment',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final assignment = assignments[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9F0FF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          assignment.subject,
                          style: const TextStyle(
                            color: Color(0xFF2A4375),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        assignment.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Total Students Submitted',
                        '${assignment.submittedCount}/${assignment.totalCount}',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Last Submission Date',
                        assignment.lastSubmissionDate,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle view submissions button tap
                            print('View submissions for ${assignment.title}');
                            // You can add navigation to a details page here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A3A4D),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'View Submissions',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF7A7A7A),
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}