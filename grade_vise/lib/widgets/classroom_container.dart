import 'package:flutter/material.dart';
import 'package:grade_vise/utils/fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ClassroomContainer extends StatelessWidget {
  final String classroomName;
  final String section;
  final String subject;
  final String room;
  final Color color;

  const ClassroomContainer({
    super.key,
    required this.classroomName,
    required this.room,
    required this.section,
    required this.subject,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(1.0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.school, color: Colors.black, size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    classroomName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: sourceSans,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InfoRow(icon: LucideIcons.users, label: "Section", value: section),
            InfoRow(icon: LucideIcons.book, label: "Subject", value: subject),
            InfoRow(icon: LucideIcons.doorOpen, label: "Room", value: room),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 22),
          SizedBox(width: 10),
          Text(
            "$label: ",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: sourceSans,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: sourceSans,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
