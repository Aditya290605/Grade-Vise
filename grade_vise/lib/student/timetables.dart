import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _selectedDate = DateTime.now();
  late List<DateTime> _weekDays;
  
  // Course colors
  final Map<String, Color> _courseColors = {
    'Org Mgt': const Color(0xFFFFCC80),
    'Financial Mgt': const Color(0xFF81A1F7),
    'Micro': const Color(0xFFE57ED8),
    'Macro': const Color(0xFF66D7C9),
  };
  
  // Sample schedule data
  late Map<String, List<ClassSession>> _scheduleData;
  
  @override
  void initState() {
    super.initState();
    _generateWeekDays();
    _initScheduleData();
  }
  
  void _generateWeekDays() {
    // Find the Monday of the current week
    DateTime monday = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    _weekDays = List.generate(5, (index) => monday.add(Duration(days: index)));
  }
  
  void _initScheduleData() {
    _scheduleData = {};
    
    for (var day in _weekDays) {
      String dayKey = DateFormat('yyyy-MM-dd').format(day);
      _scheduleData[dayKey] = [];
    }
    
    // Populate with sample data matching the image
    String mon = DateFormat('yyyy-MM-dd').format(_weekDays[0]);
    String tue = DateFormat('yyyy-MM-dd').format(_weekDays[1]);
    String wed = DateFormat('yyyy-MM-dd').format(_weekDays[2]);
    String thu = DateFormat('yyyy-MM-dd').format(_weekDays[3]);
    String fri = DateFormat('yyyy-MM-dd').format(_weekDays[4]);
    
    // Monday classes
    _scheduleData[mon]!.add(ClassSession('Org Mgt', 'Room 101', TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 10, minute: 0)));
    _scheduleData[mon]!.add(ClassSession('Macro', 'Room 101', TimeOfDay(hour: 10, minute: 0), TimeOfDay(hour: 11, minute: 0)));
    _scheduleData[mon]!.add(ClassSession('Micro', 'Room 101', TimeOfDay(hour: 11, minute: 0), TimeOfDay(hour: 12, minute: 0)));
    _scheduleData[mon]!.add(ClassSession('Financial Mgt', 'Room 101', TimeOfDay(hour: 12, minute: 0), TimeOfDay(hour: 15, minute: 0)));
    
    // Tuesday classes
    _scheduleData[tue]!.add(ClassSession('Financial Mgt', 'Room 101', TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 12, minute: 0)));
    _scheduleData[tue]!.add(ClassSession('Org Mgt', 'Room 101', TimeOfDay(hour: 11, minute: 0), TimeOfDay(hour: 12, minute: 0)));

    // Wednesday classes
    _scheduleData[wed]!.add(ClassSession('Macro', 'Room 101', TimeOfDay(hour: 10, minute: 0), TimeOfDay(hour: 11, minute: 0)));
    _scheduleData[wed]!.add(ClassSession('Micro', 'Room 101', TimeOfDay(hour: 11, minute: 0), TimeOfDay(hour: 13, minute: 0)));

    // Thursday classes
    _scheduleData[thu]!.add(ClassSession('Org Mgt', 'Room 101', TimeOfDay(hour: 10, minute: 0), TimeOfDay(hour: 11, minute: 0)));
    _scheduleData[thu]!.add(ClassSession('Micro', 'Room 101', TimeOfDay(hour: 11, minute: 0), TimeOfDay(hour: 12, minute: 0)));

    // Friday classes
    _scheduleData[fri]!.add(ClassSession('Micro', 'Room 101', TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 10, minute: 0)));
    _scheduleData[fri]!.add(ClassSession('Org Mgt', 'Room 101', TimeOfDay(hour: 10, minute: 0), TimeOfDay(hour: 11, minute: 0)));
    _scheduleData[fri]!.add(ClassSession('Macro', 'Room 101', TimeOfDay(hour: 11, minute: 0), TimeOfDay(hour: 14, minute: 0)));
  }
  
  void _addOrEditClass(String dayKey, ClassSession? existingSession) async {
    // Pre-fill values if editing an existing session
    String courseName = existingSession?.courseName ?? '';
    String roomNumber = existingSession?.roomNumber ?? 'Room 101';
    TimeOfDay startTime = existingSession?.startTime ?? TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = existingSession?.endTime ?? TimeOfDay(hour: 10, minute: 0);
    
    final result = await showDialog<ClassSession>(
      context: context,
      builder: (context) => ClassEditDialog(
        initialCourseName: courseName,
        initialRoomNumber: roomNumber,
        initialStartTime: startTime,
        initialEndTime: endTime,
        availableCourses: _courseColors.keys.toList(),
      ),
    );
    
    if (result != null) {
      setState(() {
        if (existingSession != null) {
          // Editing existing class
          int index = _scheduleData[dayKey]!.indexOf(existingSession);
          _scheduleData[dayKey]![index] = result;
        } else {
          // Adding new class
          _scheduleData[dayKey]!.add(result);
        }
      });
    }
  }
  
  void _deleteClass(String dayKey, ClassSession session) {
    setState(() {
      _scheduleData[dayKey]!.remove(session);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Schedule',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            _buildWeekDayPicker(),
            Expanded(
              child: _buildTimeTable(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add a new class to the selected day
          String selectedDayKey = DateFormat('yyyy-MM-dd').format(
            _weekDays[_weekDays.indexWhere((day) => 
              day.day == _selectedDate.day && 
              day.month == _selectedDate.month &&
              day.year == _selectedDate.year
            )]
          );
          _addOrEditClass(selectedDayKey, null);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
  
  Widget _buildWeekDayPicker() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _weekDays.length,
        itemBuilder: (context, index) {
          final day = _weekDays[index];
          final isSelected = day.day == _selectedDate.day && 
                             day.month == _selectedDate.month &&
                             day.year == _selectedDate.year;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = day;
              });
            },
            child: Container(
              width: 80,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.grey.shade200 : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.day.toString(),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    DateFormat('EEE').format(day),
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.black : Colors.grey,
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
  
  Widget _buildTimeTable() {
    final hourLabels = [
      TimeOfDay(hour: 9, minute: 0),
      TimeOfDay(hour: 10, minute: 0),
      TimeOfDay(hour: 11, minute: 0),
      TimeOfDay(hour: 12, minute: 0),
      TimeOfDay(hour: 13, minute: 0),
      TimeOfDay(hour: 14, minute: 0),
    ];
    
    // Get the schedule for the selected day
    String selectedDayKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
    List<ClassSession> daySchedule = _scheduleData[selectedDayKey] ?? [];
    
    return Row(
      children: [
        // Time labels column
        Container(
          width: 60,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: Column(
            children: hourLabels.map((time) {
              String suffix = time.hour >= 12 ? "PM" : "AM";
              int displayHour = time.hour > 12 ? time.hour - 12 : time.hour;
              
              return Container(
                height: 100,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$displayHour',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      suffix,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        
        // Schedule content
        Expanded(
          child: Stack(
            children: [
              // Time grid lines
              Column(
                children: hourLabels.map((time) {
                  return Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              // Class sessions
              ...daySchedule.map((session) {
                // Calculate position and height
                int startTotalMinutes = session.startTime.hour * 60 + session.startTime.minute;
                int endTotalMinutes = session.endTime.hour * 60 + session.endTime.minute;
                
                // Assuming the timetable starts at 9:00 AM (540 minutes from midnight)
                double top = (startTotalMinutes - 540) / 60 * 100;
                double height = (endTotalMinutes - startTotalMinutes) / 60 * 100;
                
                return Positioned(
                  top: top,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _addOrEditClass(selectedDayKey, session),
                    onLongPress: () => _deleteClass(selectedDayKey, session),
                    child: Container(
                      height: height,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _courseColors[session.courseName] ?? Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.courseName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            session.roomNumber,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}

// Data class for a class session
class ClassSession {
  final String courseName;
  final String roomNumber;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  
  ClassSession(this.courseName, this.roomNumber, this.startTime, this.endTime);
}

// Dialog for adding or editing a class
class ClassEditDialog extends StatefulWidget {
  final String initialCourseName;
  final String initialRoomNumber;
  final TimeOfDay initialStartTime;
  final TimeOfDay initialEndTime;
  final List<String> availableCourses;
  
  const ClassEditDialog({
    Key? key,
    required this.initialCourseName,
    required this.initialRoomNumber,
    required this.initialStartTime,
    required this.initialEndTime,
    required this.availableCourses,
  }) : super(key: key);

  @override
  State<ClassEditDialog> createState() => _ClassEditDialogState();
}

class _ClassEditDialogState extends State<ClassEditDialog> {
  late String _courseName;
  late String _roomNumber;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  
  @override
  void initState() {
    super.initState();
    _courseName = widget.initialCourseName;
    _roomNumber = widget.initialRoomNumber;
    _startTime = widget.initialStartTime;
    _endTime = widget.initialEndTime;
  }
  
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          // Ensure end time is after start time
          if (_endTime.hour < _startTime.hour || 
              (_endTime.hour == _startTime.hour && _endTime.minute < _startTime.minute)) {
            _endTime = TimeOfDay(
              hour: _startTime.hour + 1,
              minute: _startTime.minute,
            );
          }
        } else {
          _endTime = picked;
        }
      });
    }
  }
  
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_courseName.isEmpty ? 'Add Class' : 'Edit Class'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Course',
                border: OutlineInputBorder(),
              ),
              value: _courseName.isEmpty ? null : _courseName,
              hint: Text('Select Course'),
              items: widget.availableCourses.map((course) {
                return DropdownMenuItem<String>(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _courseName = value;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Room Number',
                border: OutlineInputBorder(),
              ),
              initialValue: _roomNumber,
              onChanged: (value) {
                setState(() {
                  _roomNumber = value;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, true),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Time',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(_formatTimeOfDay(_startTime)),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, false),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'End Time',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(_formatTimeOfDay(_endTime)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _courseName.isEmpty
              ? null
              : () {
                  Navigator.pop(
                    context,
                    ClassSession(_courseName, _roomNumber, _startTime, _endTime),
                  );
                },
          child: Text('Save'),
        ),
      ],
    );
  }
}

// Usage example: Add this to navigation onTap or button press
void navigateToSchedule(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => SchedulePage(),
    ),
  );
}