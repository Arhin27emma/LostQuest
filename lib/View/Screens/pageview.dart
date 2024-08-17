import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lost_and_found/View/Screens/ItemsScreen.dart';
import 'package:lost_and_found/View/Screens/addPost.dart';
import 'package:lost_and_found/View/Screens/homeScreen.dart';
import 'package:lost_and_found/View/Screens/settings.dart';


class PageScreen extends StatefulWidget {
  const PageScreen({super.key});
  static String routeName = "pageview.dart";

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  int  _selectIndex = 0;

  final screenPage = [
    const Home(),
    const AddPost(),
    const MyItems(),
    const Settings()
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: screenPage[_selectIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: GNav(
            tabMargin: const EdgeInsets.all(20),
            gap: 4,
            color: Colors.white,
            activeColor: Colors.white,
            backgroundColor: Colors.black,
            tabBackgroundColor: Colors.red,
            padding: const EdgeInsets.all(2),
          tabs: const [
            GButton(icon: Icons.home, text: "Home", iconSize: 25,),
            GButton(icon: Icons.add_circle_outline, text: "Add Post",iconSize: 27, ),
            GButton(icon: Icons.list_alt_outlined, text: "Items", iconSize: 25,),
            GButton(icon: Icons.settings, text: "Settings", iconSize: 25)
          ],
          selectedIndex: _selectIndex,
          onTabChange: (index){
            setState(() {
              _selectIndex = index;
            });
          },
              ),
        ),
      ),
    );
  }
}