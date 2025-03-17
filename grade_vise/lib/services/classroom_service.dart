import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_config.dart';

class ClassroomService {
  final FirebaseFirestore _firestore = FirebaseConfig.firestore;
  final FirebaseAuth _auth = FirebaseConfig.auth;

  // Check if classroom exists and join it
  Future<String> joinClassroom(String classCode, String uid) async {
    String result = '';
    try {
      // Check if the user is authenticated
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      var classroom =
          await FirebaseFirestore.instance
              .collection('classrooms')
              .where('room', isEqualTo: classCode)
              .get();

      var users =
          await FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: uid)
              .get();

      if (classroom.docs.isEmpty) {
        result = 'Classroom not found';
        return result;
      }

      if (classroom.docs[0]['users'].contains(uid)) {
        result = 'Aready Joined';
        return result;
      }

      if (!classroom.docs[0]['users'].contains(uid)) {
        await FirebaseFirestore.instance
            .collection('classrooms')
            .doc(classroom.docs[0]['classroomId'])
            .update({
              'users': FieldValue.arrayUnion([uid]),
            });
      } else {
        result = 'Already joined';
      }

      if (!users.docs[0]['classrooms'].contains(
        classroom.docs[0]['classroomId'],
      )) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'classrooms': FieldValue.arrayUnion([
            classroom.docs[0]['classroomId'],
          ]),
        });
      } else {
        result = 'Already joined';
      }

      result = 'success';

      // Return classroom data
      return result;
    } catch (e) {
      result = e.toString();
      return result;
    }
  }

  // Get user's joined classrooms
  Future<List<Map<String, dynamic>>> getUserClassrooms() async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      final QuerySnapshot userClassroomsQuery =
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .collection('classrooms')
              .orderBy('joinedAt', descending: true)
              .get();

      List<Map<String, dynamic>> classrooms = [];

      for (var doc in userClassroomsQuery.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final classroomId = data['classroomId'];

        // Get full classroom details
        final classroomDoc =
            await _firestore.collection('classrooms').doc(classroomId).get();

        if (classroomDoc.exists) {
          final classroomData = classroomDoc.data() as Map<String, dynamic>;
          classrooms.add({
            'id': classroomId,
            ...classroomData,
            'role': data['role'],
          });
        }
      }

      return classrooms;
    } catch (e) {
      print('Error getting user classrooms: $e');
      throw e;
    }
  }

  // Get classroom schedule for today
  Future<List<Map<String, dynamic>>> getClassroomSchedule() async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      // This is a simplified implementation
      // In a real app, you would filter by day, user's enrolled courses, etc.

      final QuerySnapshot scheduleQuery =
          await _firestore.collection('schedules').orderBy('startTime').get();

      return scheduleQuery.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {'id': doc.id, ...data};
      }).toList();
    } catch (e) {
      print('Error getting schedule: $e');
      throw e;
    }
  }
}
