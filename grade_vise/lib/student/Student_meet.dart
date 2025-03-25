import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grade_vise/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'dart:io';

class Student_Meet extends StatefulWidget {
  const Student_Meet({super.key});

  @override
  State<Student_Meet> createState() => _MeetState();
}

class _MeetState extends State<Student_Meet> {
  final TextEditingController _meetLinkController = TextEditingController();

  // Function to open Google Meet for a new meeting
  Future<void> _createNewMeet() async {
    final Uri newMeetUri = Uri.parse("https://meet.google.com/new");

    if (!await launchUrl(newMeetUri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cannot open Google Meet")));
    }
  }

  // Function to save and notify all students about a Meet link
  Future<void> _notifyAll() async {
    String meetUrl = _meetLinkController.text.trim();

    if (meetUrl.isEmpty || !meetUrl.startsWith("https://meet.google.com/")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid Google Meet link")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('meet_links').add({
        'meetLink': meetUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _meetLinkController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Meet link sent to all students!")),
      );
    } catch (e) {
      print("Error saving Meet link: $e");
    }
  }

  // Function to schedule a meeting using Google Calendar
  Future<void> _scheduleMeeting() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.intent.action.INSERT',
        package: 'com.google.android.calendar',
        type: "vnd.android.cursor.item/event",
        arguments: {
          'title': 'Google Meet',
          'description': 'Join the meeting',
          'eventLocation': 'https://meet.google.com/new',
          'beginTime': DateTime.now().millisecondsSinceEpoch,
          'endTime':
              DateTime.now()
                  .add(const Duration(hours: 1))
                  .millisecondsSinceEpoch,
        },
      );

      try {
        await intent.launch();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cannot open Google Calendar")),
        );
      }
    } else {
      final Uri calendarUri = Uri.parse(
        "https://calendar.google.com/calendar/u/0/r/eventedit?text=Google+Meet&details=Join+the+meeting&location=https://meet.google.com/new",
      );

      if (!await launchUrl(calendarUri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cannot open Google Calendar")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define theme colors
    final backgroundColor = bgColor;
    const meetBlue = Color(0xFF4285F4);
    const meetGreen = Color(0xFF34A853);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card with description
            Card(
              elevation: 2,
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Google Meet Management",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Join Meet with Teacher.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(221, 163, 163, 163),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons side by side
            const SizedBox(height: 20),

            // Notification input
            const SizedBox(height: 20),

            // Past meetings header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                "Recent Meeting Links",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(221, 255, 255, 255),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Meeting list
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('meet_links')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_call_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No meeting links available yet",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  final meetLinks = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: meetLinks.length,
                    itemBuilder: (context, index) {
                      final data =
                          meetLinks[index].data() as Map<String, dynamic>;

                      if (!data.containsKey('meetLink') ||
                          data['meetLink'] == null) {
                        return const SizedBox.shrink();
                      }

                      final String meetUrl = data['meetLink'];
                      final Uri meetUri = Uri.parse(meetUrl);

                      // Format timestamp if available
                      String timeInfo = "Shared recently";
                      if (data.containsKey('timestamp') &&
                          data['timestamp'] != null) {
                        final timestamp = data['timestamp'] as Timestamp;
                        final date = timestamp.toDate();
                        timeInfo =
                            "${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 2,
                        ),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF293241),
                            child: Icon(Icons.video_call, color: Colors.white),
                          ),
                          title: Text(
                            meetUrl,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            timeInfo,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.copy,
                                  color: Colors.grey,
                                ),
                                tooltip: "Copy link",
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: meetUrl),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Link copied!"),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.open_in_new,
                                  color: Color(0xFF293241),
                                ),
                                tooltip: "Open meeting",
                                onPressed: () async {
                                  if (!await launchUrl(
                                    meetUri,
                                    mode: LaunchMode.externalApplication,
                                  )) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Cannot open link"),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
