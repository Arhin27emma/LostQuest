
// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:lost_and_found/Global/common/toast.dart';
import 'package:lost_and_found/Model/Authentication/FirebaseAuth.dart';
import 'package:lost_and_found/View/Components/button.dart';
import 'package:lost_and_found/View/Screens/pageview.dart';
//import 'package:lost_and_found/View/Screens/phoneScreen.dart';
import 'package:lost_and_found/View/Screens/sign_In.dart';
import 'package:lost_and_found/Model/Authentication/googleAuth.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:lost_and_found/Model/Authentication/accountDetailsAuth.dart';
import 'package:sign_in_button/sign_in_button.dart';



class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static String routeName = "sign_up.dart";

  @override
  State<SignUp> createState() => _SignUpState();
}

bool remember = false;

class _SignUpState extends State<SignUp> {

  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _username = TextEditingController();

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _username.dispose();
    super.dispose();
  }

  void clear(){
    _emailController.clear();
    _passwordController.clear();
    _username.clear();
  }



  void signUp() async{

    final AccountDetailsAuth accountDetails = AccountDetailsAuth();
    
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    accountDetails.nameDetails(_username.text.trim());

    if (user != null) {
      clear();
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Success',
          message: 'Successfully signed up',
          contentType: ContentType.success,
        ),
      ),);
      Navigator.pushNamed(context,  PageScreen.routeName);
    }
    else{
     // showToast(message: "All Fields required");
      clear();
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Unsuccessful',
          message: 'Error signing up. All fields required',
          contentType: ContentType.failure,
        ),
      ),
    );
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
                  SingleChildScrollView(
                    child: Form(
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            child: Container(
                                width: 1000,
                                height: 850,
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
                                              "Create An Account",
                                              style: TextStyle(
                                                  fontSize: 28,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 30,),
                                            TextFormField(
                                              controller: _username,
                                              keyboardType: TextInputType.name,
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                                labelText: "Full Name",
                                                hintText: "Enter Full Name",
                                                hintStyle: TextStyle(color: Colors.black26),
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                suffixIcon: Icon(Icons.people_alt_outlined),
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
                                                //const SizedBox(width: 20,),
                                                const Text("I agree to the processing of ", style: TextStyle(fontSize: 12,)),
                                                //const SizedBox(width: 30,),
                                               const Text("Personal data ", style: TextStyle(fontSize: 15, color: Colors.red),),
                                              ],
                                            ),
                                            const SizedBox(height: 20,),
                                            DefaultButton(text: "Sign up", press: signUp),
                                            const SizedBox(height: 30,),
                                            const Text("-------------- Sign up with -----------", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                            const SizedBox(height: 20,),
                                            SignInButton(
                                              Buttons.google,
                                              text: "Sign up with Google",
                                              onPressed: () {
                                                GoogleAuth().signInWithGoogle();
                                              },
                                            ),
                                            const SizedBox(height: 18,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Text("Already have an account? ", style: TextStyle(fontSize: 15,)),
                                                GestureDetector(
                                                  onTap: () => Navigator.pushNamed(context, SignIn.routeName),
                                                  child: const Text("Sign in", style: TextStyle(fontSize: 15, color: Colors.red),)),
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
