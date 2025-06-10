import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadModelSheet extends StatefulWidget {
    final String classroomId;

  const UploadModelSheet({super.key, required this.classroomId});
  @override
  _UploadModelSheetState createState() => _UploadModelSheetState();
}

class _UploadModelSheetState extends State<UploadModelSheet> {
  File? _pdfFile;

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
      });
    }
  }

Future<void> _uploadPDF(String assignmentId) async {
  if (_pdfFile == null) return;

  try {
    String fileName = basename(_pdfFile!.path);
    Reference ref = FirebaseStorage.instance.ref().child("assignments/$assignmentId/$fileName");

    UploadTask uploadTask = ref.putFile(_pdfFile!);
    await uploadTask.whenComplete(() async {
      String downloadURL = await ref.getDownloadURL();

      // Store Model Answer URL inside Firestore under the respective assignment
      await FirebaseFirestore.instance.collection("assignments").doc(assignmentId).update({
        "modelSheetURL": downloadURL,
      });

      ScaffoldMessenger.of(context as BuildContext).showSnackBar(SnackBar(
        content: Text("Uploaded Successfully!"),
        backgroundColor: Colors.green,
      ));
    });
  } catch (e) {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(SnackBar(
      content: Text("Upload Failed: $e"),
      backgroundColor: Colors.red,
    ));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Model Sheet")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pdfFile != null
                ? Text("Selected File: ${basename(_pdfFile!.path)}")
                : Text("No file selected"),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickPDF,
              icon: Icon(Icons.file_upload),
              label: Text("Select PDF"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _uploadPDF("assignmentId"), // Replace "assignmentId" with the actual ID
              icon: Icon(Icons.cloud_upload),
              label: Text("Upload PDF"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
