// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_and_found/Model/Authentication/DatabaseServices.dart';
import 'package:lost_and_found/Model/Authentication/ItemModel.dart';
import 'package:lost_and_found/View/Components/button.dart';

class EditPost extends StatefulWidget {
  const EditPost({
    super.key, required this.name, required this.id, required this.location, required this.dateTime, required this.image, required this.category, required this.description  });
  static String routeName = "editPost.dart";
  
  final String id;
  final String name;
  final String description;
  final String location;
  final String dateTime;
  final String image;
  final String category;


  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {


  final _formkey = GlobalKey<FormState>();

  late String dropdownValue = "Electronics";
  late String dropdown = "Administration";
  final _date = TextEditingController();
  DateTime dateTime = DateTime.now();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _id = TextEditingController();

  XFile? selectedImage;

  
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String? userEmail = _auth.currentUser?.email;

  final DatabaseService _databaseService = DatabaseService();

  final String itemType = 'lost';

  @override
  void initState() {
    super.initState();
    _id.text = widget.id;
    _name.text = widget.name;
    dropdownValue = widget.category;
    dropdown = widget.location;
    _date.text = widget.dateTime;
    _description.text = widget.description;
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _date.dispose();
    super.dispose();
  }

  void clear(){
    _name.clear();
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
        title: const Text("EDIT POST", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
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
                  const Center(child: Text("Edit Details To Report Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),)),
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
                        controller: _name,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20, top: 11),
                          suffixIcon: Icon(Icons.person_3_outlined),
                          hintText: "Edit item name",
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
                    child: Text("Date", style: TextStyle(fontSize: 18),),
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
                          hintText: "Edit item description here",
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
                  Center(child: DefaultButton
                  (
                    text: "Publish", press: () async{

                      String imageUrl = '';
                      

                        // If an image is selected, upload it and get the download URL
                      if (selectedImage != null) {
                        imageUrl = await _databaseService.uploadImage(selectedImage!);
                      }

                                          
                      if (dropdownValue.isEmpty || _name.text.trim().isEmpty || dropdown.isEmpty || _date.text.trim().isEmpty || _description.text.trim().isEmpty) {
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
                      if (itemType == 'lost') {
                        _databaseService.updateItem(
                          ItemModel(
                            id: widget.id, 
                            email: userEmail.toString(), 
                            type: itemType, 
                            category: dropdownValue.trim(), 
                            name: _name.text.trim(), 
                            location: dropdown.trim(), 
                            date: _date.text.trim(), 
                            description: _description.text.trim(),
                            imageUrl: imageUrl
                          )
                        ); 
                      } else{
                        _databaseService.updateItem(
                          ItemModel(
                            id: widget.id, 
                            email: userEmail.toString(), 
                            type: itemType, 
                            category: dropdownValue.trim(), 
                            name: _name.text.trim(), 
                            location: dropdown.trim(), 
                            date: _date.text.trim(), 
                            description: _description.text.trim(),
                            imageUrl: imageUrl
                          )
                        ); 
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: AwesomeSnackbarContent(
                            title: 'Success',
                            message: 'Successfully posted',
                            contentType: ContentType.success,
                          ),
                        ),);
                    }
                    clear();
                    
                  })),
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
