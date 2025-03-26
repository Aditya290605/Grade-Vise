import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grade_vise/student/feedback/feed_submission.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.black),
        title: Text('FeedBack', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: null,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              radius: 15,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Illustration and Interactive Elements
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Dotted circular background
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue.shade100, style: BorderStyle.none),
                  ),
                  child: CustomPaint(
                    painter: DottedCirclePainter(),
                  ),
                ),

                // Illustration People
                Positioned(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Woman Character
                      Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Image.network(
      'https://via.placeholder.com/50x75?text=Woman',
      width: 50,
      height: 75,
      errorBuilder: (context, error, stackTrace) {
        return Text('Image failed to load');
      },
    ),
  ],
),
SizedBox(width: 20),
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Image.network(
      'https://via.placeholder.com/50x75?text=Man',
      width: 50,
      height: 75,
      errorBuilder: (context, error, stackTrace) {
        return Text('Image failed to load');
      },
    ),
  ],
),
                    ],
                  ),
                ),

                // Speech Bubbles and Emojis
                _buildSpeechBubbles(),
              ],
            ),
          ),

          // Feedback/Doubt Button
                   // Feedback/Doubt Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedbackSubmissionPage(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'FeedBack/Dought',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.add, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
      //     BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: ''),
      //     BottomNavigationBarItem(icon: Icon(Icons.videocam), label: ''),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      //   ],
      // ),
    );
  }

  Widget _buildSpeechBubbles() {
    return Stack(
      children: [
        // Blue Speech Bubble
        Positioned(
          top: 100,
          left: 50,
          child: Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        
        // Red Speech Bubble
        Positioned(
          top: 100,
          right: 50,
          child: Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        // Emoji Placements
        Positioned(
          top: 50,
          left: 100,
          child: Icon(Icons.emoji_emotions_outlined, color: Colors.yellow),
        ),
        Positioned(
          top: 50,
          right: 100,
          child: Icon(Icons.emoji_emotions_outlined, color: Colors.yellow),
        ),
      ],
    );
  }
}

class DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue.shade100
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    for (double angle = 0; angle < 360; angle += 10) {
      final Offset point = Offset(
        center.dx + radius * cos(angle * 3.14 / 180),
        center.dy + radius * sin(angle * 3.14 / 180),
      );
      canvas.drawCircle(point, 2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}