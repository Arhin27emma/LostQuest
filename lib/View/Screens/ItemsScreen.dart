// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/Model/Authentication/DatabaseServices.dart';
import 'package:lost_and_found/Model/Authentication/ItemModel.dart';
import 'package:lost_and_found/View/Screens/editPost.dart';
import 'package:lost_and_found/View/Screens/pageview.dart';

class MyItems extends StatefulWidget {
  const MyItems({super.key});
  static String routeName = "itemsScreen.dart";

  @override
  State<MyItems> createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> with SingleTickerProviderStateMixin {
  final DatabaseService _databaseService = DatabaseService();

  List<ItemModel> lostItems = [];
  List<ItemModel> foundItems = [];

  bool isLoading = true;

  late final TabController _tabController;

  var email = _auth.currentUser?.email ?? '';
  static final FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  void initState() {
    super.initState();
    fetchItems();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchItems() async {
    try {
      List<ItemModel> items = await _databaseService.getItems();
      setState(() {
        lostItems = items.where((item) => item.type == 'lost' && item.email == email).toList();
        foundItems = items.where((item) => item.type == 'found' && item.email == email).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error retrieving data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color.fromARGB(255, 252, 243, 243),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pushNamed(context, PageScreen.routeName),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 25,
            )),
        title: const Text(
          "MY ITEMS",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        titleSpacing: 70,
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.red,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            tabs: const [
              Tab(
                child: Text("Lost Items",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ),
              Tab(
                child: Text("Found Items",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              )
            ]),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                ItemListBuilder(items: lostItems),
                ItemListBuilder(items: foundItems),
              ],
            ),
    );
  }
}

class ItemListBuilder extends StatelessWidget {
  const ItemListBuilder({
    super.key,
    required this.items,
  });

  final List<ItemModel> items;

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? const Center(child: Text('No items found.'))
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return ItemBuilder( 
                id: item.id,
                name: item.name,
                location: item.location,
                date: item.date,
                image: item.imageUrl,
                category: item.category,
                description: item.description,
              );
              
            },
          );
  }
}

class ItemBuilder extends StatelessWidget {
  const ItemBuilder({
    super.key,
    required this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.image,
    required this.category,
    required this.description,
  });
  final String id;
  final String name;
  final String location;
  final String date;
  final String image;
  final String category;
  final String description;



  void showDeleteConfirmationDialog(BuildContext context) {
    final CollectionReference _itemsCollection = FirebaseFirestore.instance.collection("AddPostDB");
    Future<void> deleteItem() async {
      try {
        await _itemsCollection.doc(id).delete();
      } catch (e) {
        throw Exception("Error deleting item: $e");
      }
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Item", style: TextStyle(color: Colors.red),),
          content: const Text("Are you sure you want to delete this item?",  style: TextStyle(color: Colors.red)),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text("Delete",  style: TextStyle(color: Colors.red)),
              onPressed: () async {
                try {
                  await deleteItem();
                 
                  
                } catch (e) {
                  print("Error deleting item: $e");
                } finally {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // Close the dialog after deletion
                }
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(image),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.red,
                    ),
                    Text(
                      location,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.orange),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditPost(name: name, id: id, location: location, dateTime: date, image: image, category: category, description: description,)),
                      ),
                      icon: const Icon(
                        Icons.edit_document,
                        size: 22,
                        color: Colors.blue,
                      )),
                    const SizedBox(width: 10),
                    IconButton(onPressed: (){
                      showDeleteConfirmationDialog(context);
                    }, icon: const Icon(Icons.delete_forever, color: Colors.red,)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
