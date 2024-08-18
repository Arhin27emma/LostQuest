// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:lost_and_found/Model/Authentication/ItemModel.dart';
import 'package:lost_and_found/View/Screens/dataDetials.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  
  List<ItemModel> searchResults = [];

  bool isLoading = true;

  void searchItems(String query) async {
    
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    List<ItemModel> allItems = await RetrieveItems().getItems();
    List<ItemModel> filteredResults = allItems.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchResults = filteredResults;
    });
  }



  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBarAnimation(
          textEditingController: searchController,
          isOriginalAnimation: true,
          enableKeyboardFocus: true,
          onExpansionComplete: () {
            debugPrint('Search box opened.');
          },
          onCollapseComplete: () {
            debugPrint('Search box closed.');
          },
          onPressButton: (isSearchBarOpen) {
            if (isSearchBarOpen) {
              searchItems(searchController.text);
            }
            debugPrint('Search button pressed.');
          },
          onChanged: (text) {
            searchItems(text);
          },
          onFieldSubmitted: (text) {
            searchItems(text);
          },
          
          trailingWidget: const Icon(
            Icons.search,
            size: 20,
            color: Colors.black,
          ),
          secondaryButtonWidget: const Icon(
            Icons.close,
            size: 20,
            color: Colors.black,
          ),
          buttonWidget: const Icon(
            Icons.search,
            size: 20,
            color: Colors.black,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.red),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 135, 133, 132),
        elevation: 0.0,
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        ItemModel item = searchResults[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Datadetail(item: item)));
          },
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
                    backgroundImage: item.imageUrl.isNotEmpty
                        ? NetworkImage(item.imageUrl)
                        : const AssetImage("assets/images/onboardingImage2.jpg") as ImageProvider,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: Colors.red,
                          ),
                          Text(item.location, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(item.date, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      const Text(
                        "View Details",
                        style: TextStyle(fontSize: 18, color: Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
