import 'package:assignment_tripmate/screens/user/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier{

  //SEND MESSAGE
  Future<void> sendMessage(String senderId, String senderName, String receiverId, String receiverName, String message) async{

    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: senderId, 
      senderName: senderName, 
      receiverId: receiverId, 
      receiverName: receiverName, 
      message: message, 
      timestamp: timestamp
    );

    // construct chat room id from current user id and receiver id (stored to ensure uniquness)
    List<String> ids = [senderId, receiverId];
    ids.sort(); // sort the ids (ensures that chat room id always the same for any pair of people)
    String chatRoomId = ids.join('_');

    // add new message to database
    await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());
  }

  //GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    // construct chat room id from user ids (sorted to ensure it matches the id used when sending messages.)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return FirebaseFirestore.instance
           .collection('chat_rooms')
           .doc(chatRoomId)
           .collection('messages')
           .orderBy('timestamp', descending: false)
           .snapshots();

  }

}