import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:grade_vise/services/firestore_methods.dart';
import 'package:grade_vise/services/storage_methods.dart';

import 'dart:io';

class FeedbackSubmissionPage extends StatefulWidget {
  final String classroomId;
  final String email;
  final String userPhoto;

  // final String uid;
  const FeedbackSubmissionPage({
    super.key,
    // required this.uid,
    required this.userPhoto,
    required this.email,
    required this.classroomId,
  });

  @override
  State<FeedbackSubmissionPage> createState() => _FeedbackSubmissionPageState();
}

class _FeedbackSubmissionPageState extends State<FeedbackSubmissionPage> {
  String fileType = '';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Classroom dropdown

  FilePickerResult? _file;
  bool isLoading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _file = result;
      });
    }
  }

  void _submitFeedback(
    String fileType,
    String title,
    String des,
    FilePickerResult? file,
    classroomId,
    String email,
    String userPhoto,
  ) async {
    // Validation checks
    debugPrint('hey');

    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    // Set loading state
    if (_file == null) {
      debugPrint('contriller');
      setState(() {
        isLoading = true;
      });

      await FirestoreMethods().createFeedback(
        classroomId,
        title,
        des,
        email,
        FirebaseAuth.instance.currentUser!.uid,

        userPhoto,
        '',
        '',
      );

      setState(() {
        isLoading = false;
        Navigator.pop(context);
      });
    }

    if (_file != null) {
      setState(() {
        isLoading = true;
      });

      final String fileUrl = await StorageMethods().uploadFeedback(
        _file!,
        'feedback',
        FirebaseAuth.instance.currentUser!.uid,
      );

      await FirestoreMethods().createFeedback(
        classroomId,
        title,
        des,
        email,
        FirebaseAuth.instance.currentUser!.uid,

        userPhoto,
        fileUrl,
        fileType,
      );

      setState(() {
        isLoading = false;
        Navigator.pop(context);
      });
    }
  }

  Widget _buildFilePreview(FilePickerResult fileResult) {
    String? filePath = fileResult.files.single.path;
    String fileName = fileResult.files.single.name;
    String fileExtension = fileName.split('.').last.toLowerCase();
    fileType = fileExtension;

    if (fileExtension == 'jpg' || fileExtension == 'png') {
      return Image.file(File(filePath!), fit: BoxFit.cover);
    } else if (fileExtension == 'pdf') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.picture_as_pdf, size: 50, color: Colors.red),
          const SizedBox(height: 8),
          Text(
            fileName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_drive_file, size: 50, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            fileName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Feedback/Doubt',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Classroom Dropdown

                        // Title Field
                        _buildSectionTitle('Feedback Title'),
                        _buildTextField(
                          controller: titleController,
                          hintText: 'Enter feedback title',
                          prefixIcon: Icons.title,
                        ),
                        const SizedBox(height: 24),

                        // Description Field
                        _buildSectionTitle('Description'),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: descriptionController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Enter your feedback or doubt',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // File Upload
                        _buildSectionTitle('Attachment (Optional)'),
                        GestureDetector(
                          onTap: _pickFile,
                          child: Container(
                            height: 180,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade50,
                            ),
                            child: Center(
                              child:
                                  _file == null
                                      ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.cloud_upload,
                                            size: 50,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'Upload files',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'PDF, Word, Image files',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      )
                                      : _buildFilePreview(_file!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Submit Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _submitFeedback(
                    fileType,
                    titleController.text,
                    descriptionController.text,
                    _file,
                    widget.classroomId,
                    widget.email,
                    widget.userPhoto,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 54),
                ),
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : const Text(
                          'Submit Feedback',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon, color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}
