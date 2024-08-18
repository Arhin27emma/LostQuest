// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:lost_and_found/Global/common/toast.dart';
import 'package:lost_and_found/Model/Authentication/FirebaseAuth.dart';
import 'package:lost_and_found/View/Components/button.dart';
import 'package:lost_and_found/View/Screens/forgetPassword.dart';
import 'package:lost_and_found/View/Screens/pageview.dart';
import 'package:lost_and_found/View/Screens/sign_up.dart';
import 'package:lost_and_found/Model/Authentication/googleAuth.dart';
import 'package:sign_in_button/sign_in_button.dart';
//import 'package:lost_and_found/View/Screens/test.dart';


class SignIn extends StatefulWidget {
  const SignIn({super.key});
  static String routeName = "sign_In.dart";

  @override
  State<SignIn> createState() => _SignInState();
}

bool remember = false;

class _SignInState extends State<SignIn> {

  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void clear(){
    _emailController.clear();
    _passwordController.clear();
  }

  void signIn() async{
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      clear();
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Success',
          message: 'Successfully signed in',
          contentType: ContentType.success,
        ),
      ),);
      Navigator.pushNamed(context,  PageScreen.routeName);
    }
    else{
     clear();
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Unsuccessful',
          message: 'Error signing in. All fields required',
          contentType: ContentType.failure,
        ),
      ),);
    }
  }

  @override
  void dispose(){
      _emailController.dispose();
      _passwordController.dispose();
    super.dispose();
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
                  SingleChildScrollView(
                    child: Form(
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            child: Container(
                                width: 1000,
                                height: 800,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                    color: Colors.white),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            const Text(
                                              "Welcome Back!",
                                              style: TextStyle(
                                                  fontSize: 28,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
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
                                            TextFormField(
                                              controller: _passwordController,
                                              keyboardType: TextInputType.visiblePassword,
                                              obscureText: true,
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                                labelText: "Password",
                                                
                                                hintText: "Enter Password",
                                                hintStyle: TextStyle(color: Colors.black26),
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                suffixIcon: Icon(Icons.lock_outline),
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
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: remember, 
                                                  onChanged: (value) => {
                                                    setState(() {
                                                      remember = value!;
                                                    }),
                                                }),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text("Remember me ", style: TextStyle(fontSize: 15,)),
                                                    const SizedBox(width: 30,),
                                                    GestureDetector(
                                                      onTap: () => Navigator.pushNamed(context, ForgetPassword.routeName),
                                                      child: const Text("Forget Password? ", style: TextStyle(fontSize: 15, color: Colors.red),),)
                                                  ],
                                                ),
                                        
                                              ],
                                            ),
                                            const SizedBox(height: 20,),
                                            DefaultButton(text: "Sign In", press: signIn),
                                            const SizedBox(height: 30,),
                                            const Text("-------------- Sign in with -----------", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                            const SizedBox(height: 20,),

                                            SignInButton(
                                              Buttons.google,
                                              text: "Sign in with Google",
                                              onPressed: () {
                                                GoogleAuth().signInWithGoogle();
                                              },
                                            ),                        
                                            
                                            const SizedBox(height: 18,),
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
                                            //const SizedBox(width: 30,),
                                              
                                          ],
                                        
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
