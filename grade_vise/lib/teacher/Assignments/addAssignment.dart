import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AssignmentCreationPage extends StatefulWidget {
  const AssignmentCreationPage({Key? key}) : super(key: key);

  @override
  State<AssignmentCreationPage> createState() => _AssignmentCreationPageState();
}

class _AssignmentCreationPageState extends State<AssignmentCreationPage> {
  final List<String> classrooms = ['Alexa Clark', 'John Doe', 'Physics Lab'];
  final List<String> subjects = ['Math', 'Science', 'History'];
  String classroom = 'Alexa Clark';
  String subject = 'Math';
  String title = 'Factoring a sum or difference of two cubes';
  String description = '';
  File? _file;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });
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
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 28,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Select Classroom
                          const Text(
                            'Select Classroom',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          DropdownButton<String>(
                            value: classroom,
                            isExpanded: true,
                            onChanged:
                                (newValue) =>
                                    setState(() => classroom = newValue!),
                            items:
                                classrooms
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                    .toList(),
                          ),
                          const Divider(height: 24),

                          // Select Subject
                          const Text(
                            'Select Subject',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          DropdownButton<String>(
                            value: subject,
                            isExpanded: true,
                            onChanged:
                                (newValue) =>
                                    setState(() => subject = newValue!),
                            items:
                                subjects
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                    .toList(),
                          ),
                          const Divider(height: 24),

                          // Title
                          const Text(
                            'Title',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          TextField(
                            controller: TextEditingController(text: title),
                            onChanged: (value) => setState(() => title = value),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                          const Divider(height: 24),

                          // Upload Description
                          const Text(
                            'Upload Description',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          TextField(
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Enter description here...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged:
                                (value) => setState(() => description = value),
                          ),
                          const Divider(height: 24),

                          // File Upload
                          GestureDetector(
                            onTap: _pickFile,
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child:
                                    _file == null
                                        ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.cloud_upload,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Choose a file or tap here',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                        : Image.file(
                                          _file!,
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Send Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2937),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'SEND',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
