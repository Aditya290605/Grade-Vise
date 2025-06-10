import 'package:flutter/material.dart';
import 'package:grade_vise/utils/colors.dart';
import 'package:grade_vise/widgets/pdf_viewer.dart';
import 'dart:io';

class StudentFeedbackDetailScreen extends StatefulWidget {
  final String studentName;
  final String des;
  final Color bgColor;
  final String title;
  final String fileType;
  final String filePath; // Path to the submitted file

  const StudentFeedbackDetailScreen({
    super.key,
    required this.title,
    required this.fileType,
    required this.studentName,
    required this.des,
    required this.filePath,
    this.bgColor = const Color(0xFF1F2839),
  });

  @override
  State<StudentFeedbackDetailScreen> createState() =>
      _StudentFeedbackDetailScreenState();
}

class _StudentFeedbackDetailScreenState
    extends State<StudentFeedbackDetailScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Feedback Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        backgroundColor: widget.bgColor,
        foregroundColor: _getContrastingColor(widget.bgColor),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Show options menu
              _showOptionsMenu(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Info Card with Avatar
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: widget.bgColor.withOpacity(0.2),
                      child: Text(
                        widget.studentName.isNotEmpty
                            ? widget.studentName[0].toUpperCase()
                            : "S",
                        style: TextStyle(
                          color: widget.bgColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.studentName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.school, size: 16, color: Colors.blue),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.des,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Feedback Title Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.feedback_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Feedback Title',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Feedback Description
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.des,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Attachment/File Preview Section with improved design
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.attachment,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Attachment',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFilePreview(context),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Teacher Response Section with improved design
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.reply,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Teacher Response',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _feedbackController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Provide feedback to the student...',
                        fillColor: Colors.grey[50],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.attach_file),
                          onPressed: () {
                            // Implement file attachment
                            _attachFile();
                          },
                          tooltip: 'Attach File',
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () {
                            // Implement image attachment
                            _attachImage();
                          },
                          tooltip: 'Attach Image',
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          onPressed: _isSending ? null : _submitFeedback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          icon:
                              _isSending
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Icon(Icons.send),
                          label: Text(
                            _isSending ? 'Sending...' : 'Send Response',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview(BuildContext context) {
    // Determine file type and show appropriate preview
    switch (widget.fileType.toLowerCase()) {
      case 'pdf':
        return _buildPdfPreview(context);
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return _buildImagePreview(context);
      case 'doc':
      case 'docx':
        return _buildDocPreview(context);
      case 'xls':
      case 'xlsx':
        return _buildExcelPreview(context);
      case 'ppt':
      case 'pptx':
        return _buildPptPreview(context);
      default:
        return _buildGenericFilePreview(context);
    }
  }

  Widget _buildPdfPreview(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.picture_as_pdf, size: 56, color: Colors.red[700]),
              const SizedBox(height: 8),
              Text(
                'PDF Document',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                _getFileName(widget.filePath),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                _downloadFile();
              },
              icon: Icon(Icons.download),
              label: Text('Download'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PdfViewerScreen(pdfUrl: widget.filePath),
                  ),
                );
              },
              icon: Icon(Icons.open_in_new),
              label: Text('Open PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.filePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 56, color: Colors.blue[300]),
                    const SizedBox(height: 8),
                    Text(
                      'Image Preview Unavailable',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                _downloadFile();
              },
              icon: Icon(Icons.download),
              label: Text('Download'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Open in gallery
                _openInGallery();
              },
              icon: Icon(Icons.fullscreen),
              label: Text('View in Gallery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocPreview(BuildContext context) {
    return _buildGenericDocumentPreview(
      context,
      'Word Document',
      Icons.description,
      Colors.blue[700]!,
    );
  }

  Widget _buildExcelPreview(BuildContext context) {
    return _buildGenericDocumentPreview(
      context,
      'Excel Spreadsheet',
      Icons.table_chart,
      Colors.green[700]!,
    );
  }

  Widget _buildPptPreview(BuildContext context) {
    return _buildGenericDocumentPreview(
      context,
      'PowerPoint Presentation',
      Icons.slideshow,
      Colors.orange[700]!,
    );
  }

  Widget _buildGenericDocumentPreview(
    BuildContext context,
    String fileTypeLabel,
    IconData icon,
    Color iconColor,
  ) {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 56, color: iconColor),
              const SizedBox(height: 8),
              Text(
                fileTypeLabel,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                _getFileName(widget.filePath),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _downloadFile();
              },
              icon: Icon(Icons.download),
              label: Text('Download File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenericFilePreview(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_drive_file, size: 56, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text(
                'File',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                _getFileName(widget.filePath),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _downloadFile();
              },
              icon: Icon(Icons.download),
              label: Text('Download File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getFileName(String path) {
    // Extract filename from path
    final parts = path.split('/');
    return parts.isNotEmpty ? parts.last : 'file';
  }

  void _submitFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter feedback before submitting')),
      );
      return;
    }

    // Show loading state
    setState(() {
      _isSending = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(Duration(seconds: 2));

      // TODO: Implement feedback submission logic to backend
      // This would involve sending the feedback to an API

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Feedback submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Return to previous screen
      Navigator.pop(context);
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting feedback: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Reset loading state
      setState(() {
        _isSending = false;
      });
    }
  }

  void _downloadFile() {
    // TODO: Implement file download logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Downloading file...')));
  }

  void _openInGallery() {
    // TODO: Implement open in gallery
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ImageViewerScreen(imageUrl: widget.filePath),
      ),
    );
  }

  void _attachFile() {
    // TODO: Implement file attachment
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File attachment feature coming soon')),
    );
  }

  void _attachImage() {
    // TODO: Implement image attachment
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image attachment feature coming soon')),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.print),
                title: Text('Print'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement print functionality
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement share functionality
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('View History'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to feedback history
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getContrastingColor(Color backgroundColor) {
    // Calculate luminance to determine if we should use black or white text
    double luminance =
        (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;

    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

// Image viewer screen for displaying images in full screen
class _ImageViewerScreen extends StatelessWidget {
  final String imageUrl;

  const _ImageViewerScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 64, color: Colors.white70),
                  SizedBox(height: 16),
                  Text(
                    'Image could not be loaded',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
