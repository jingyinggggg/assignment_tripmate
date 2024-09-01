import 'dart:typed_data';

import 'package:assignment_tripmate/chat_bubble.dart';
import 'package:assignment_tripmate/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String userId;
  final String receiverUserId;

  const ChatDetailsScreen({super.key, required this.userId, required this.receiverUserId});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController(); 

  String? senderName;
  String? receiverName;
  Uint8List? senderProfileImage;
  Uint8List? receiverProfileImage;

  @override
  void initState() {
    super.initState();
    fetchSenderDetails();
    fetchReceiverDetails();
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.userId,
        senderName!,
        widget.receiverUserId,
        receiverName!,
        _messageController.text
      );
      _messageController.clear();
    }
  }

  Future<void> fetchSenderDetails() async {
    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: widget.userId)
        .limit(1)
        .get();
      
      DocumentSnapshot userDoc = userQuery.docs.first;
      var senderData = userDoc.data() as Map<String, dynamic>;

      setState(() {
        senderName = senderData['name'];
        // senderProfileImage = senderData['profileImage'];
      });
    } catch (e) {
      print("Error fetching sender details: $e");
    }
  }

  Future<void> fetchReceiverDetails() async {
    try {
      QuerySnapshot userQuery;

      if (widget.receiverUserId.startsWith('U')) {
        // Search in 'users' collection
        userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: widget.receiverUserId)
            .limit(1)
            .get();
      } else if (widget.receiverUserId.startsWith('TA')) {
        // Search in 'travelAgent' collection
        userQuery = await FirebaseFirestore.instance
            .collection('travelAgent')
            .where('id', isEqualTo: widget.receiverUserId)
            .limit(1)
            .get();
      } else {
        // Search in 'admin' collection
        userQuery = await FirebaseFirestore.instance
            .collection('admin')
            .where('id', isEqualTo: widget.receiverUserId)
            .limit(1)
            .get();
      }

      if (userQuery.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userQuery.docs.first;
        var receiverData = userDoc.data() as Map<String, dynamic>;

        setState(() {
          receiverName = receiverData['name'];
          // receiverProfileImage = receiverData['profileImage'];
        });
      } else {
        print("No user found with the given ID.");
      }
    } catch (e) {
      print("Error fetching receiver details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(right: 20.0), // Add padding to the right of the back arrow
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Row(
          children: [
            // Image widget
            // CircleAvatar(
            //   radius: 20, // Adjust size as needed
            //   backgroundImage: NetworkImage('URL_OF_THE_IMAGE'), // Replace with the actual image URL
            //   backgroundColor: Colors.transparent,
            // ),
            const SizedBox(width: 10), // Space between image and name
            // Name text
            Text(
              receiverName ?? '', // Use empty string as fallback if receiverName is null
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),

      body: Column(
        children: [
          // messages
          Expanded(
            child: _buildMessageList(),
          ),
          // user input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverUserId, widget.userId), 
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ' + snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages to the right of the sender is the current user, otherwise to the left
    var alignment = (data['senderId'] == widget.userId) 
        ? Alignment.centerRight 
        : Alignment.centerLeft;
    
    return Container(
      alignment: alignment,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: (data['senderId'] == widget.userId) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment: (data['senderId'] == widget.userId) ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Text(data['senderId'] == widget.userId ? 'You' : data['senderName']),
          SizedBox(height: 5),
          ChatBubble(message: data['message']),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: TextField(
        controller: _messageController,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Enter message ...',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF467BA1),
              width: 2.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF467BA1),
              width: 2.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF467BA1),
              width: 2.5,
            ),
          ),
          suffixIcon: IconButton(
            onPressed: sendMessage, 
            icon: ImageIcon(AssetImage('images/send.png'), size: 25, color: Color(0xFF467BA1),)
          ),
        ),
      ),
    );
  }
}
