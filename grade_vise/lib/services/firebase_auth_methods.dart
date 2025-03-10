import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grade_vise/services/firestore_methods.dart';
import 'package:grade_vise/utils/show_error.dart';

class FirebaseAuthMethods {
  final _auth = FirebaseAuth.instance;

  Future<void> signUpUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (context.mounted) {
        showSnakbar(context, 'User signed up successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnakbar(context, e.toString());
      }
    }
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

  Future<void> googleSingIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser!.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth!.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );

        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            if (context.mounted) {
              FirestoreMethods().createUser(
                context,
                userCredential.user!.uid,
                userCredential.user!.displayName!,
                "",
                userCredential.user!.email!,
                '',
              );
            }
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnakbar(context, e.toString());
        debugPrint(e.toString());
      }
    }
  }
}
