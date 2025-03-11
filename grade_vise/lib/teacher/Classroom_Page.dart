import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassroomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2432), // Dark theme background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2432),
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.white),
        actions: [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 10),
          CircleAvatar(backgroundColor: Colors.grey.shade400, radius: 18),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCourseCard(),
              SizedBox(height: 20),
              _buildFeatureIcons(),
              SizedBox(height: 20),
              _buildAnnouncementBox(),
              SizedBox(height: 20),
              _buildPostCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCourseCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFC8B6FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Graphic Fundamentals -",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            "ART101",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _featureIcon(Icons.edit, "Assignments"),
        _featureIcon(Icons.feedback, "Feedback"),
        _featureIcon(Icons.calendar_today, "TimeTable"),
        _featureIcon(Icons.bar_chart, "Submissions"),
      ],
    );
  }

  Widget _featureIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue, size: 30),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAnnouncementBox() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Announce something to your class",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          Icon(Icons.wifi_tethering, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildPostCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.grey.shade400, radius: 20),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Akshay",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Yesterday",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.more_vert, color: Colors.white),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "Explore your interests and meet like-minded students by joining one of our many clubs. Whether you're into sports, arts, or academics, there's a club for you. Find your community!",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
          ),
          SizedBox(height: 10),
          _buildLinkBox(),
        ],
      ),
    );
  }

  Widget _buildLinkBox() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.link, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Assignment for Graphic A1 Lesson",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF1E2432),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.home, color: Colors.white, size: 30),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white12,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.trending_up, color: Colors.white, size: 30),
          ),
          Icon(Icons.video_call, color: Colors.white, size: 30),
          Icon(Icons.person, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}
