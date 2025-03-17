import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  Future<String> uploadFiles(
    FilePickerResult result,
    String chilname,
    String title,
    String date,
    String description,
    String classroomId,
    String uid,
  ) async {
    String res = '';
    try {
      File file = File(result.files.single.path!);
      String fileId = const Uuid().v1();

      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child(chilname)
          .child(uid)
          .child(fileId);

      UploadTask uploadTask = storageRef.putFile(file);

      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('assignments')
          .doc(fileId)
          .set({
            'fileId': fileId,
            'title': title,
            'description': description,
            "userId": uid,
            "dueDate": date,
            'classroomId': classroomId,
            'fileUrl': downloadUrl,
            'uploadedAt': FieldValue.serverTimestamp(),
            'submissions': [],
          });

      await FirebaseFirestore.instance
          .collection('classrooms')
          .doc(classroomId)
          .update({
            'assignments': FieldValue.arrayUnion([fileId]),
          });
      res = 'success';
      return res;
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
