import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grade_vise/teacher/Submissions/ai_methods.dart';
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
                              spots: [
                                FlSpot(
                                  0,
                                  percentage * 0.5,
                                ), // Scale dynamically
                                FlSpot(1, percentage * 0.6),
                                FlSpot(2, percentage * 0.7),
                                FlSpot(3, percentage * 0.8),
                                FlSpot(4, percentage), // Final percentage
                              ],
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
                                  const Color(0xFF4A80F0).withOpacity(0.8),
                                  const Color(0xFF4A80F0).withOpacity(0.4),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4A80F0,
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
                            style: const TextStyle(
                              color: Color(0xFF4A80F0),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text('Total Marks: $totalMark'),
          Text('Overall Percentage: $percentage%'),
          Text('Grade: $grade'),
          Text('Result: $result'),
          SizedBox(height: 8),
          Text('Remarks:'),
          Text(remark),
        ],
      ),
    );
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
