

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices{
  //firebase Instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> signUpWithEmailAndPassword (String email, String password) async{

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
         print("Email already exist");
      }
      else{
       print("Successfull");
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword (String email, String password) async{

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword (email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password')  {
       print("User not found or wrong password");
      }
      else{
       print("Successfull");//  displayToast(message: 'Successfully loggedIn');
      }
    }
    return null;
  }

  Future<User?> resetPassword(String email) async{

    try {
      await _auth.sendPasswordResetEmail(email: email);
      
    } on FirebaseAuthException catch (e) {
      if (e.code == '') {
       print("Password successfullly reset");
      }
      else{
       print("Successfull");
      }
    }
    return null;
  }
  
}
