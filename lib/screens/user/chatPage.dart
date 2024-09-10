import 'package:assignment_tripmate/screens/user/chatDetailsPage.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userId;

  const ChatScreen({super.key, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageList> _MessageList = [];
  List<MessageList> _foundedMessageList = [];
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    // fetchMessageList();
  }

  Future<void> fetchMessageList() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Fetch all chat_rooms where the document ID contains widget.userId
      CollectionReference chatRef = FirebaseFirestore.instance.collection('chat_rooms');
      QuerySnapshot chatRoomsSnapshot = await chatRef.get();
      
      // Print the document IDs to verify they are being fetched
      for (var doc in chatRoomsSnapshot.docs) {
        print('Document ID: ${doc.id}');
      }
      
      // // Filter chat rooms where the document ID contains the current user ID as sender or receiver
      // List<DocumentSnapshot> filteredChatRooms = chatRoomsSnapshot.docs.where((doc) {
      //   String docId = doc.id.trim(); // Ensure no leading/trailing spaces
      //   List<String> ids = docId.split('_').map((id) => id.trim()).toList(); // Split by '_' and trim any spaces
      //   return ids.contains(widget.userId.trim()); // Check if one of the IDs matches the user ID
      // }).toList();

      // print(filteredChatRooms);

      // // Iterate over filtered chat rooms and fetch messages
      // for (var chatRoom in filteredChatRooms) {
      //   CollectionReference messagesRef = chatRoom.reference.collection('messages');
      //   QuerySnapshot messagesSnapshot = await messagesRef.orderBy('timestamp').get();

      //   for (var messageDoc in messagesSnapshot.docs) {
      //     String receiverId = messageDoc['receiverId'];

      //     DocumentSnapshot userSnapshot;

      //     // Fetch user profile based on the receiverId type (User, Travel Agent, Admin)
      //     if (receiverId.startsWith('U')) {
      //       userSnapshot = await FirebaseFirestore.instance
      //           .collection('users')
      //           .doc(receiverId)
      //           .get();
      //     } else if (receiverId.startsWith('TA')) {
      //       userSnapshot = await FirebaseFirestore.instance
      //           .collection('travelAgent')
      //           .doc(receiverId)
      //           .get();
      //     } else if (receiverId.startsWith('A')) {
      //       userSnapshot = await FirebaseFirestore.instance
      //           .collection('admin')
      //           .doc(receiverId)
      //           .get();
      //     } else {
      //       continue; // Skip if no valid collection is found
      //     }

      //     // If the user profile exists, extract profile image and message details
      //     if (userSnapshot.exists) {
      //       var userData = userSnapshot.data() as Map<String, dynamic>;
      //       String receiverProfile = userData['profileImage'];
      //       String receiverName = userData['name']; // Assuming the user's name field exists

      //       // Add the message along with the receiver's profile to the list
      //       _MessageList.add(
      //         MessageList(
      //           receiverName,
      //           receiverProfile,
      //           receiverId,
      //           messageDoc['message']
      //         ),
      //       );
      //     }
      //   }
      // }

      // Update UI after fetching the data
      setState(() {
        _foundedMessageList = _MessageList;
        isLoading = false;
      });

    } catch (e) {
      print("Error fetching messages: $e");
    }
  }

  void onSearch(String search) {
    setState(() {
      _foundedMessageList = _MessageList.where((MessageList) => MessageList.receiverName.toUpperCase().contains(search.toUpperCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
                child: Container(
                  height: 60,
                  child: TextField(
                    onChanged: (value) => onSearch(value),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2), 
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2), 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFF467BA1), width: 2), 
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red, width: 2), 
                      ),
                      hintText: "Search chat...",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              ElevatedButton(onPressed: fetchMessageList, child: Text("Fetch")),

              isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded( // Ensures the ListView takes up the available space
                  child: Padding(
                    padding: EdgeInsets.only(right: 10, left: 15), // Adjust padding
                    child: ListView.builder(
                      itemCount: _foundedMessageList.length,
                      itemBuilder: (context, index) {
                        return messageListComponent(messageList: _foundedMessageList[index]);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget messageListComponent({required MessageList messageList}){
    return Container(
      padding: EdgeInsets.only(top:10, bottom:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF467BA1), 
                    width: 2.0, 
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(messageList.receiverProfile),
                ),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(messageList.receiverName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14)),
                  SizedBox(height: 5,),
                  Text(messageList.latestMessage, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12))
                ],
              )
            ],
          )
        ],
      ),
    );
  }



}