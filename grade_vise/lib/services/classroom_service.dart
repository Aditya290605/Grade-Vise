import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_config.dart';

class ClassroomService {
  final FirebaseFirestore _firestore = FirebaseConfig.firestore;
  final FirebaseAuth _auth = FirebaseConfig.auth;

  // Check if classroom exists and join it
  Future<Map<String, dynamic>?> joinClassroom(String classCode) async {
    try {
      // Check if the user is authenticated
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Query Firestore to find classroom with the given code
      final QuerySnapshot classroomQuery = await _firestore
          .collection('classrooms')
          .where('classCode', isEqualTo: classCode)
          .limit(1)
          .get();

      // If no classroom found with the given code
      if (classroomQuery.docs.isEmpty) {
        return null;
      }

      // Get classroom data
      final classroomDoc = classroomQuery.docs.first;
      final classroomData = classroomDoc.data() as Map<String, dynamic>;
      final classroomId = classroomDoc.id;

      // Add user to classroom members collection
      await _firestore
          .collection('classrooms')
          .doc(classroomId)
          .collection('members')
          .doc(_auth.currentUser!.uid)
          .set({
        'userId': _auth.currentUser!.uid,
        'email': _auth.currentUser!.email,
        'displayName': _auth.currentUser!.displayName,
        'role': 'student',
        'joinedAt': FieldValue.serverTimestamp(),
      });

      // Add classroom to user's joined classrooms
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('classrooms')
          .doc(classroomId)
          .set({
        'classroomId': classroomId,
        'classroomName': classroomData['name'],
        'joinedAt': FieldValue.serverTimestamp(),
        'role': 'student',
      });

      // Return classroom data
      return {
        'id': classroomId,
        ...classroomData,
      };
    } catch (e) {
      print('Error joining classroom: $e');
      throw e;
    }
  }

  // Get user's joined classrooms
  Future<List<Map<String, dynamic>>> getUserClassrooms() async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      final QuerySnapshot userClassroomsQuery = await _firestore
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
        final classroomDoc = await _firestore.collection('classrooms').doc(classroomId).get();
        
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
      
      final QuerySnapshot scheduleQuery = await _firestore
          .collection('schedules')
          .orderBy('startTime')
          .get();

      return scheduleQuery.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      print('Error getting schedule: $e');
      throw e;
    }
  }
}