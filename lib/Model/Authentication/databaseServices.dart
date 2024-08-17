import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_and_found/Model/Authentication/ItemModel.dart';


class DatabaseService {
  final CollectionReference _itemsCollection = FirebaseFirestore.instance.collection("AddPostDB");
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addItem(ItemModel item) async {
    try {
      await _itemsCollection.doc(item.id).set(item.toMap());
      print("Saved successfully");
    } catch (e) {
      print("Error storing data: $e");
    }
  }

  Future<void> updateItem(ItemModel item) async {
    try {
      await _itemsCollection.doc(item.id).update(item.toMap());
      print("Updated successfully");
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  Future<void> deleteItem(ItemModel item) async {
    try {
      await _itemsCollection.doc(item.id).delete();
    } catch (e) {
      throw Exception("Error deleting item: $e");
    }
  }

  Future<List<ItemModel>> getItems() async {
    List<ItemModel> itemsList = [];
    try {
      QuerySnapshot<Map<String, dynamic>> itemsSnapshot = await _itemsCollection.get() as QuerySnapshot<Map<String, dynamic>>;
      itemsList.addAll(itemsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return ItemModel.fromMap(data);
      }).toList());
    } catch (e) {
      print("Error: $e");
    }
    print('Total items retrieved: ${itemsList.length}');
    return itemsList;
  }


  Future<XFile?> pickimage() async {
    ImagePicker imagePicker = ImagePicker();
    return await imagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<String> uploadImage(XFile image) async {
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

class ProfileService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getProfileImageUrl(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection("ProfileDetails").doc(userId).get();
      return doc['image'];
    } catch (e) {
      throw Exception('Error fetching profile image: $e');
    }
  }

  Future<void> getPhoneNumber() async {
    try {
      DocumentSnapshot userDoc = await _db.collection('ProfileDetails').doc(_auth.currentUser!.email).get();
      return userDoc['phone'];
    } catch (e) {
      print('Error retrieving phone number: $e');
    }
  }
  
}

