import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';

// 🔹 Function to extract text from a single PDF file
Future<String?> extractTextFromUrl(String pdfUrl) async {
  try {
    final response = await http.get(Uri.parse(pdfUrl));

    if (response.statusCode == 200) {
      final PdfDocument document = PdfDocument(inputBytes: response.bodyBytes);
      StringBuffer extractedText = StringBuffer();

      for (int i = 0; i < document.pages.count; i++) {
        extractedText.writeln(
          PdfTextExtractor(
            document,
          ).extractText(startPageIndex: i, endPageIndex: i),
        );
      }

      document.dispose();
      return extractedText.toString().trim();
    } else {
      debugPrint(
        "❌ Error: Failed to fetch PDF (Status Code: ${response.statusCode})",
      );
      return null;
    }
  } catch (e) {
    debugPrint("❌ Exception while extracting text: $e");
    return null;
  }
}

// 🔹 Function to process PDF URLs and return extracted text
List<Map<String, String>> convertToSolutionList(
  List<String> uids,
  List<String> fileContents,
  List<String> assignmentId,
  List<String> classroomId,
  List<String> submissionId,
) {
  if (uids.length != fileContents.length) {
    throw Exception("Mismatch in UID and file content length!");
  }

  return List.generate(
    uids.length,
    (index) => {
      "uid": uids[index],
      "solution": fileContents[index],
      'assignmentId': assignmentId[index],
      'classroomId': classroomId[index],
      'submissionId': submissionId[index],
    },
  );
}
