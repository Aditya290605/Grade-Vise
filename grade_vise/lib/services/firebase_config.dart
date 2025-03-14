import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  static FirebaseAuth get auth => FirebaseAuth.instance;
}