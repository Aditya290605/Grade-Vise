import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class FirebaseNotifications {
  Future<void> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> sendNotification(String classroomId, String message) async {
    try {
      // Step 1: Get the server key
      const String serverKey = 'AIzaSyDM0U0meiD29pyJsl1sxZT1IF2yt_WXc80';

      // Step 2: Get all tokens from Firestore for users in that classroom
      final usersSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('classrooms', arrayContains: classroomId)
              .get();

      List<String> tokens =
          usersSnapshot.docs
              .map((doc) => doc.data()['fcmToken'] as String?)
              .where((token) => token != null)
              .cast<String>()
              .toList();

      if (tokens.isEmpty) {
        print("No tokens available for notifications.");
        return;
      }

      // Step 3: Send Notification using HTTP request
      final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      final Map<String, dynamic> notificationData = {
        "notification": {"title": "New Announcement", "body": message},
        "registration_ids": tokens, // Multiple tokens for bulk notification
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: json.encode(notificationData),
      );

      if (response.statusCode == 200) {
        debugPrint("Notification sent successfully!");
      } else {
        debugPrint("Failed to send notification: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error sending notification: $e");
    }
  }
}
