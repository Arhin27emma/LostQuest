import 'package:flutter/material.dart';
import 'package:lost_and_found/View/Components/button.dart';
import 'package:lost_and_found/View/Screens/foundPost.dart';
import 'package:lost_and_found/View/Screens/lostPost.dart';
import 'package:lost_and_found/View/Screens/pageview.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});
  static String routeName = "./addPost.dart";

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pushNamed(context, PageScreen.routeName), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 25,)),
        title: const Text("ADD POST", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.indigo),),
        titleSpacing: 70,
      ),
       body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 18, right: 18),
          child: Center(
            child: Column(
              children: [
                const Text("Select Post To Report An Item", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                const SizedBox(height: 40,),
                DefaultButton(text: "Lost Post", press: () {
                  Navigator.pushNamed(context, LostPost.routeName);
                }),
                const SizedBox(height: 25,),
                DefaultButton(text: "Found Post", press: () {
                  Navigator.pushNamed(context, FoundPost.routeName);
                }),
              ],
            ),
          ),
        )
      ),
    );
  }
}