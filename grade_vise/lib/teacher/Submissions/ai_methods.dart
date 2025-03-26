import 'dart:convert';
import 'package:http/http.dart' as http;

class AiMethods {
  Future<String> analyzeWithAI(String imageUrl) async {
    String apiKey =
        "AIzaSyCURahkwb1_t_q9Z5To6c9qcE3u-bbS7Kg"; // Replace with a valid API key
    String apiUrl =
        "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent";

    try {
      // Fetch image bytes
      var imageResponse = await http.get(Uri.parse(imageUrl));
      if (imageResponse.statusCode != 200) {
        return "Error fetching image: ${imageResponse.statusCode}";
      }

      // Encode image in base64
      String base64Image = base64Encode(imageResponse.bodyBytes);

      // API request body
      var requestBody = jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text":
                    "generate a random number between 1 to 10 just give that number as output",
              },
              {
                "inlineData": {"mimeType": "image/jpeg", "data": base64Image},
              },
            ],
          },
        ],
      });

      // API Call
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "x-goog-api-key": apiKey, // Correct header for API key authentication
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        // Extract the text field
        String textResponse =
            jsonResponse["candidates"][0]["content"]["parts"][0]["text"];

        return textResponse; // This will return only the generated number
      } else {
        return "Error: ${response.statusCode}, ${response.body}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
}
