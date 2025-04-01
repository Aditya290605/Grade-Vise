import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:uuid/uuid.dart';

class StorageMethods {
  final auth = FirebaseAuth.instance;

  Future<String> uploadFiles(
    FilePickerResult result,
    String chilname,
    String title,
    String date,
    String description,
    String classroomId,
    String uid,
    String fileType,
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
            'fileType': fileType,
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

  Future<String> uploadSubmisson(
    FilePickerResult result,
    String childname,
    String title,
    String description,
    String uid,
    String assignmentId,
    String fileType,
    String classroomId,
  ) async {
    String res = '';
    try {
      File file = File(result.files.single.path!);
      String fileId = const Uuid().v1();

      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child(childname)
          .child(uid)
          .child(fileId);

      UploadTask uploadTask = storageRef.putFile(file);

      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('submissions')
          .doc(fileId)
          .set({
            'submissionId': fileId,
            'assignmentId': uid,
            'title': title,
            'description': description,
            "userId": auth.currentUser!.uid,
            'classroomId': classroomId,
            'fileUrl': downloadUrl,
            'fileType': fileType,
            'uploadedAt': FieldValue.serverTimestamp(),
            'submittedBy': FieldValue.arrayUnion([auth.currentUser!.uid]),
          });

      await FirebaseFirestore.instance
          .collection('assignments')
          .doc(uid)
          .update({
            'submissions': FieldValue.arrayUnion([fileId]),
          });
      res = 'success';
      return res;
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> uploadFeedback(
    FilePickerResult result,
    String childname,
    String uid,
  ) async {
    File file = File(result.files.single.path!);
    String fileId = const Uuid().v1();

    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child(childname)
        .child(uid)
        .child(fileId);

    UploadTask uploadTask = storageRef.putFile(file);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
