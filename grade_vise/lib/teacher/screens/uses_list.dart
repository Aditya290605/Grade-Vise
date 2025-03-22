import 'package:flutter/material.dart';
import 'package:grade_vise/utils/colors.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  // Static data for now, later will come from Firebase
  final List<Map<String, dynamic>> studentList = [
    {'name': 'Aditya Magar', 'isSelected': true},
    {'name': 'Chandan Bhirud', 'isSelected': true},
    {'name': 'Sakshi', 'isSelected': false},
    {'name': 'Kshitija Magar', 'isSelected': true},
    {'name': 'yeole tea', 'isSelected': false},
  ];

  // Track which filter option is selected
  String selectedFilter = 'ALL';

  // Show filter popup
  void _showFilterPopup(BuildContext context, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + 40, // Offset down a bit to appear below the button
        position.dx + 100,
        position.dy + 40,
      ),
      items: [
        PopupMenuItem(
          value: 'ALL',
          child: Row(
            children: [
              Text(
                'ALL',
                style: TextStyle(
                  fontWeight:
                      selectedFilter == 'ALL'
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: '50%',
          child: Row(
            children: [
              Text(
                '50%',
                style: TextStyle(
                  fontWeight:
                      selectedFilter == '50%'
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Manual',
          child: Row(
            children: [
              Text(
                'Manual',
                style: TextStyle(
                  fontWeight:
                      selectedFilter == 'Manual'
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedFilter = value;

          // Apply filter logic based on selection
          if (value == 'ALL') {
            // Select all students
            for (var student in studentList) {
              student['isSelected'] = true;
            }
          } else if (value == '50%') {
            // Select approximately 50% of students
            int halfCount = (studentList.length / 2).round();
            for (int i = 0; i < studentList.length; i++) {
              studentList[i]['isSelected'] = i < halfCount;
            }
          } else if (value == 'Manual') {
            // Keep current selection for manual mode
          }
        });
      }
    });
  }

  // Toggle student selection
  void _toggleStudentSelection(int index) {
    setState(() {
      studentList[index]['isSelected'] = !studentList[index]['isSelected'];
    });
  }

  // Count selected students
  int get selectedStudentCount =>
      studentList.where((student) => student['isSelected'] == true).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor, // Dark navy background
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
            ),

            const SizedBox(height: 30),

            // Teacher Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Teacher',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const Icon(
                    Icons.person_add_alt,
                    color: Color(0xFF2D3142),
                    size: 22,
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: Colors.grey[700],
              margin: const EdgeInsets.only(top: 10),
            ),

            // Teacher List Item
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 16.0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD3D3D3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Abhishek Sangule',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Student Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Student',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${studentList.length} Student',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF2D3142),
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: Colors.grey[700],
              margin: const EdgeInsets.only(top: 10),
            ),

            const SizedBox(height: 12),

            // Filter Button with Selection Indicator
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _showFilterPopup(context, details.globalPosition);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D3142),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.filter_list,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Filter ($selectedFilter)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Selection Info Text
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Selected: $selectedStudentCount / ${studentList.length} students',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),

            // Student List
            Expanded(
              child: ListView.builder(
                itemCount: studentList.length,
                itemBuilder: (context, index) {
                  // Calculate different background colors for alternating items
                  Color backgroundColor;
                  if (index % 2 == 0) {
                    backgroundColor = const Color(0xFF3A4553); // Lighter gray
                  } else {
                    backgroundColor = const Color(0xFF1E2530); // Dark navy
                  }

                  return InkWell(
                    onTap: () => _toggleStudentSelection(index),
                    child: Container(
                      decoration: BoxDecoration(color: backgroundColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color:
                                    studentList[index]['isSelected']
                                        ? const Color(
                                          0xFF486C7F,
                                        ) // Bluish for selected
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    studentList[index]['isSelected']
                                        ? null
                                        : Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                              ),
                              child:
                                  studentList[index]['isSelected']
                                      ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                      : null,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              studentList[index]['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
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
          ],
        ),
      ),
    );
  }
}
