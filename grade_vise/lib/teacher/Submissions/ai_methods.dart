import 'package:firebase_vertexai/firebase_vertexai.dart';

Future<List<Map<String, dynamic>>> evaluateSolutions(
  List<Map<String, String>> solutions,
  String assignmentContent,
) async {
  // Use Firebase remote config or env variable
  final model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-2.0-flash',
  );

  List<Map<String, dynamic>> results = [];

  for (var solution in solutions) {
    Content prompt = Content.text('''
You are an experienced teacher grading a student's assignment. Your goal is to evaluate the answer strictly based on the given assignment instructions while providing constructive feedback in a **clear, structured, and human-like manner**.

---
### **Assignment Description:**  
$assignmentContent  

### **Student's Answer:**  
${solution["solution"]}  

---
### **Your Task:**  
- Assign a **strict mark out of 10** based on accuracy, completeness, clarity, and adherence to instructions.  
- Provide **well-structured feedback** directly addressing the student.  
- Use a professional but encouraging tone. Avoid third-person references like "the student"—instead, speak directly ("You have explained...", "Your answer could be improved by...").  

---
### **Response Format:**  
''');

    final response = await model.generateContent([prompt]);

    if (response.text != null) {
      final extractedData = parseResponse(response.text!);
      results.add({
        "uid": solution["uid"],
        "assignmentId": solution["assignmentId"],
        "classroomId": solution["classroomId"],
        "mark": extractedData["mark"],
        "feedback": extractedData["feedback"],
        'submissionId': solution['submissionId'],
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
