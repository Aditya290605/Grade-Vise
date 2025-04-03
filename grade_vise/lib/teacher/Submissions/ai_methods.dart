import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

Future<List<Map<String, dynamic>>> evaluateSolutions(
  List<Map<String, String>> solutions,
  String assignmentContent,
) async {
  final model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-2.0-flash',
  );

  List<Map<String, dynamic>> results = [];

  for (var solution in solutions) {
    Content prompt = Content.text('''
You are an experienced teacher evaluating a student's assignment. Your job is to fairly assess their submission based on the given instructions, provide constructive feedback, and offer a brief performance summary.

---

### **Assignment Details:**  
$assignmentContent  

### **Student's Submission:**  
${solution["solution"]}  

---

### **Evaluation Criteria (Score out of 10):**  
- **Accuracy (4 points):** Does the response follow the instructions precisely?  
- **Completeness (3 points):** Does it fully answer all parts of the question?  
- **Clarity (2 points):** Is the explanation well-structured and easy to understand?  
- **Originality (1 point):** Does it show independent thinking?  

---

### **Your Task:**  
1. Assign a **fair mark out of 10**, ensuring that different levels of correctness get different marks.  
2. Provide **specific feedback** on what the student did well and what can be improved.  
3. Write a **brief summary report** (2-3 sentences) highlighting strengths and areas of improvement.  

---

### **Response Format (Follow Strictly):**  
Mark: [Numeric value out of 10]  
Feedback: [Detailed but concise feedback about the student's submission]  
Summary Report: [Brief overall performance review in 2-3 sentences]  
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
        "summaryReport": extractedData["summaryReport"],
        'submissionId': solution['submissionId'],
      });
    }
  }

  return results;
}

// Helper function to parse Gemini response
Map<String, dynamic> parseResponse(String responseText) {
  RegExp markRegex = RegExp(r"Mark:\s*(\d+)");
  RegExp feedbackRegex = RegExp(
    r"Feedback:\s*(.+?)(?=Summary Report:|\z)",
    dotAll: true,
  );
  RegExp summaryRegex = RegExp(r"Summary Report:\s*(.+)", dotAll: true);

  int mark =
      markRegex.firstMatch(responseText)?.group(1) != null
          ? int.parse(markRegex.firstMatch(responseText)!.group(1)!)
          : 0;

  String feedback =
      feedbackRegex.firstMatch(responseText)?.group(1)?.trim() ??
      "No feedback provided.";
  String summaryReport =
      summaryRegex.firstMatch(responseText)?.group(1)?.trim() ??
      "No summary provided.";

  return {"mark": mark, "feedback": feedback, "summaryReport": summaryReport};
}

Future<void> generateStudentReport(String classroomId, String uid) async {
  // Fetch evaluations from Firestore
  var snap =
      await FirebaseFirestore.instance
          .collection('evaluations')
          .where('classroomId', isEqualTo: classroomId)
          .where('uid', isEqualTo: uid)
          .get();

  if (snap.docs.isEmpty) {
    print("No evaluations found for this student.");
    return;
  }

  int totalMarks = 0;
  int numEvaluations = snap.docs.length;
  String summary = "";

  for (var doc in snap.docs) {
    totalMarks += (doc.data()["mark"] ?? 0) as int;
    summary += "${doc.data()["summary"]}\n";
  }

  double percentage = (totalMarks / (numEvaluations * 10)) * 100;
  String grade = getGrade(percentage);
  String result = percentage >= 40 ? "Pass" : "Fail";

  final model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-2.0-flash',
  );

  Content prompt = Content.text('''
You are an AI assistant generating a detailed student performance report based on the given data.

---
### **Student Performance Summary:**
$summary

---
### **Your Task:**
Generate a structured report containing:
- **Total Marks:** $totalMarks
- **Percentage:** ${percentage.toStringAsFixed(2)}%
- **Grade:** $grade
- **Result:** $result
- **Remark:** A brief remark based on the student's overall performance.

---
### **Response Format (Strictly Follow This):**
Total Marks: [Total marks]
Percentage: [Percentage %]
Grade: [Grade]
Result: [Pass/Fail]
Remark: [Brief remark on student's performance]
''');

  final response = await model.generateContent([prompt]);

  if (response.text != null) {
    final extractedData = parseResponse1(response.text!);

    // Save to Firestore in summaryReport collection
    await FirebaseFirestore.instance.collection('summaryReport').doc(uid).set({
      "uid": uid,
      "classroomId": classroomId,
      "totalMarks": extractedData["totalMarks"],
      "percentage": extractedData["percentage"],
      "grade": extractedData["grade"],
      "result": extractedData["result"],
      "remark": extractedData["remark"],
    });
  }
}

String getGrade(double percentage) {
  if (percentage >= 90) return "A+";
  if (percentage >= 80) return "A";
  if (percentage >= 70) return "B";
  if (percentage >= 60) return "C";
  if (percentage >= 50) return "D";
  return "F";
}

Map<String, dynamic> parseResponse1(String responseText) {
  RegExp totalMarksRegex = RegExp(r"Total Marks:\s*(\d+)");
  RegExp percentageRegex = RegExp(r"Percentage:\s*([\d.]+)%");
  RegExp gradeRegex = RegExp(r"Grade:\s*(\w+)");
  RegExp resultRegex = RegExp(r"Result:\s*(\w+)");
  RegExp remarkRegex = RegExp(r"Remark:\s*(.+)", dotAll: true);

  return {
    "totalMarks": int.parse(
      totalMarksRegex.firstMatch(responseText)?.group(1) ?? "0",
    ),
    "percentage": double.parse(
      percentageRegex.firstMatch(responseText)?.group(1) ?? "0.0",
    ),
    "grade": gradeRegex.firstMatch(responseText)?.group(1) ?? "N/A",
    "result": resultRegex.firstMatch(responseText)?.group(1) ?? "N/A",
    "remark":
        remarkRegex.firstMatch(responseText)?.group(1)?.trim() ??
        "No remark provided.",
  };
}
