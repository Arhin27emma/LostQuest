// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lost_and_found/View/Screens/pageview.dart';
import 'package:lost_and_found/View/Screens/sign_In.dart';
import 'package:lost_and_found/View/Screens/sign_up.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static String routeName = "spalshScreen";

  /*void initState() {
    Future.delayed(Duration(seconds: 2), () {
      checkUserAuthentication(context);
    });
  }*/

  void checkUserAuthentication(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, PageScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, SignIn.routeName);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.orange,
      //appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 50),
            child: Image.asset("assets/images/onboardingImage2.jpg"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 430),
            child: Center(
                child: Column(
              children: [
                const Text(
                  "Welcome To",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                AnimatedTextKit(totalRepeatCount: 5, animatedTexts: [
                  TypewriterAnimatedText("Lost And Found",
                      speed: Duration(milliseconds: 300),
                      textStyle: TextStyle(
                          fontSize: 35,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ]),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                  child: const Text(
                    "Enter personal details to your Lost And Found account to get started",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                    
                  ),
                ),
              ],
            ),
            
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, SignIn.routeName),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Text("Sign In", style: TextStyle(fontSize: 23, color: Colors.red, fontWeight: FontWeight.bold),),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, SignUp.routeName),
                      child: Container(
                        height: 60,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20))
                        ),
                        child: Center(child: Text("Sign Up", style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),)),
                      ),
                    )
                  ],
                ),
              
              ],
            ),
          )
        ],
      ),
    );
  }
}
