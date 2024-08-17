// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_and_found/Model/Authentication/accountDetailsAuth.dart';
import 'package:lost_and_found/View/Components/button.dart';
import 'package:lost_and_found/View/Screens/accountDetails.dart';
import 'package:lost_and_found/View/Screens/pageview.dart';
import 'package:lost_and_found/View/Screens/setPassword.dart';
import 'package:lost_and_found/View/Screens/splashScreen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AccountDetailsAuth _accountAuth = AccountDetailsAuth();
  XFile? _selectedImage;

  String displayName = "Your Name";

  @override
  void initState() {
    super.initState();
    fetchName(displayName); // Replace 'yourUserId' with the actual user ID
  }

  Future<void> fetchName(String userId) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      DocumentSnapshot doc = await db.collection("ProfileDetails").doc(userId).get();
      if (doc.exists && doc.data() != null && doc['name'] != null) {
        setState(() {
          displayName = doc['name'];
        });
      }
    } catch (e) {
      // Handle error (optional)
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, PageScreen.routeName),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 25),
        ),
        title: const Text(
          "PROFILE SETTINGS",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        titleSpacing: 45,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: _selectedImage != null
                        ? FileImage(File(_selectedImage!.path))
                        : const AssetImage("assets/images/onboardingImage2.jpg") as ImageProvider,
                    backgroundColor: Colors.black,
                    child: _selectedImage == null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 135.0, left: 95),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  XFile? pickedFile = await _accountAuth.pickProfileImage();
                                  if (pickedFile != null) {
                                    setState(() {
                                      _selectedImage = pickedFile;
                                    });
                                    try {
                                      String downloadUrl = await _accountAuth.uploadProfile(_selectedImage!);
                                      await _accountAuth.updateProfile(downloadUrl);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: AwesomeSnackbarContent(
                                            title: 'Success',
                                            message: 'Profile updated successfully',
                                            contentType: ContentType.success,
                                          ),
                                        ),);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: AwesomeSnackbarContent(
                                            title: 'Upload failure',
                                            message: 'Failed to upload profile $e',
                                            contentType: ContentType.failure,
                                          ),
                                        ),);
                                    }
                                  } else {
                                    print("Image upload failed");
                                  }
                                },
                                icon: const Icon(Icons.camera_alt_outlined, size: 30, color: Colors.indigo),
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                displayName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                "@Accra Technical University",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AccountDetails.routeName),
                child: const SettingsAccount(
                  text: "Account Details",
                  icon: Icons.person_2_outlined,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, PasswordSet.routeName),
                child: const SettingsAccount(
                  text: "Settings",
                  icon: Icons.settings,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: (){
                  _accountAuth.signOut();
                  Navigator.pushNamed(context, SplashScreen.routeName,);
                },
                child: const SettingsAccount(
                  text: "Sign Out",
                  icon: Icons.logout,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              DefaultButton(text: "Delete Account", press: () {
                _accountAuth.deleteUser();
                Navigator.pushNamed(context, SplashScreen.routeName,);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsAccount extends StatelessWidget {
  const SettingsAccount({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
  });
  final String text;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(width: 10),
            Text(text, style: TextStyle(fontSize: 18, color: color)),
          ],
        ),
      ),
    );
  }
}
