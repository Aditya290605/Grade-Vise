import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grade_vise/teacher/submissions/ai_methods.dart';

class MyGrades extends StatefulWidget {
  final String name;
  final String email;
  final String classroomId;
  final String uid;
  const MyGrades({
    super.key,
    required this.name,
    required this.email,
    required this.classroomId,
    required this.uid,
  });

  @override
  State<MyGrades> createState() => _MyGradesState();
}

class _MyGradesState extends State<MyGrades>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  var snap;

  @override
  void initState() {
    super.initState();
    getSnap();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> getSnap() async {
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2432),
      body: SafeArea(
        // Added SafeArea to prevent overflow with system UI
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // Add parallax or fade effects on scroll if desired
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar with Animation

                      // User Profile Info with overflow prevention
                      Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF4A80F0),
                                      const Color(0xFF4A80F0).withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.school,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                // Added Expanded to prevent text overflow
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow:
                                          TextOverflow
                                              .ellipsis, // Added text overflow handling
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.email_outlined,
                                          color: Colors.grey,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          // Added Expanded to prevent email overflow
                                          child: Text(
                                            widget.email,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                            overflow:
                                                TextOverflow
                                                    .ellipsis, // Added text overflow handling
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 400.ms)
                          .slideX(begin: -0.2, end: 0),

                      // Divider with reduced margins
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const Divider(
                          color: Color(0xFF3A4456),
                          height: 1,
                        ),
                      ),

                      // Quick Stats with SingleChildScrollView for horizontal overflow handling
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: SingleChildScrollView(
                          // Added horizontal scroll capability
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildStatCard(
                                title: 'Overall Grade',
                                value: snap?['grade'] ?? "",
                                icon: Icons.grade,
                                backgroundColor: const Color(0xFF4A80F0),
                                delay: 500,
                              ),
                              const SizedBox(width: 8),
                              _buildStatCard(
                                title: 'Percentage',
                                value: '${snap?['percentage'] ?? ''}%',
                                icon: Icons.percent,
                                backgroundColor: const Color(0xFFFFA113),
                                delay: 600,
                              ),
                              const SizedBox(width: 8),
                              _buildStatCard(
                                title: 'Completed',
                                value: '',
                                icon: Icons.task_alt,
                                backgroundColor: const Color(0xFF1FE56E),
                                delay: 700,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Tab Bar - adjusted spacing
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C3441),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xFF4A80F0),
                          ),
                          indicatorSize:
                              TabBarIndicatorSize
                                  .tab, // Adjusted to increase width
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          tabs: const [
                            Tab(text: 'Progress'),
                            Tab(text: 'Assignments'),
                          ],
                          onTap: (index) {
                            // Handle tab change if needed
                          },
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 800.ms),
                      // Tab View with reduced height to prevent overflow
                      SizedBox(
                        height: 400, // Reduced from 420 to prevent overflow
                        child: TabBarView(
                          controller: _tabController,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            // Progress Tab
                            _buildProgressTab(
                              snap?['percentage'] ?? 0.0,
                              snap?['grade'] ?? '',
                              snap?['totalMarks'] ?? 0,
                            ),

                            // Assignments Tab with SingleChildScrollView for handling content overflow
                            SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: _buildAssignmentsTab(),
                            ),
                          ],
                        ),
                      ),

                      // Summary Report Section
                      const SizedBox(height: 16),
                      _buildSectionHeader(
                        title: 'Summary Report',
                        icon: Icons.summarize,
                      ).animate().fadeIn(duration: 600.ms, delay: 900.ms),
                      const SizedBox(height: 12),
                      _buildSummaryReport().animate().fadeIn(
                        duration: 600.ms,
                        delay: 1000.ms,
                      ),
                      const SizedBox(
                        height: 80,
                      ), // Added bottom padding for FAB
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Download report or take action
        },
        backgroundColor: const Color(0xFF4A80F0),
        child: const Icon(Icons.download, color: Colors.white),
      ).animate().scale(delay: 1100.ms, duration: 400.ms),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color backgroundColor,
    required int delay,
  }) {
    return Container(
          width: 110, // Added fixed width to prevent unpredictable sizing
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2C3441),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: backgroundColor, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
                overflow: TextOverflow.ellipsis, // Added text overflow handling
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: delay.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildProgressTab(double percentage, String grade, int totalMarks) {
    return Card(
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
                              color: _getColorForGrade(grade).withOpacity(0.3),
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

  Widget _buildAssignmentsTab() {
    return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFF2C3441),
          elevation: 10,
          shadowColor: Colors.black.withOpacity(0.3),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Added to prevent overflow
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF3A4456),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Assignment Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Marks',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildAssignmentItem('CNN problem number 21', '7/10', index: 0),
              _buildAssignmentItem('Deep Learning CA1', '9/10', index: 1),
              _buildAssignmentItem(
                'K-mean clustering Problem',
                '4/10',
                isHighlighted: true,
                index: 2,
              ),
              _buildAssignmentItem('Math 2 ASSIGNMENT', '10/10', index: 3),
              _buildAssignmentItem(
                'Classification Algo Assignment',
                '8/10',
                index: 4,
              ),
              _buildAssignmentItem(
                'Flutter State management Assignment',
                '9/10',
                index: 5,
              ),
            ],
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

  Widget _buildAssignmentItem(
    String name,
    String marks, {
    bool isHighlighted = false,
    required int index,
  }) {
    final Color itemColor =
        isHighlighted
            ? const Color(0xFF4A80F0).withOpacity(0.2)
            : (index % 2 == 0
                ? const Color(0xFF3A4456)
                : const Color(0xFF323B4D));

    return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          decoration: BoxDecoration(
            color: itemColor,
            borderRadius: BorderRadius.circular(12),
            border:
                isHighlighted
                    ? Border.all(
                      color: const Color(0xFF4A80F0).withOpacity(0.6),
                      width: 1.5,
                    )
                    : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            isHighlighted
                                ? const Color(0xFF4A80F0).withOpacity(0.3)
                                : const Color(0xFF2C3441),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        _getIconForAssignment(name),
                        color:
                            isHighlighted
                                ? const Color(0xFF4A80F0)
                                : Colors.grey.shade300,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          color:
                              isHighlighted
                                  ? const Color(0xFF4A80F0)
                                  : Colors.white,
                          fontSize: 16,
                          fontWeight:
                              isHighlighted ? FontWeight.bold : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getColorForMarks(marks),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  marks,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: (200 + (index * 100)).ms)
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildSectionHeader({required String title, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A4456),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4A80F0), size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
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
                  await generateStudentReport(widget.classroomId, widget.uid);
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

  IconData _getIconForAssignment(String name) {
    if (name.toLowerCase().contains('math')) {
      return Icons.calculate;
    } else if (name.toLowerCase().contains('flutter')) {
      return Icons.code;
    } else if (name.toLowerCase().contains('classification')) {
      return Icons.category;
    } else if (name.toLowerCase().contains('deep learning')) {
      return Icons.memory;
    } else {
      return Icons.assignment;
    }
  }

  Color _getColorForMarks(String marks) {
    final score = int.tryParse(marks.split('/').first) ?? 0;
    if (score >= 9) {
      return const Color(0xFF1FE56E); // Green for high marks
    } else if (score >= 7) {
      return const Color(0xFFFFA113); // Yellow for medium marks
    } else {
      return const Color(0xFFFF4A4A); // Red for low marks
    }
  }
}
