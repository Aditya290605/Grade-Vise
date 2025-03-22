import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:grade_vise/utils/show_error.dart';
import 'package:flutter/services.dart' show rootBundle;

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  Stream<User?> get authState => _auth.authStateChanges();

  Future<String> signUpUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    String res = "";
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (context.mounted) {
        showSnakbar(context, 'User signed up successfully');
      }
      res = userCredential.user!.uid;
    } catch (e) {
      if (context.mounted) {
        showSnakbar(context, e.toString());
      }
      res = e.toString();
    }
    return res;
  }

  Future<String> signInUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    String res = '';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'success';
    } catch (e) {
      if (context.mounted) {
        showSnakbar(context, e.toString());
      }
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String?> createGoogleMeetEvent(auth.AuthClient authClient) async {
    try {
      var calendarApi = calendar.CalendarApi(authClient);
      var event = calendar.Event(
        summary: "Google Meet Meeting",
        description: "Scheduled Google Meet event",
        start: calendar.EventDateTime(
          dateTime: DateTime.now().add(Duration(hours: 1)),
          timeZone: "GMT",
        ),
        end: calendar.EventDateTime(
          dateTime: DateTime.now().add(Duration(hours: 2)),
          timeZone: "GMT",
        ),
        conferenceData: calendar.ConferenceData(
          createRequest: calendar.CreateConferenceRequest(
            requestId: "meet-${DateTime.now().millisecondsSinceEpoch}",
          ),
        ),
      );

      var createdEvent = await calendarApi.events.insert(
        event,
        "primary",
        conferenceDataVersion: 1,
      );

      String? meetLink = createdEvent.hangoutLink;
      print("✅ Google Meet Event Created: $meetLink");

      return meetLink;
    } catch (e) {
      print("❌ Error creating Google Meet event: $e");
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['https://www.googleapis.com/auth/calendar.events'],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (userCredential.additionalUserInfo!.isNewUser) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .set({
              "uid": user.uid,
              "name": user.displayName,
              "email": user.email,
              "photoURL": user.photoURL,
              "createdAt": DateTime.now(),
              'role': '',
              'classrooms': [],
            });
      }

      // ✅ Authenticate Google API using OAuth JSON credentials
      final auth.ServiceAccountCredentials credentials = await auth
          .ServiceAccountCredentials.fromJson(
        (await rootBundle.loadString('assets/credentials.json')),
      );

      final auth.AuthClient authClient = await clientViaServiceAccount(
        credentials,
        ['https://www.googleapis.com/auth/calendar.events'],
      );

      String? meetLink = await createGoogleMeetEvent(authClient);

      // ✅ Store Meet Link in Firestore
      if (meetLink != null && user != null) {
        await FirebaseFirestore.instance.collection("meetings").add({
          "userId": user.uid,
          "meetLink": meetLink,
          "createdAt": DateTime.now(),
        });
      }

      return user;
    } catch (e) {
      print("❌ Error during Google Sign-In: $e");
      return null;
    }
  }
}
// old change

// this is old logic
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// import 'package:grade_vise/utils/show_error.dart';

// class FirebaseAuthMethods {
//   final FirebaseAuth _auth;
//   FirebaseAuthMethods(this._auth);

//   Stream<User?> get authState => _auth.authStateChanges();

//   Future<String> signUpUser(
//     BuildContext context,
//     String email,
//     String password,
//   ) async {
//     String res = "";
//     try {
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       if (context.mounted) {
//         showSnakbar(context, 'User signed up successfully');
//       }

//       res = userCredential.user!.uid;
//       return res;
//     } catch (e) {
//       if (context.mounted) {
//         res = e.toString();
//         showSnakbar(context, e.toString());
//       }
//     }
//     return res;
//   }

//   Future<String> singInUser(
//     BuildContext context,
//     String username,
//     String password,
//   ) async {
//     String res = '';
//     try {
//       await _auth.signInWithEmailAndPassword(
//         email: username,
//         password: password,
//       );
//       res = 'success';
//     } catch (e) {
//       res = e.toString();
//       if (context.mounted) {
//         showSnakbar(context, e.toString());
//       }
//     }
//     return res;
//   }

//   Future<void> signOut() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   // Google Sign-In
//   Future<User?> signInWithGoogle() async {
//     try {
//       // Trigger the Google Sign-In flow
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return null; // User canceled sign-in

//       // Get authentication details
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // Create credential
//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in with Firebase
//       final UserCredential userCredential = await _auth.signInWithCredential(
//         credential,
//       );
//       final User? user = userCredential.user;

//       // 🔍 Check if the user is new
//       if (userCredential.additionalUserInfo!.isNewUser) {
//         // Store additional user data in Firestore (only for new users)
//         await FirebaseFirestore.instance
//             .collection("users")
//             .doc(user!.uid)
//             .set({
//               "uid": user.uid,
//               "name": user.displayName,
//               "email": user.email,
//               "photoURL": user.photoURL,
//               "createdAt": DateTime.now(),
//               'role': '',
//               'classrooms': [],
//             });
//       }

//       return user;
//     } catch (e) {
//       print("Error during Google Sign-In: $e");
//       return null;
//     }
//   }
// }
