import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/services/storage_methods.dart';
import 'package:grade_vise/utils/show_error.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class AssignmentCreationPage extends StatefulWidget {
  final String uid;
  final String classroomId;
  const AssignmentCreationPage({
    super.key,
    required this.classroomId,
    required this.uid,
  });

  @override
  State<AssignmentCreationPage> createState() => _AssignmentCreationPageState();
}

class _AssignmentCreationPageState extends State<AssignmentCreationPage> {
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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1F2937),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        dueDateController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  Future<void> submit(
    FilePickerResult result,
    String chilname,
    String title,
    String date,
    String description,
    String classroomId,
    String uid,
    String fileType,
  ) async {
    setState(() {
      isLoading = true;
    });
    String res = await StorageMethods().uploadFiles(
      result,
      chilname,
      title,
      date,
      description,
      classroomId,
      uid,
      fileType,
    );
    setState(() {
      isLoading = false;
    });

    if (res == 'success') {
      showSnakbar(context, "file uploaded");
      Navigator.pop(context);
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
                    'Create Assignment',
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
                        _buildSectionTitle('Assignment Title'),
                        _buildTextField(
                          controller: titleController,
                          hintText: 'Enter assignment title',
                          prefixIcon: Icons.title,
                        ),
                        const SizedBox(height: 24),

                        // Subject Dropdown

                        // Due Date Field
                        _buildSectionTitle('Due Date'),
                        _buildTextField(
                          controller: dueDateController,
                          hintText: 'Select due date',
                          prefixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: _selectDate,
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
                              hintText: 'Enter assignment description',
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
                                            'Upload files',
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
                      "assignment",
                      titleController.text,

                      dueDateController.text,
                      descriptionController.text,
                      widget.classroomId,
                      widget.uid,
                      fileType,
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
