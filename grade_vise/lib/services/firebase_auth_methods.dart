import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:grade_vise/utils/show_error.dart';

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
      return res;
    } catch (e) {
      if (context.mounted) {
        res = e.toString();
        showSnakbar(context, e.toString());
      }
    }
    return res;
  }

  Future<void> singInUser(
    BuildContext context,
    String username,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
    } catch (e) {
      if (context.mounted) {
        showSnakbar(context, e.toString());
      }
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // User canceled sign-in

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      // 🔍 Check if the user is new
      if (userCredential.additionalUserInfo!.isNewUser) {
        // Store additional user data in Firestore (only for new users)
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
            });
      }

      return user;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }
}
