import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1F26),
        title: const Text("About", style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListItem("App Info"),
          _buildListItem("Privacy Policy"),
          _buildListItem("Terms of Use"),
          _buildListItem("Open-Source Libraries"),
        ],
      ),
    );
  }

  Widget _buildListItem(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Navigate to respective pages
          },
        ),
        Divider(color: Colors.grey.shade800, height: 1),
      ],
    );
  }
}
