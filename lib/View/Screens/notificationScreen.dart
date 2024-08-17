import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget{
  const NotificationScreen({Key? key}) : super(key:key);
  static String routeName = 'notificationScreen.dart';
  
  @override
  Widget build(BuildContext context) {
    //final message = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notification'),
        backgroundColor: Colors.black54,
      ),
      body: Center(
        child: Column(
          children: [
          
          
          ]
        ),
      )
    );
  }
}

