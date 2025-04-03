import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MyGrades extends StatefulWidget {
  const MyGrades({Key? key}) : super(key: key);

  @override
  State<MyGrades> createState() => _MyGradesState();
}

class _MyGradesState extends State<MyGrades>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSearchExpanded = !_isSearchExpanded;
                          });
                        },
                        child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              height: 50,
                              width:
                                  _isSearchExpanded
                                      ? MediaQuery.of(context).size.width - 32
                                      : 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C3441),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: Color(0xFF4A80F0),
                                  ),
                                  if (_isSearchExpanded) ...[
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          hintText:
                                              'Search assignments or courses',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        cursorColor: const Color(0xFF4A80F0),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF3A4456),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.notifications_outlined,
                                        color: Color(0xFF4A80F0),
                                      ),
                                    ).animate().fadeIn(delay: 200.ms),
                                  ],
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 300.ms)
                            .slideY(begin: -0.5, end: 0),
                      ),

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
                                    const Text(
                                      'Abhishek Sangule',
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
                                          child: const Text(
                                            'abhisheksangule6@gmail.com',
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
                                value: 'A',
                                icon: Icons.grade,
                                backgroundColor: const Color(0xFF4A80F0),
                                delay: 500,
                              ),
                              const SizedBox(width: 8),
                              _buildStatCard(
                                title: 'Percentage',
                                value: '81.5%',
                                icon: Icons.percent,
                                backgroundColor: const Color(0xFFFFA113),
                                delay: 600,
                              ),
                              const SizedBox(width: 8),
                              _buildStatCard(
                                title: 'Completed',
                                value: '6/8',
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
                            _buildProgressTab(),

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

  Widget _buildProgressTab() {
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
                      child: const Row(
                        children: [
                          Icon(Icons.tune, size: 16, color: Color(0xFF4A80F0)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180, // Reduced chart height to prevent overflow
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
                                'Apr10',
                                'Apr11',
                                'Apr12',
                                'Apr13',
                                'Apr14',
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
                          spots: const [
                            FlSpot(0, 55),
                            FlSpot(0.5, 30),
                            FlSpot(1, 60),
                            FlSpot(1.5, 40),
                            FlSpot(2, 70),
                            FlSpot(2.5, 55),
                            FlSpot(3, 80),
                            FlSpot(3.5, 60),
                            FlSpot(4, 90),
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
                Center(
                  child: Container(
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
                          color: const Color(0xFF4A80F0).withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.trending_up, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          '70.5% Completion',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF2C3441),
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  // Added to prevent text overflow
                  child: Text(
                    'Student Performance',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow:
                        TextOverflow.ellipsis, // Added text overflow handling
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1FE56E).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min, // Keep as small as possible
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Color(0xFF1FE56E),
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Passed',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1FE56E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Summary items in a ScrollView to prevent overflow on smaller devices
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A4456),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      title: 'Total Marks',
                      value: '489 / 600',
                      icon: Icons.assessment,
                      color: const Color(0xFF4A80F0),
                    ),
                    const SizedBox(
                      width: 16,
                    ), // Added space between summary items
                    _buildSummaryItem(
                      title: 'Percentage',
                      value: '81.5%',
                      icon: Icons.percent,
                      color: const Color(0xFFFFA113),
                    ),
                    const SizedBox(
                      width: 16,
                    ), // Added space between summary items
                    _buildSummaryItem(
                      title: 'Grade',
                      value: 'A',
                      icon: Icons.grade,
                      color: const Color(0xFF1FE56E),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.5, end: 0),
            const SizedBox(height: 16),
            const Text(
              'Remarks:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildRemarkItem(
              'Strong performance in Mathematics and Computer Science.',
            ),
            _buildRemarkItem('Needs improvement in Social Studies.'),
            _buildRemarkItem(
              'Overall, a good academic performance with scope for better scores in weak areas.',
            ),
            const SizedBox(height: 24),
            Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Detailed report action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A80F0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                      shadowColor: const Color(0xFF4A80F0).withOpacity(0.5),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.description, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'View Detailed Report',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 800.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
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

  Widget _buildRemarkItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(fontSize: 16, color: Colors.grey)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
