import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth1;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "YOUR_API_KEY",
        authDomain: "grade_vise.firebaseapp.com",
        projectId: "grade_vise",
        storageBucket: "grade_vise.appspot.com",
        messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
        appId: "YOUR_APP_ID",
      ),
    );
  }

  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseAuth get authh => FirebaseAuth.instance;

  Future<String> getAccessToken() async {
    final credentials = {
      "type": "service_account",
      "project_id": "gradevise-e5c0d",
      "private_key_id": "3aaa1f4f3e6e04ab826bfe8e853a6f10df96ef13",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCwUG2vFuyKs4kH\nbPVrc5Cx5jg/Pt+XsEVDD6cGwc1rv46pXJkzNQTV4aDd+ZK8n7CSw9jPChsJaRcF\nQoBn9epwj62Zp6U4i724Z1qgqEBJ9CAylNRj+G8LC5UUVYjC67YLISaRnSNAaxp0\n2xrGXuu6j3j/Kl1rq6K9Mh1TdMDxMGFDzVWivKy9NyYxQwDv0mMQZDJlXTfAIokC\nelKGQWfTBnKgnbJUiFVsgvQ+YozOB+fwyY+Szb/w6aWQDbZv2gsuaIGwtltYxB9j\nbi9lXS3U5r75ZIbqLp9JRmnfIDXNWOaUi3/NeNz9Ke9s++wz7EpcSBimUF+uaL1k\nZIqyhkItAgMBAAECggEAAUBFvL90T4FPH5QPUaM6tHjla3GwZ79x3e0W7GZSs2kN\no7uCKx1u8dKS849hYGtRGqAp2vp1BH0o/egzlqlB6NsPP7RW9vsc3GDOQTy/gSUO\nOuBRh9NKGN3T7EhgF2o1CR3K2i9hLK7s+4ytPCebxTUXd+UnltKwtK14mzBapVmw\nGPxPfe7iMRmO/UEMqKzlIXv7bQnAmCOIyWKmKFeO+fGITpDPZZSqnzrDVtoHH2O+\nbOWjbYtAvAgwQ2PKpU9iN9LBwdm7VCUJUKbClMvjiICnE9v92NTeVOdgDoLed4+Q\ni6EqBBInLoxiyFLR/OAZLusxwVS5uX7htlZH9T1MEQKBgQDehJeqD8UvRr+keHvU\n0H0Ah4vX0LWsg+NyTGNuKtdNaNkg7Q0/APp9F83q64bbbLkcFy7wMD33Qyeoe9Fh\neC6ARGutmcAzkJ2DbLZXG+z8ka9mf6UaxWP8BIAiqpj2tkM0BVXOVRnkVVa81BKo\n4uw/G+7slHLpi7EmWWFJM8UHPQKBgQDK2BBDeJSbD8BqMvgAR4VyWf10jOE+UPze\n0W+bUCXVYvBtT24oB0okyTPEfkiZleyGp04D64HaSn7FgusJUvn9RkWqNR9/XWWG\nzbXGVXGKRlcngS/2qZbYq651wTkh87pcvfLNpVuyhgX/k11mp7P/Ai2WJn0zGNN1\npczK0clVsQKBgQC48g24rIjg5XXNttJ9rJfpA8AorXECpVA7JOCTpYnz7gxiAIU8\n84w+wrVE52PcJr6oaWB7BC3MwQVKVTdPQvurYrL4xEzqzu0MWiQnvK85scDOeZN5\n78xNoFP7/D1M+Wpb539NEpCFpqSEJ+QmeQ2Q2p+4BR6JnLCtxiZFGIFPpQKBgDaZ\nAYenpRg3nSr4nRg2KA0ne7krUlVbpzSyWsALSqOtBdnmT1gm3iYYof55n0D3wbpc\nvfsAIOuIsaaoHmtcEj3B9G5j7h5yHSmzpQHFbdIyLLNNaoOSEjAvxb2cTKx+1eKw\nnfIMWCotOOAZ4kIHUcOJ6otHwNtIC2LXRdAxt2eBAoGBANOj1UWtNxYApZDrQlO1\nCt1mCkqUlq6pOnX7g6KVWK0WoUMt7faZo2NG0Prc39wwXMDpNbaMjSDtq5Bt7+Ah\n0r8OeAAGOtXNGQ4fdNdLX/7y5OgjF0R2EplnQudySeWa/GeITKN/D15dBLw9fvy0\nUO18GLixBoY9KBfCdeLpVk5G\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-fbsvc@gradevise-e5c0d.iam.gserviceaccount.com",
      "client_id": "101890139818008355079",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40gradevise-e5c0d.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };

    final serviceAccountCredentials = auth.ServiceAccountCredentials.fromJson(
      credentials,
    );

    final client = await auth1.clientViaServiceAccount(
      serviceAccountCredentials,
      ['https://www.googleapis.com/auth/firebase.messaging'],
    );

    return client.credentials.accessToken.data;
  }

  Future<void> sendNotificationToAllUsers(
    String message,
    String classroomId,
  ) async {
    try {
      final tokensSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('classrooms', arrayContains: classroomId)
              .get();

      List<String> tokens =
          tokensSnapshot.docs.map((doc) => doc['fcmToken'].toString()).toList();

      if (tokens.isEmpty) {
        debugPrint('No tokens found for classroom $classroomId');
        return;
      }

      final accessToken = await getAccessToken();
      if (accessToken.isEmpty) {
        debugPrint('Failed to get access token');
        return;
      }

      for (String token in tokens) {
        final response = await http.post(
          Uri.parse(
            'https://fcm.googleapis.com/v1/projects/gradevise-e5c0d/messages:send',
          ),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "message": {
              "token": token,
              "notification": {"title": "New Announcement", "body": message},
              "android": {"priority": "high"},
              "apns": {
                "headers": {"apns-priority": "10"},
              },
            },
          }),
        );

        if (response.statusCode == 200) {
          debugPrint('Notification sent to token: $token');
        } else {
          debugPrint('Failed to send notification to token: $token');
          debugPrint('Error: ${response.body}');
        }
      }
      debugPrint(
        'Notification sent to ${tokens.length} users in classroom $classroomId',
      );
    } catch (e, stackTrace) {
      debugPrint('Error sending notifications: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}
