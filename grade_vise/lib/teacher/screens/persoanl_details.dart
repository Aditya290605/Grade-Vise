import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grade_vise/teacher/submissions/ai_methods.dart';
import 'package:grade_vise/utils/colors.dart';

class StudentDashboard extends StatefulWidget {
  final String name;
  final int length;
  final String email;
  final String uid;
  final String classroom;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> assignements;

  const StudentDashboard({
    super.key,
    required this.assignements,
    required this.uid,
    required this.email,
    required this.length,
    required this.name,
    required this.classroom,
  });

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  List<Map<String, dynamic>> assignmentSubmissionList = [];
  bool isLoading = false;
  var snap;

  Future<void> fetchSubmissionsUsers() async {
    List<Map<String, dynamic>> tempAssignmentList = [];

    var snap1 =
        await FirebaseFirestore.instance
            .collection('summaryReport')
            .where('uid', isEqualTo: widget.uid)
            .get();

    if (snap1.docs.isNotEmpty) {
      snap = snap1.docs[0].data();
      debugPrint('$snap');
    } else {
      debugPrint('No documents found for uid: ${widget.uid}');
      snap = {}; // Assign an empty map to avoid null errors later
    }

    for (var assignment in widget.assignements) {
      String assignmentId = assignment.id;
      List<dynamic> submissionIds = assignment.data()['submissions'] ?? [];

      if (submissionIds.isNotEmpty) {
        try {
          QuerySnapshot<Map<String, dynamic>> snap =
              await FirebaseFirestore.instance
                  .collection('submissions')
                  .where('submissionId', whereIn: submissionIds)
                  .get();

          List<String> submittedUsers =
              snap.docs.map((doc) => doc['userId'] as String).toList();

          tempAssignmentList.add({
            'assignmentId': assignmentId,
            'submissions': submissionIds,
            'submittedBy': submittedUsers,
          });
        } catch (error) {
          debugPrint("Failed to fetch submissions: $error");
          tempAssignmentList.add({
            'assignmentId': assignmentId,
            'submissions': submissionIds,
            'submittedBy': [],
          });
        }
      } else {
        tempAssignmentList.add({
          'assignmentId': assignmentId,
          'submissions': [],
          'submittedBy': [],
        });
      }
    }

    setState(() {
      assignmentSubmissionList = tempAssignmentList;
    });

    debugPrint('Final assignment submission data: $assignmentSubmissionList');
  }

  @override
  void initState() {
    super.initState();
    fetchSubmissionsUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "Grade",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            _buildUserInfo(),
            const SizedBox(height: 20),
            _buildProgressTab(
              snap?['percentage'] ?? 0.0,
              snap?['grade'] ?? '',
              snap?['totalMarks'] ?? 0,
            ),
            const SizedBox(height: 20),
            _buildAssignmentTrack('Assignments'),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 20),
            _buildSummaryReport(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          Icon(Icons.search, color: Colors.black54),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.notifications_none, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Email: ${widget.email}',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab(double percentage, String grade, int totalMarks) {
    return snap == null
        ? Center(child: CircularProgressIndicator())
        : Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color(0xFF2C3441),
              elevation: 10,
              shadowColor: Colors.black.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progress Track',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A4456),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.tune,
                            size: 16,
                            color: Color(0xFF4A80F0),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Line Chart
                    SizedBox(
                      height: 180,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            drawHorizontalLine: true,
                            horizontalInterval: 25,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: const Color(0xFF3A4456),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value % 25 == 0 &&
                                      value <= 100 &&
                                      value >= 0) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                                reservedSize: 30,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const dates = [
                                    'Week1',
                                    'Week2',
                                    'Week3',
                                    'Week4',
                                    'Final',
                                  ];
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < dates.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        dates[value.toInt()],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _calculateProgressSpots(
                                percentage,
                                grade,
                                totalMarks,
                              ),
                              isCurved: true,
                              color: const Color(0xFF4A80F0),
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF4A80F0).withOpacity(0.5),
                                    const Color(0xFF4A80F0).withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter:
                                    (spot, percent, barData, index) =>
                                        FlDotCirclePainter(
                                          radius: 4,
                                          color: Colors.white,
                                          strokeWidth: 2,
                                          strokeColor: const Color(0xFF4A80F0),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Progress & Summary
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getColorForGrade(grade).withOpacity(0.8),
                                  _getColorForGrade(grade).withOpacity(0.4),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: _getColorForGrade(
                                    grade,
                                  ).withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.trending_up,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${percentage.toStringAsFixed(1)}% Completion',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Total Marks & Grade
                          Text(
                            'Total Marks: $totalMarks',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Grade: $grade',
                            style: TextStyle(
                              color: _getColorForGrade(grade),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(
              delay: 200.ms,
              begin: const Offset(0.9, 0.9),
              end: const Offset(1, 1),
            );
  }

  // Calculate spots dynamically based on percentage, grade, and total marks
  List<FlSpot> _calculateProgressSpots(
    double percentage,
    String grade,
    int totalMarks,
  ) {
    // Base progress pattern that follows a learning curve
    double baseWeek1 = 20.0;
    double baseWeek2 = 40.0;
    double baseWeek3 = 60.0;
    double baseWeek4 = 80.0;

    // Adjust based on final percentage
    // Higher performing students show earlier progress
    double factor = percentage / 100.0;

    // Adjust based on grade - better grades show more consistent progress
    double gradeAdjustment = _getGradeAdjustment(grade);

    // Adjust based on total marks - higher total marks create more dramatic improvements
    double marksAdjustment =
        totalMarks > 100 ? 1.1 : (totalMarks > 80 ? 1.0 : 0.9);

    return [
      FlSpot(
        0,
        _calculateWeekValue(
          baseWeek1,
          factor,
          gradeAdjustment,
          marksAdjustment,
        ),
      ),
      FlSpot(
        1,
        _calculateWeekValue(
          baseWeek2,
          factor,
          gradeAdjustment,
          marksAdjustment,
        ),
      ),
      FlSpot(
        2,
        _calculateWeekValue(
          baseWeek3,
          factor,
          gradeAdjustment,
          marksAdjustment,
        ),
      ),
      FlSpot(
        3,
        _calculateWeekValue(
          baseWeek4,
          factor,
          gradeAdjustment,
          marksAdjustment,
        ),
      ),
      FlSpot(4, percentage), // Final stays at actual percentage
    ];
  }

  // Calculate individual week value based on various factors
  double _calculateWeekValue(
    double baseValue,
    double factor,
    double gradeAdjustment,
    double marksAdjustment,
  ) {
    // Apply adjustments based on grade and total marks
    double adjustedValue =
        baseValue * factor * gradeAdjustment * marksAdjustment;

    // Ensure values stay between 0-100
    return adjustedValue.clamp(0.0, 100.0);
  }

  // Get color based on grade
  Color _getColorForGrade(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
      case 'A+':
        return const Color(0xFF4CAF50); // Green for top grades
      case 'B':
      case 'B+':
        return const Color(0xFF4A80F0); // Blue for good grades
      case 'C':
      case 'C+':
        return const Color(0xFFFFA726); // Orange for average grades
      case 'D':
      case 'D+':
        return const Color(0xFFFF7043); // Light red for below average
      default:
        return const Color(0xFFF44336); // Red for failing grades
    }
  }

  // Grade adjustment factor - better grades show more consistent progress
  double _getGradeAdjustment(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
      case 'A+':
        return 1.2; // A students show faster early progress
      case 'B':
      case 'B+':
        return 1.1;
      case 'C':
      case 'C+':
        return 1.0; // Average
      case 'D':
      case 'D+':
        return 0.9;
      default:
        return 0.8; // Struggling students show slower early progress
    }
  }

  Widget _buildAssignmentTrack(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          height: 250,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: widget.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final assignment =
                  assignmentSubmissionList.isNotEmpty
                      ? assignmentSubmissionList[index]
                      : null;

              bool isSubmitted =
                  assignment != null &&
                  assignment['submittedBy'].contains(widget.uid);

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    widget.assignements[index]["title"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSubmitted ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isSubmitted ? 'Submitted' : 'Pending',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContainer(
    String title,
    int totalMark,
    double percentage,
    String grade,
    String result,
    String remark,
  ) {
    // Determine color scheme based on grade
    Color primaryColor = _getGradeColor(grade);
    Color secondaryColor = _getGradeSecondaryColor(grade);

    // Determine result icon
    IconData resultIcon =
        result.toLowerCase().contains('pass')
            ? Icons.check_circle_outline
            : Icons.error_outline;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.school, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          result,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Grade pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    grade,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats row
                Row(
                  children: [
                    _buildStatItem(
                      "Total Marks",
                      totalMark.toString(),
                      Icons.score,
                      primaryColor.withOpacity(0.1),
                      primaryColor,
                    ),
                    const SizedBox(width: 12),
                    _buildStatItem(
                      "Percentage",
                      "${percentage.toStringAsFixed(1)}%",
                      Icons.percent,
                      primaryColor.withOpacity(0.1),
                      primaryColor,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Progress indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Performance",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${percentage.toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Remarks section
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.comment, size: 16, color: primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            "Teacher's Remarks",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        remark,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getGradeColor(String grade) {
    grade = grade.toUpperCase();
    if (grade.startsWith('A')) return const Color(0xFF4CAF50); // Green
    if (grade.startsWith('B')) return const Color(0xFF2196F3); // Blue
    if (grade.startsWith('C')) return const Color(0xFFFFA726); // Orange
    if (grade.startsWith('D')) return const Color(0xFFFF7043); // Light Red
    return const Color(0xFFF44336); // Red for F and others
  }

  // Helper function to get secondary color based on grade
  Color _getGradeSecondaryColor(String grade) {
    grade = grade.toUpperCase();
    if (grade.startsWith('A')) return const Color(0xFF66BB6A);
    if (grade.startsWith('B')) return const Color(0xFF42A5F5);
    if (grade.startsWith('C')) return const Color(0xFFFFB74D);
    if (grade.startsWith('D')) return const Color(0xFFFF8A65);
    return const Color(0xFFE57373);
  }

  Widget _buildSummaryReport() {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('summaryReport')
              .where('uid', isEqualTo: widget.uid)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        return snapshot.data!.docs.isEmpty
            ? Center(
              child: InkWell(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await generateStudentReport(widget.classroom, widget.uid);
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child:
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Text(
                            'Create summary report',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            )
            : _buildContainer(
              "Summary Report",
              snapshot.data!.docs[0]["totalMarks"],
              snapshot.data!.docs[0]["percentage"],
              snapshot.data!.docs[0]["grade"],
              snapshot.data!.docs[0]["result"],
              snapshot.data!.docs[0]["remark"],
            );
      },
    );
  }
}
