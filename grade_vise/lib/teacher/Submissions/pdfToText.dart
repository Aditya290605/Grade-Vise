import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<String?> extractTextFromFirebaseUrl(String pdfUrl) async {
  try {
    // 🔹 Fetch the PDF as bytes from the given URL
    final response = await http.get(Uri.parse(pdfUrl));

    if (response.statusCode == 200) {
      // 🔹 Load PDF document from bytes
      final PdfDocument document = PdfDocument(inputBytes: response.bodyBytes);

      // 🔹 Extract text page by page (Better for large PDFs)
      StringBuffer extractedText = StringBuffer();
      for (int i = 0; i < document.pages.count; i++) {
        extractedText.writeln(
          PdfTextExtractor(
            document,
          ).extractText(startPageIndex: i, endPageIndex: i),
        );
      }

      // 🔹 Dispose document to free memory
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
