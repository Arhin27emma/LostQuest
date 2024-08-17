import 'package:firebase_auth/firebase_auth.dart';


class PhoneAuth {
  
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String verifyId = "";

  static sendOTP({required String phone, required Function errorStep, required Function nextStep}) async{

    await _auth.verifyPhoneNumber(

      phoneNumber: "+233$phone",

      verificationCompleted: (phoneAuthCredential) async{

        return;
      },

      verificationFailed: (FirebaseAuthException e){

        return;
      }, 

      timeout: const Duration(seconds: 30),

      codeSent: (verificationId, resendToken) async{

       verifyId = verificationId;
       nextStep();
      }, 

      codeAutoRetrievalTimeout: (String verificationId) {
        
        return;
      }
    ).onError((error, stackTrace){});
  }


  static Future loginWithOTP({required String OTP}) async{
    final credential = PhoneAuthProvider.credential(verificationId: verifyId, smsCode: OTP);

    try {
      final user = await _auth.signInWithCredential(credential);
      if (user.user!=null) {
        return "Success";
      }
      else{
        return "Error in OTP login";
      }
    } on FirebaseAuthException catch (e){
      return e.message.toString();
    }
    catch(e){
      return e.toString();
    }
    
  }

  static Future logout() async{
    await _auth.signOut();
  }

  static Future<bool> isLogout() async{
    var user = _auth.currentUser;
    return user != null;
  }

}