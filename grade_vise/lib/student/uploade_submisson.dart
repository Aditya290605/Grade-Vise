import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/services/storage_methods.dart';
import 'package:grade_vise/utils/show_error.dart';
import 'package:lottie/lottie.dart';

class UploadeSubmisson extends StatefulWidget {
  final String assignmentId;
  final String uid;
  final String classroomId;
  const UploadeSubmisson({
    super.key,
    required this.assignmentId,
    required this.uid,
    required this.classroomId,
  });

  @override
  State<UploadeSubmisson> createState() => _UploadeSubmissonState();
}

class _UploadeSubmissonState extends State<UploadeSubmisson> {
  String fileType = '';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  bool isLoading = false;

  FilePickerResult? _file;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx', 'ppt', 'pptx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _file = result;
      });
    }
  }

  Future<void> submit(
    FilePickerResult result,
    String childname,
    String title,
    String date,
    String description,
    String assignmentId,
    String uid,
  ) async {
    setState(() {
      isLoading = true;
    });

    String res = await StorageMethods().uploadSubmisson(
      result,
      childname,
      title,
      description,
      assignmentId,
      uid,
      fileType,
      widget.classroomId,
    );

    setState(() {
      isLoading = false;
    });

    if (res == 'success') {
      // Show Lottie animation
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => Center(
              child: Container(
                width: 200,
                height: 200,
                child: Lottie.asset(
                  'assets/submission.json',
                  repeat: false,
                  onLoaded: (composition) {
                    Future.delayed(composition.duration, () {
                      Navigator.of(context).pop(); // Close animation dialog
                      Navigator.of(context).pop(); // Go back to previous screen
                      showSnakbar(context, "File uploaded successfully!");
                    });
                  },
                ),
              ),
            ),
      );
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
          SizedBox(height: 8),
          Text(
            fileName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_drive_file, size: 50, color: Colors.blue),
          SizedBox(height: 8),
          Text(
            fileName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                    onTap: () => Navigator.pop(context),
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
                    'Upload Assignment',
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
                        // Title Field
                        _buildSectionTitle('Solution title'),
                        _buildTextField(
                          controller: titleController,
                          hintText: 'Enter assignment title',
                          prefixIcon: Icons.title,
                        ),
                        const SizedBox(height: 24),

                        // Subject Dropdown

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
                              hintText: 'Write any description',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // File Upload
                        _buildSectionTitle('Attachment'),
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
                                            'Upload your solution',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'PDF, Word, PPT, Image files',
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
                  if (_file != null) {
                    submit(
                      _file!,
                      "submissions",
                      titleController.text,

                      dueDateController.text,
                      descriptionController.text,
                      widget.assignmentId,
                      widget.uid,
                    );
                  } else {
                    // Show a snackbar or dialog for missing file
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please attach a file')),
                    );
                  }
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
                          'Upload Assignment',
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
