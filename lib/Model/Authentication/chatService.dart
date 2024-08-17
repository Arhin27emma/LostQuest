import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String chatId, String senderEmail, String receiverEmail, String message) async {
    try {
      await _firestore.collection('chats').doc(chatId).collection('messages').add({
        'senderEmail': senderEmail,
        'receiverEmail': receiverEmail,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore.collection('chats').doc(chatId).collection('messages')
      .orderBy('timestamp', descending: false).snapshots();
  }
}
