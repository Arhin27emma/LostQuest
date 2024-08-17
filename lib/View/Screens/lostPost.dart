// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_and_found/Model/Authentication/DatabaseServices.dart';
import 'package:lost_and_found/Model/Authentication/ItemModel.dart';
import 'package:lost_and_found/View/Components/button.dart';

class LostPost extends StatefulWidget {
  const LostPost({super.key});
  static String routeName = "./lostPost.dart";

  @override
  State<LostPost> createState() => _LostPostState();
}

class _LostPostState extends State<LostPost> {

  final _formkey = GlobalKey<FormState>();

  late String dropdownValue = "Electronics";
  late String dropdown = "Administration";
  final _date = TextEditingController();
  DateTime dateTime = DateTime.now();
  final _lname = TextEditingController();
  final _description = TextEditingController();

  XFile? selectedImage;

  static final CollectionReference _foundDataCollection = FirebaseFirestore.instance.collection("AddPostDB");
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  late final String id = _foundDataCollection.doc(_auth.currentUser!.email).collection('lostDB').doc().id;
  
  String? userEmail = _auth.currentUser?.email;

  final DatabaseService _databaseService = DatabaseService();

  @override
  void dispose() {
    _lname.dispose();
    _description.dispose();
    _date.dispose();
    super.dispose();
  }

  void clear(){
    _lname.clear();
    _description.clear();
    _date.clear();
    dropdownValue = "select your category";
    dropdown = "select your location";
    selectedImage = null;
  }

  Future<void> sendNotification(String itemName) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: 'New Item Posted!',
        body: 'A new item ($itemName) has been posted.',
        //largeIcon: 'assets/images/logo.png',
        bigPicture: selectedImage != null ? File(selectedImage!.path).toString() : "",
    
      ),
      actionButtons: [
      NotificationActionButton(
        key: 'READ',
        label: 'Read More',
      ),
      NotificationActionButton(
        key: 'CLOSE',
        label: 'Close',
      ),
    ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LOST POST", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
        titleSpacing: 80,
      ),
      body: SafeArea(
        //child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Text("Enter Details To Report Lost Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),)),
                  const SizedBox(height: 30,),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Category", style: TextStyle(fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: DropdownButtonFormField<String>(
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        padding: const EdgeInsets.symmetric(horizontal: 20, ),
                        elevation: 2,
                        //value: dropdownValue,
                        hint: const Text("Select your category"),
                        onChanged: (String? newValue){
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: "Electronics", 
                            child: Text("Electronics"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Jewelries", 
                            child: Text("Jewelries"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Bags", 
                            child: Text("Bags"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Student ID", 
                            child: Text("Students ID"),
                          ),
                          
                          DropdownMenuItem<String>(
                            value: "Watches", 
                            child: Text("Watches"),
                          ),
                          DropdownMenuItem<String>(
                            value:  "Others", 
                            child: Text("Others"),
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 15,bottom: 8),
                    child: Text("Name", style: TextStyle(fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextFormField(
                        controller: _lname,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20, top: 11),
                          suffixIcon: Icon(Icons.person_3_outlined),
                          hintText: "Enter Lost item name",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none
                          )
                        ),
                        
                      ),
                    ),
                  ), 
              
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 25),
                    child: Text("Location", style: TextStyle(fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: DropdownButtonFormField<String>(
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        padding: const EdgeInsets.symmetric(horizontal: 20, ),
                        elevation: 2,
                        //value: dropdownValue,
                        hint: const Text("Select the location"),
                        onChanged: (String? newValuea){
                          setState(() {
                            dropdown = newValuea!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: "Administration", 
                            child: Text("Administration Block"),
                          ),
                          DropdownMenuItem(
                            value: "K - Block", 
                            child: Text("K - Block"),
                          ),
                          DropdownMenuItem(
                            value: "Great Hall", 
                            child: Text("Great Hall"),
                          ),
                          DropdownMenuItem(
                            value: "Fashion Block", 
                            child: Text("Fashion Block"),
                          ),  
                          DropdownMenuItem(
                            value: "Auditorium", 
                            child: Text("Auditorium"),
                          ),
                          DropdownMenuItem(
                            value: "New Hostel", 
                            child: Text("New Hostel"),
                          ),
                          DropdownMenuItem(
                            value: "Old Hostel", 
                            child: Text("Old Hostel"),
                          ),
                        ],
                      ),
                    ),
                  ),
              
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 15, bottom: 6),
                    child: Text("Date Lost", style: TextStyle(fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextFormField(
                        controller: _date,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          suffixIcon: Icon(Icons.date_range_outlined),
                          hintText: "Choose date",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none
                          ),
                        ),
                        onTap: () async{
                          DateTime? pickdate = await showDatePicker(
                            context: context, 
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000), 
                            lastDate: DateTime(2101));
                          if (pickdate != null) {
                            _date.text = pickdate.toString().split(" ")[0];
                          } 
                            
                        },
                        
                      ),
                    ),
                  ),
              
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 18,bottom: 8),
                    child: Text("Description", style: TextStyle(fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      //height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextFormField(
                        controller: _description,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        //maxLength: 50,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20, top: 15),
                          //suffixIcon: Icon(Icons.person_3_outlined),
                          hintText: "Enter lost item description here",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none
                          )
                        ),
                        
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 25,bottom: 8),
                    child: Text("Upload Photos", style: TextStyle(fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            selectedImage = await _databaseService.pickimage();
                            if (selectedImage != null) {
                              setState(() {
                              selectedImage = selectedImage;});
                            }
                          },
                          child: selectedImage != null ? 
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(167, 235, 233, 233),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                
                              ),
                              child: Image.file(File(selectedImage!.path), width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                          )
                          :Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(167, 235, 233, 233),
                              borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: const Center(child: Icon(Icons.add_circle_outlined, size: 40, color: Colors.red,)),
                          )
                        ),
                        const SizedBox(width: 20,),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(167, 235, 233, 233),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: const Center(child: Icon(Icons.add_circle_outlined, size: 40, color: Colors.red,)),
                        ),
                        const SizedBox(width: 20,),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(167, 235, 233, 233),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: const Center(child: Icon(Icons.add_circle_outlined, size: 40, color: Colors.red,)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Center(child: DefaultButton(text: "Publish", press: () async{
                    String lostImageUrl = '';
                    String lost = 'lost';

                        // If an image is selected, upload it and get the download URL
                    if (selectedImage != null) {
                      lostImageUrl = await _databaseService.uploadImage(selectedImage!);
                    }
                    
                    if (dropdownValue.isEmpty || _lname.text.trim().isEmpty || dropdown.isEmpty || _date.text.trim().isEmpty || _description.text.trim().isEmpty || lostImageUrl.isEmpty) {                        
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: AwesomeSnackbarContent(
                          title: 'Required Fields',
                          message: 'Please fill in all fields',
                          contentType: ContentType.failure,
                        ),
                      ),);
                      clear();
                      return;
                      
                      
                    }else{

                      _databaseService.addItem(
                        ItemModel(
                          id: id, 
                          email: userEmail.toString(), 
                          type: lost, 
                          category: dropdownValue.trim(), 
                          name: _lname.text.trim(), 
                          location: dropdown.trim(), 
                          date: _date.text.trim(), 
                          description: _description.text.trim(),
                          imageUrl: lostImageUrl
                        )
                      
                      );
            
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: AwesomeSnackbarContent(
                          title: 'Success',
                          message: 'Successfully posted',
                          contentType: ContentType.success,
                        ),
                      ),);
                      sendNotification(_lname.text.trim());
                    }
                    clear();
                  })
                  ),
                  const SizedBox(height: 50,),
                ],
              ),
            ),
          ),
        //)
      ),
    );
  }
}