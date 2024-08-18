

import 'package:flutter/material.dart';
import 'package:lost_and_found/View/Screens/ItemsScreen.dart';
import 'package:lost_and_found/View/Screens/accountDetails.dart';
//import 'package:lost_and_found/View/Screens/editPost.dart';
import 'package:lost_and_found/View/Screens/foundPost.dart';
import 'package:lost_and_found/View/Screens/addPost.dart';
import 'package:lost_and_found/View/Screens/lostPost.dart';
import 'package:lost_and_found/View/Screens/notificationScreen.dart';
import 'package:lost_and_found/View/Screens/pageview.dart';
//import 'package:lost_and_found/View/Components/OTPForms.dart';
import 'package:lost_and_found/View/Screens/phoneScreen.dart';
import 'package:lost_and_found/View/Screens/homeScreen.dart';
import 'package:lost_and_found/View/Screens/setPassword.dart';
import 'package:lost_and_found/View/Screens/sign_up.dart';
import 'package:lost_and_found/View/Screens/splashScreen.dart';
import 'package:lost_and_found/View/Screens/sign_In.dart';
import 'package:lost_and_found/View/Screens/forgetPassword.dart';


final Map<String, WidgetBuilder> routes ={
  SplashScreen.routeName:(context) => const SplashScreen(),
  SignUp.routeName:(context) => const SignUp(),
  SignIn.routeName:(context) => const SignIn(),
  ForgetPassword.routeName:(context) => const ForgetPassword(),
  OTPVerifications.routeName:(context) => const OTPVerifications(),
  Home.routeName:(context) => const Home(),
  PageScreen.routeName:(context) => const PageScreen(),
  AddPost.routeName:(context) => const AddPost(),
  LostPost.routeName:(context) => const LostPost(),
  FoundPost.routeName:(context) => const FoundPost(),
  AccountDetails.routeName:(context) => const AccountDetails(),
  PasswordSet.routeName:(context) => const PasswordSet(),
  MyItems.routeName:(context) => const MyItems(),
  //EditPost.routeName:(context) => const EditPost(),
  //Settings.routeName:(context) => const Settings(),
  NotificationScreen.routeName:(contex) => const NotificationScreen()
};