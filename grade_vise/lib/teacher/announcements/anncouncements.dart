import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:grade_vise/services/firestore_methods.dart';
import 'package:grade_vise/utils/show_error.dart';

class AnnouncementDialog extends StatefulWidget {
  final String uid;
  final String classroomId;
  final String name;
  final String profilePic;

  const AnnouncementDialog({
    super.key,
    required this.classroomId,
    required this.name,
    required this.profilePic,
    required this.uid,
  });

  @override
  AnnouncementDialogState createState() => AnnouncementDialogState();
}

class AnnouncementDialogState extends State<AnnouncementDialog> {
  TextEditingController messageController = TextEditingController();
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx', 'ppt', 'pptx'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void _uploadAnnouncement() async {
    if (messageController.text.isEmpty && _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a message or select a file.')),
      );
      return;
    }
    try {
      String res = await FirestoreMethods().createAnncouncement(
        widget.uid,
        widget.classroomId,
        messageController.text,
        widget.name,
        widget.profilePic,
      );

      if (res == 'success') {
        showSnakbar(context, 'announcement done');
      }
    } catch (e) {
      showSnakbar(context, e.toString());
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create Announcement',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Announce something to your class',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _selectedFile != null
                ? _selectedFile!.extension == 'jpg' ||
                        _selectedFile!.extension == 'png'
                    ? Image.file(File(_selectedFile!.path!), height: 150)
                    : Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedFile!.name,
                            style: TextStyle(fontSize: 14),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed:
                                () => setState(() => _selectedFile = null),
                          ),
                        ],
                      ),
                    )
                : OutlinedButton.icon(
                  onPressed: _pickFile,
                  icon: Icon(Icons.attach_file),
                  label: Text('Attach File'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _uploadAnnouncement,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Upload'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
