import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
//import 'package:lost_and_found/View/Screens/homeScreen.dart';
import 'package:lost_and_found/View/Screens/pageview.dart';
//import 'package:lost_and_found/View/Screens/homeScreen.dart';

class GoogleAuth {
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

      navigatorKey.currentState!.pushNamed(PageScreen.routeName);

    }catch(e){
      return e;
    }

  }
}