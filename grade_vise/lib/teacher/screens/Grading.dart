import 'package:flutter/material.dart';

class Grading extends StatefulWidget {
  const Grading({Key? key}) : super(key: key);

  @override
  _GradingState createState() => _GradingState();
}

class _GradingState extends State<Grading> {
  // Search controller to enable filtering
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredStudents = [];
  List<Map<String, String>> _students = [
    {"name": "Abhishek Sangule", "points": "120"},
    {"name": "Chandan Bhirud", "points": "80"},
    {"name": "Sanika Chavan", "points": "210"},
    {"name": "Sakshi", "points": "110"},
    {"name": "Kshitija Magar", "points": "40"},
    {"name": "Shri Krishna", "points": "130"},
    {"name": "Ram", "points": "120"},
  ];

  @override
  void initState() {
    super.initState();
    // Sort students by points in descending order initially
    _students.sort(
      (a, b) => int.parse(b['points']!).compareTo(int.parse(a['points']!)),
    );
    _filteredStudents = List.from(_students);

    // Add listener for search functionality
    _searchController.addListener(_filterStudents);
  }

  void _filterStudents() {
    setState(() {
      _filteredStudents =
          _students.where((student) {
            final nameLower = student['name']!.toLowerCase();
            final searchLower = _searchController.text.toLowerCase();
            return nameLower.contains(searchLower);
          }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2E),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildStatsGrid(),
                  const SizedBox(height: 20),
                  _buildStudentListHeader(),
                ],
              ),
            ),
            // Expanded widget to make student list scrollable and visible
            Expanded(child: _buildStudentList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        const Text(
          "Grade",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search students",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatsCard(
          icon: Icons.person,
          value: _students.length.toString(),
          label: "Total Students",
          iconColor: Colors.blue,
        ),
        _buildStatsCard(
          icon: Icons.star,
          value: "4.5",
          label: "Average Grade",
          iconColor: Colors.orange,
        ),
        _buildStatsCard(
          icon: Icons.check_circle,
          value: "95%",
          label: "Attendance",
          iconColor: Colors.green,
        ),
        _buildStatsCard(
          icon: Icons.school,
          value: "10",
          label: "Classes",
          iconColor: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatsCard({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [iconColor.withOpacity(0.2), Colors.white.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Student List (${_filteredStudents.length})",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () {
            // TODO: Implement filtering functionality
          },
        ),
      ],
    );
  }

  Widget _buildStudentList() {
    return _filteredStudents.isEmpty
        ? Center(
          child: Text(
            'No students found',
            style: TextStyle(color: Colors.white54),
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _filteredStudents.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final student = _filteredStudents[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
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
                  student["name"]!,
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
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    student["points"]!,
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
        );
  }
}
