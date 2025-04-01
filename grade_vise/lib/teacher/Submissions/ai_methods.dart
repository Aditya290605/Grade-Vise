import 'package:google_generative_ai/google_generative_ai.dart';

Future<List<Map<String, dynamic>>> evaluateSolutions(
  List<Map<String, String>> solutions,
  String assignmentContent,
) async {
  final apiKey = "AIzaSyC-rB4l8vm-8qwvynNstXa3rh3FwYlm8mc";
  // Use Firebase remote config or env variable
  final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);

  List<Map<String, dynamic>> results = [];

  for (var solution in solutions) {
    Content prompt = Content.text("""
      You are an expert teacher grading student assignments. Evaluate the student's answer strictly based on the given assignment instructions.
      
      **Assignment Description:** 
      $assignmentContent

      **Student Submission:** 
      ${solution["solution"]}

      **Your Task:**
      - Give a **mark out of 10** (strict grading)
      - Provide detailed **feedback**, including:
        - Mistakes in content, formatting, or approach
        - Suggestions for improvement
        - Highlight good points

      **Response Format:**
      ```
      Mark: <number out of 10>
      Feedback: <detailed feedback>
      ```
    """);

    final response = await model.generateContent([prompt]);

    if (response.text != null) {
      final extractedData = parseResponse(response.text!);
      results.add({
        "uid": solution["uid"],
        "mark": extractedData["mark"],
        "feedback": extractedData["feedback"],
      });
    }
  }

  return results;
}

// Helper function to parse Gemini response
Map<String, dynamic> parseResponse(String responseText) {
  RegExp markRegex = RegExp(r"Mark:\s*(\d+)");
  RegExp feedbackRegex = RegExp(r"Feedback:\s*(.+)", dotAll: true);

  int mark =
      markRegex.firstMatch(responseText)?.group(1) != null
          ? int.parse(markRegex.firstMatch(responseText)!.group(1)!)
          : 0;

  String feedback =
      feedbackRegex.firstMatch(responseText)?.group(1) ??
      "No feedback provided.";

  return {"mark": mark, "feedback": feedback};
}
