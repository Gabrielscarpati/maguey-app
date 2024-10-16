import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('bbbbbb');

      final googleUser = await GoogleSignIn().signIn();
      print('googleUser');
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      print('googleAuth');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      print('credential');
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
