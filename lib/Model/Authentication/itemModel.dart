import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String email;
  final String type;
  final String category;
  final String name;
  final String location;
  final String date;
  final String description;
  final String imageUrl;

  ItemModel({
    required this.id,
    required this.email,
    required this.type,
    required this.category,
    required this.name,
    required this.location,
    required this.date,
    required this.description,
    required this.imageUrl,
  });

  factory ItemModel.fromMap(Map<String, dynamic> data) {
    return ItemModel(
      id: data['id'],
      email: data['email'],
      type: data['type'],
      category: data['category'],
      name: data['name'],
      location: data['location'],
      date: data['date'],
      description: data['description'],
      imageUrl: data['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'type': type,
      'category': category,
      'name': name,
      'location': location,
      'date': date,
      'description': description,
      'image': imageUrl,
    };
  }
}

class RetrieveItems{
  final CollectionReference _itemsCollection = FirebaseFirestore.instance.collection("AddPostDB");
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
}
