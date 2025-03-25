import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:grade_vise/utils/fonts.dart';

class PostContainerWidget extends StatelessWidget {
  final String userName;
  final String date;
  final String uploadTime;
  final String message;
  final String linkText;
  final IconData linkIcon;
  final String image;
  final String docId;

  const PostContainerWidget({
    super.key,
    required this.userName,
    required this.date,
    required this.uploadTime,
    required this.message,
    required this.linkText,
    required this.image,
    required this.linkIcon,
    required this.docId,
  });

  void _showPopupMenu(BuildContext context, Offset position) async {
    final result = await showMenu<String>(
      color: Colors.black,
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'delete',
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            width: 180, // Adjust width
            child: Row(
              children: [
                const Icon(Icons.delete, color: Colors.red),
                const SizedBox(width: 15),
                const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    if (result == 'delete') {
      FirebaseFirestore.instance
          .collection('announcements')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Item deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(image),
                    backgroundColor: Colors.grey.shade200,
                    radius: 25,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontFamily: dmSans,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            date,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontFamily: dmSans,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('•', style: TextStyle(color: Colors.black54)),
                          const SizedBox(width: 8),
                          Text(
                            uploadTime,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontFamily: dmSans,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    _showPopupMenu(context, details.globalPosition);
                  },
                  child: Icon(Icons.more_vert, color: Colors.black54),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontFamily: dmSans,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.8,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(linkIcon, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    linkText,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: dmSans,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
