// ignore_for_file: non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/Model/Authentication/DatabaseServices.dart';
import 'package:lost_and_found/Model/Authentication/ItemModel.dart';
import 'package:lost_and_found/View/Screens/dataDetials.dart';
import 'package:lost_and_found/View/Screens/searchScreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static String routeName = "homeScreen.dart";
  

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  final ProfileService _profileService = ProfileService();

  List<ItemModel> _items = [];
  bool isLoading = true;
  String? imageUrl;
  String selectedCategory = 'All Data';

  @override
  void initState() {
    super.initState();
    fetchAllItems();
    fetchProfile();
  }

  Future<void> fetchAllItems() async {
    try {
      List<ItemModel> items = await _databaseService.getItems();
      setState(() {
        _items = items;
        isLoading = false;
      });
    } catch (e) {
      print("Error retrieving data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchProfile() async {
    var email = _auth.currentUser!.email;
    try {
      String image = await _profileService.getProfileImageUrl(email.toString());
      setState(() {
        imageUrl = image;
      });
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  List<ItemModel> filterItemsByCategory(String category) {
    if (category == 'All Data') {
      return _items;
    }
    return _items.where((item) => item.category == category).toList();
  }

  List<ItemModel> filterItemsByType(String type) {
    if (type == 'lost') {
      return _items;
    }
    return _items.where((item) => item.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<ItemModel> filteredItems = filterItemsByCategory(selectedCategory);
    return Scaffold(
      backgroundColor: Colors.red,
      extendBody: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: imageUrl != null
                ? NetworkImage(imageUrl.toString())
                : const AssetImage("assets/images/onboardingImage1.jpg")
                    as ImageProvider,
          ),
        ),
        backgroundColor: Colors.red,
        title: const Text(
          'LostQuest',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          const Icon(Icons.notifications_active_outlined, color: Colors.white),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.location_on_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen())),
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CategoryItems(
                                data: "All Data",
                                onTap: () {
                                  setState(() {
                                    selectedCategory = 'All Data';
                                  });
                                },
                                isSelected: selectedCategory == 'All Data',
                              ),
                              const SizedBox(width: 10),
                              CategoryItems(
                                data: "Electronics",
                                onTap: () {
                                  setState(() {
                                    selectedCategory = 'Electronics';
                                  });
                                },
                                isSelected: selectedCategory == 'Electronics',
                              ),
                              const SizedBox(width: 10),
                              CategoryItems(
                                data: "Jewelries",
                                onTap: () {
                                  setState(() {
                                    selectedCategory = 'Jewelries';
                                  });
                                },
                                isSelected: selectedCategory == 'Jewelries',
                              ),
                              const SizedBox(width: 10),
                              CategoryItems(
                                data: "Bags",
                                onTap: () {
                                  setState(() {
                                    selectedCategory = 'Bags';
                                  });
                                },
                                isSelected: selectedCategory == 'Bags',
                              ),
                              const SizedBox(width: 10),
                              CategoryItems(
                                data: "Student Id",
                                onTap: () {
                                  setState(() {
                                    selectedCategory = 'Student Id';
                                  });
                                },
                                isSelected: selectedCategory == 'Student Id',
                              ),
                              const SizedBox(width: 10),
                              CategoryItems(
                                data: "Watch",
                                onTap: () {
                                  setState(() {
                                    selectedCategory = 'Watch';
                                  });
                                },
                                isSelected: selectedCategory == 'Watch',
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            CategoryItems(
                              data: "Lost",
                              onTap: () {
                                
                              },
                              isSelected: selectedCategory == 'Lost',
                            ),
                            const SizedBox(width: 10),
                            CategoryItems(
                              data: "Found",
                              onTap: () {
                                
                              },
                              isSelected: selectedCategory == 'Found',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 130, left: 20),
                child: Text(
                  "All LostQuest Items",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : filteredItems.isEmpty
                      ? Center(
                          child: Text(
                            'No $selectedCategory to display',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 180),
                          child: ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final model = filteredItems[index];
                              return BuildItemCard(context, model);
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector BuildItemCard(BuildContext context, ItemModel model) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => Datadetail(item: model))),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, left: 8, right: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 252, 243, 243),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: model.imageUrl.isNotEmpty
                    ? NetworkImage(model.imageUrl)
                    : const AssetImage("assets/images/onboardingImage2.jpg")
                        as ImageProvider,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
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
                      Text(model.location,
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(model.date, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  const Text("View Details",
                      style: TextStyle(fontSize: 18, color: Colors.orange)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItems extends StatelessWidget {
  final String data;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryItems(
      {super.key,
      required this.data,
      required this.onTap,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.transparent,
          border: Border.all(color: Colors.red), // Add red border
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          data,
          style: TextStyle(
              fontSize: 16, color: isSelected ? Colors.white : Colors.red),
        ),
      ),
    );
  }
}
