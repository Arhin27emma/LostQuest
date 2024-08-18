// ignore_for_file: file_names

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AccountDetailsAuth {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> updateProfile(String imageUrl) async{
    try {
      await _firestore.collection('ProfileDetails').doc(_auth.currentUser!.email).set({
        'image':imageUrl,
      });
      print("Saved successfully");
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  Future<void> nameDetails(String name) async{
    try {
      await _firestore.collection('ProfileDetails').doc(_auth.currentUser!.email).set({
        'name':name,
      });
      print("Saved successfully");
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  Future<String> getName(String name) async{
    final FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      DocumentSnapshot doc = await db.collection("ProfileDetails").doc(_auth.currentUser!.email).get();
      return doc['name'];
    } catch (e) {
      throw Exception('Error fetching profile name: $e');
    }
  }

  Future<void> updateDetails(String name, String phone, String contact) async{
    try {
      await _firestore.collection('ProfileDetails').doc(_auth.currentUser!.email).update({
        'name':name,
        'phone':phone,
        'contact':contact,
      });
      print("Saved successfully");
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      await _auth.currentUser!.updateEmail(newEmail);
    } catch (e) {
      //showToast(message: 'Email update is unsuccessful');
      print('Error updating email: $e');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
    } catch (e) {
      //showToast(message: 'Password update is unsuccessful');
      print('Error updating password: $e');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }


  Future<void> deleteUser() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      await _auth.currentUser?.delete();
    }
  }



  Future<XFile?> pickProfileImage() async {
    ImagePicker imagePicker = ImagePicker();
    return await imagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<String> uploadProfile(XFile image) async {
    String userEmail = _auth.currentUser!.email!;

    String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = FirebaseStorage.instance.ref();
    Reference referenceDirImages = reference.child('images').child(userEmail);

    Reference uploadProfileToReference = referenceDirImages.child(uniqueFilename);

    try {
      // Upload the image file
      await uploadProfileToReference.putFile(File(image.path));

      // Get the download URL of the uploaded image
      String downloadURL = await uploadProfileToReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("$e");
      return '$e';
    }
  }
}