import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/Model/Authentication/ItemModel.dart';
//import 'package:lost_and_found/Model/Authentication/databaseServices.dart';
import 'package:lost_and_found/View/Components/button.dart';
import 'package:lost_and_found/View/Screens/chatScreen.dart';
import 'package:url_launcher/url_launcher.dart';


class Datadetail extends StatefulWidget {
  final ItemModel item;

  const Datadetail({super.key, required this.item});
  static String routeName = "dataDetails.dart";

  @override
  State<Datadetail> createState() => _DatadetailState();
}

class _DatadetailState extends State<Datadetail> {
  late ItemModel item;
  @override
  void initState() {
    super.initState();
    item = widget.item;
    getPhoneNumber();
  }
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  String email = _auth.currentUser?.email?? "";
  String? phonenumber;

  String generateChatId(String email1, String email2) {
    if (email1.compareTo(email2) > 0) {
      return '$email2-$email1';
    } else {
      return '$email1-$email2';
    }
  }

  String formatPhoneNumber(String number) {
    if (number.startsWith('0')) {
      return '+233${number.substring(1)}'; 
    }
    return number;
  }

  void makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
      throw 'Phone number launched successfully: $phoneNumber';
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> getPhoneNumber() async {
    try {
      DocumentSnapshot userDoc = await _db.collection('ProfileDetails').doc(_auth.currentUser!.email).get();
      setState(() {
        phonenumber = userDoc['phone'];
      });
;
    } catch (e) {
      print('Error retrieving phone number: $e');
    }
  }


  void _handleCall() {
    

    String phoneNumber = formatPhoneNumber(phonenumber.toString());
    if (phoneNumber.isNotEmpty) {
      String formattedPhoneNumber = formatPhoneNumber(phoneNumber);
      makePhoneCall(formattedPhoneNumber);
    } else {
      showProfileUpdateAlert();
    }
  }

  void showProfileUpdateAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Phone Number Not Set"),
          content: const Text("Please update your profile with a phone number to make calls."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DETAIL INFORMATION",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        titleSpacing: 35,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  width: 600,
                  height: 300,
                  decoration: BoxDecoration(
                    image: item.imageUrl.isNotEmpty
                        ? DecorationImage(image: NetworkImage(item.imageUrl), fit: BoxFit.cover)
                        : const DecorationImage(image: AssetImage("assets/images/onboardingImage2.jpg"), fit: BoxFit.cover),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Container(
                width: 600,
                height: 400,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 245, 243, 252),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Description",
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        item.description,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: Colors.red, size: 20),
                          Text(
                            item.location,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.orange,
                            ),
                            child: Text(
                              item.type,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          const Text("---", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                          Text(
                            item.date,
                            style: const TextStyle(fontSize: 18, color: Colors.orange),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 140, child: DefaultButton(text: "Message", press: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                              chatId: generateChatId(email, item.email), 
                              senderEmail: email, 
                              receiverEmail: item.email)));
                          })),
                          SizedBox(width: 140, child: DefaultButton(text: "Call", press: () {_handleCall();})),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
