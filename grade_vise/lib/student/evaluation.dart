import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:grade_vise/student/clarification_page.dart';
import 'package:grade_vise/utils/colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StudentEvaluation extends StatelessWidget {
  final String assignmentTitle;
  final int marks;
  final int totalMarks;
  final String feedback;
  final bool isChecked;

  const StudentEvaluation({
    super.key,
    required this.assignmentTitle,
    required this.marks,
    required this.totalMarks,
    required this.feedback,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Assignment Evaluation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Show help info
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader()
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 24),
                _buildEvaluationCard(context)
                    .animate()
                    .fadeIn(duration: 800.ms, delay: 300.ms)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1, 1),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: bgColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evaluation Results',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review your assignment evaluation below',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationCard(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAssignmentTitle(),
              const Divider(height: 36, thickness: 1),
              _buildScoreSection()
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 800.ms),
              const SizedBox(height: 28),
              _buildFeedbackSection(
                context,
              ).animate(delay: 900.ms).fadeIn(duration: 800.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentTitle() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade300, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade200.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.assignment, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                assignmentTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      isChecked
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isChecked ? Icons.check_circle : Icons.pending,
                      size: 16,
                      color: isChecked ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isChecked ? 'Evaluated' : 'Pending Evaluation',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isChecked ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScoreSection() {
    final percentage = marks / totalMarks;

    return Visibility(
      visible: isChecked,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 45.0,
                lineWidth: 10.0,
                animation: true,
                animationDuration: 1500,
                percent: percentage,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$marks',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(),
                      ),
                    ),
                    Text(
                      '/$totalMarks',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: _getScoreColor(),
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getScoreMessage(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _getScoreColor(),
                          ),
                        ),
                        Text(
                          '${(percentage * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: Colors.grey.shade200,
                        color: _getScoreColor(),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection(BuildContext context) {
    return Visibility(
      visible: isChecked,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.comment_outlined, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Feedback',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MarkdownBody(
                    data: feedback, // Directly pass the feedback string
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.grey.shade800,
                      ),
                      strong: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  (context),
                  MaterialPageRoute(
                    builder:
                        (context) => ClarificationRequestPage(
                          assignmentId: '',
                          assignmentTitle: '',
                          studentId: '',
                          studentName: "",
                          title: "",
                        ),
                  ),
                );
              },
              icon: const Icon(Icons.chat_outlined),
              label: const Text('Request Clarification'),
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreMessage() {
    final percentage = marks / totalMarks;
    if (percentage >= 0.9) return 'Excellent!';
    if (percentage >= 0.8) return 'Very Good';
    if (percentage >= 0.7) return 'Good';
    if (percentage >= 0.6) return 'Satisfactory';
    if (percentage >= 0.5) return 'Pass';
    return 'Needs Improvement';
  }

  Color _getScoreColor() {
    final percentage = marks / totalMarks;
    if (percentage >= 0.9) return Colors.green.shade700;
    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.7) return Colors.blue;
    if (percentage >= 0.6) return Colors.amber.shade700;
    if (percentage >= 0.5) return Colors.orange;
    return Colors.red;
  }
}
