import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';


class Course {
  final String code;
  final String name;
  final String roomNumber;
  final String teacherName;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String meetLink;
  final bool hasMissingAssignment;

  Course({
    required this.code,
    required this.name,
    required this.roomNumber,
    required this.teacherName,
    required this.startTime,
    required this.endTime,
    required this.meetLink,
    this.hasMissingAssignment = false,
  });
}

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  int _selectedIndex = 1; // Schedule tab selected by default
  DateTime selectedDate = DateTime.now();
  
  final List<Course> todayCourses = [
    Course(
      code: 'MGT 101',
      name: 'Organization Management',
      roomNumber: '101',
      teacherName: 'Prof. Johnson',
      startTime: const TimeOfDay(hour: 9, minute: 10),
      endTime: const TimeOfDay(hour: 10, minute: 0),
      meetLink: 'https://meet.google.com/abc-defg-hij',
      hasMissingAssignment: true,
    ),
    Course(
      code: 'EC 203',
      name: 'Principles Macroeconomics',
      roomNumber: '213',
      teacherName: 'Dr. Smith',
      startTime: const TimeOfDay(hour: 9, minute: 10),
      endTime: const TimeOfDay(hour: 10, minute: 0),
      meetLink: 'https://meet.google.com/klm-nopq-rst',
      hasMissingAssignment: true,
    ),
    Course(
      code: 'EC 202',
      name: 'Principles Microeconomics',
      roomNumber: '302',
      teacherName: 'Dr. Patel',
      startTime: const TimeOfDay(hour: 10, minute: 10),
      endTime: const TimeOfDay(hour: 11, minute: 0),
      meetLink: 'https://meet.google.com/uvw-xyz-123',
    ),
    Course(
      code: 'FN 215',
      name: 'Financial Management',
      roomNumber: '111',
      teacherName: 'Prof. Garcia',
      startTime: const TimeOfDay(hour: 11, minute: 10),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      meetLink: 'https://meet.google.com/456-789-abc',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildDateHeader(),
            _buildWeekdaySelector(),
            Expanded(
              child: _buildCourseList(),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          DateFormat('MMMM d\'th\', yyyy').format(selectedDate),
          style: const TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildWeekdaySelector() {
    final DateTime monday = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Monday to Friday
        itemBuilder: (context, index) {
          final currentDate = monday.add(Duration(days: index));
          final isSelected = currentDate.day == selectedDate.day;
          final hasAssignments = [1, 2, 4].contains(index) ? index + 1 : 0; // Mock data for assignments
          
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = currentDate;
              });
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 12.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[200] : Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('d').format(currentDate),
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  Text(
                    DateFormat('E').format(currentDate),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                  if (hasAssignments > 0)
                    Container(
                      margin: const EdgeInsets.only(top: 4.0),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          hasAssignments.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: todayCourses.length,
      itemBuilder: (context, index) {
        final course = todayCourses[index];
        final now = TimeOfDay.now();
        final isCurrentClass = index == 0; // Just for demonstration
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: GestureDetector(
            onTap: () => _showMeetDialog(course),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      child: isCurrentClass
                          ? const Icon(Icons.play_arrow, color: Colors.red)
                          : const Text(''),
                    ),
                    Container(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_formatTimeOfDay(course.startTime)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_formatTimeOfDay(course.endTime)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${course.code} - ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getCourseColor(course.code),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  course.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _getCourseColor(course.code),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Room ${course.roomNumber}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (course.hasMissingAssignment)
                                Row(
                                  children: [
                                    SizedBox(width: 8),
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '1',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Missing assignment',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Today',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Assignments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Color _getCourseColor(String courseCode) {
    if (courseCode.startsWith('MGT')) {
      return Colors.orange;
    } else if (courseCode.startsWith('EC')) {
      return Colors.teal;
    } else if (courseCode.startsWith('FN')) {
      return Colors.blue;
    }
    return Colors.black;
  }

  void _showMeetDialog(Course course) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Join ${course.code}'),
          content: Text('Would you like to join the Google Meet session for ${course.name} with ${course.teacherName}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _launchGoogleMeet(course.meetLink);
              },
              child: const Text('Join Meet Now'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchGoogleMeet(String meetLink) async {
    if (await canLaunch(meetLink)) {
      await launch(meetLink);
    } else {
      // Handle error - unable to launch the URL
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Could not launch Google Meet. Please check your connection.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}