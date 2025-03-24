import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubmissionsOverviewScreen extends StatelessWidget {
  final Color bgColor;
  final String classroomId;

  const SubmissionsOverviewScreen({
    super.key,
    required this.bgColor,
    required this.classroomId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Submissions'),
        backgroundColor: bgColor,
        foregroundColor: _getContrastingColor(bgColor),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary card at the top
              _buildSummaryCard(context),
              const SizedBox(height: 20),

              // List title
              Text(
                'Recent Submissions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getContrastingColor(bgColor),
                ),
              ),
              const SizedBox(height: 12),

              // List of submission cards
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('submissions')
                          .where('classroomId', isEqualTo: classroomId)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading submissions',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No submissions yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        return StreamBuilder(
                          stream:
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(data['userId'])
                                  .snapshots(),
                          builder: (context, snap) {
                            if (snap.data == null) {
                              const Center(child: CircularProgressIndicator());
                            }
                            return _buildSubmissionCard(
                              context,
                              name: snap.data!['name'] ?? 'Unknown',
                              email: snap.data!['email'] ?? 'No email',
                              submissionTime:
                                  data['uploadedAt'] != null
                                      ? (data['uploadedAt'] as Timestamp)
                                          .toDate()
                                      : DateTime.now(),
                              assignmentTitle:
                                  data['title'] ?? 'Unknown Assignment',
                              fileType: data['fileType'] ?? 'unknown',
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('submissions').snapshots(),
      builder: (context, snapshot) {
        int totalSubmissions =
            snapshot.hasData ? snapshot.data!.docs.length : 0;

        // Calculate submissions in last 24 hours
        int recentSubmissions = 0;
        if (snapshot.hasData) {
          final DateTime yesterday = DateTime.now().subtract(
            const Duration(days: 1),
          );
          recentSubmissions =
              snapshot.data!.docs.where((doc) {
                final submissionTime =
                    (doc.data() as Map<String, dynamic>)['submissionTime']
                        as Timestamp?;
                return submissionTime != null &&
                    submissionTime.toDate().isAfter(yesterday);
              }).length;
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Submissions Overview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context,
                        'Total',
                        totalSubmissions.toString(),
                        Icons.assignment_turned_in,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        'Last 24h',
                        recentSubmissions.toString(),
                        Icons.schedule,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmissionCard(
    BuildContext context, {
    required String name,
    required String email,
    required DateTime submissionTime,
    required String assignmentTitle,
    required String fileType,
  }) {
    final formattedDate = DateFormat(
      'MMM dd, yyyy - HH:mm',
    ).format(submissionTime);
    final timeAgo = _getTimeAgo(submissionTime);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // File type icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getFileColor(fileType).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getFileIcon(fileType),
                color: _getFileColor(fileType),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Submission details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.assignment, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          assignmentTitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Submission time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);

    if (duration.inSeconds < 60) {
      return 'Just now';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h ago';
    } else if (duration.inDays < 7) {
      return '${duration.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(dateTime);
    }
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getContrastingColor(Color backgroundColor) {
    // Calculate luminance to determine if we should use black or white text
    double luminance =
        (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;

    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
