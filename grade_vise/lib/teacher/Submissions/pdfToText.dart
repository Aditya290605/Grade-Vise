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
      print(
        "❌ Error: Failed to fetch PDF (Status Code: ${response.statusCode})",
      );
      return null;
    }
  } catch (e) {
    print("❌ Exception while extracting text: $e");
    return null;
  }
}

// 🔹 Function to process PDF URLs and return extracted text
Future<List<Map<String, String>>> processAndExtractAssignments(
  List<String> userIds,
  List<String> fileUrls,
) async {
  if (userIds.length != fileUrls.length) {
    throw ArgumentError(
      "User IDs and File URLs lists must be of the same length.",
    );
  }

  List<Map<String, String>> results = [];

  for (int i = 0; i < userIds.length; i++) {
    String userId = userIds[i];
    String pdfUrl = fileUrls[i];

    print("📌 Processing User ID: $userId");

    String? extractedText = await extractTextFromUrl(pdfUrl);

    results.add({
      "user_id": userId,
      "assignment_text": extractedText ?? "Failed to extract text",
    });
  }

  return results;
}
