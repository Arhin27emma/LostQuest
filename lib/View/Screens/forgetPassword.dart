// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/Model/Authentication/FirebaseAuth.dart';
import 'package:lost_and_found/View/Components/button.dart';
import 'package:lost_and_found/View/Screens/sign_In.dart';
import 'package:lost_and_found/View/Screens/sign_up.dart';


class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});
  static String routeName = "forgetPassword.dart";

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

bool remember = false;

class _ForgetPasswordState extends State<ForgetPassword> {

  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void forgetPassword() async{
    String email = _emailController.text.trim();
    if(email.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Reset Password Error',
          message: 'Try again',
          contentType: ContentType.failure,
        ),
      ),);
    }
    else{
      await _auth.resetPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: 'Reset Password',
            message: 'Check your email for instructions',
            contentType: ContentType.success,
          ),
        ),
      );
      Navigator.pushNamed(context,  SignIn.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.redAccent,
        
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage("assets/images/onboardingImage1.jpg",),
                          
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("LostQuest", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                              width: 1000,
                              height: 700,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Forgot Password!",
                                          style: TextStyle(
                                              fontSize: 28,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 20,),
                                        const Text(
                                          "Please enter your email address to get a link to reset your password",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                        ),
                                        const SizedBox(height: 30,),
                                        TextFormField(
                                          controller: _emailController,
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                            labelText: "Email",
                                            hintText: "Enter Email",
                                            hintStyle: TextStyle(color: Colors.black26),
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            suffixIcon: Icon(Icons.email_outlined),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              borderSide: BorderSide(
                                                color: Colors.red
                                              )
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              borderSide: BorderSide(color: Colors.black26)
                                            )
                                          ),
                                        ),
                                        const SizedBox(height: 30,),
                                        DefaultButton(text: "Reset", press: forgetPassword),
                                        const SizedBox(height: 30,),
                                         Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Text("Don't have an account? ", style: TextStyle(fontSize: 15,)),
                                            GestureDetector(
                                              onTap: () => Navigator.pushNamed(context, SignUp.routeName),
                                              child: const Text("Sign up", style: TextStyle(fontSize: 15, color: Colors.red),)),
                                          ],
                                        ),
                                      ]
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
