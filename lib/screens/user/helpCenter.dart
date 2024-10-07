import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/user/chatDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserHelpCenterScreen extends StatefulWidget{
  final String userId;

  const UserHelpCenterScreen({super.key, required this.userId});

  @override
  State<UserHelpCenterScreen> createState() => _UserHelpCenterScreenState();
}

class _UserHelpCenterScreenState extends State<UserHelpCenterScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Help Center"),
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: defaultAppBarTitleFontSize,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You got a problem?',
                style: TextStyle(
                  fontSize: defaultLabelFontSize,
                  fontWeight: FontWeight.w900,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Don't worry! We will help you solve the problem.",
                style: TextStyle(
                  fontSize: defaultFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.center, // Center the search bar
                child: Container(
                  height: 60,
                  child: TextField(
                    // onChanged: (value) => onSearch(value),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20,),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF467BA1), width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red, width: 2),
                      ),
                      hintText: "Search for topic or question...",
                      hintStyle: TextStyle(
                        fontSize: defaultFontSize,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Frequently Asked Question 🙋🏻‍♀️',
                style: TextStyle(
                  fontSize: defaultLabelFontSize,
                  fontWeight: FontWeight.w900,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 140,
                      width: 150,
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(right: 10), // Add margin for spacing
                      decoration: BoxDecoration(
                        color: appBarColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'How do I book for tour package?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: defaultLabelFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.tour,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 140,
                      width: 150,
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(right: 10), // Add margin for spacing
                      decoration: BoxDecoration(
                        color: appBarColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'How do I apply to become local buddy?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: defaultLabelFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.people,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 140,
                      width: 150,
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(right: 10), // Add margin for spacing
                      decoration: BoxDecoration(
                        color: appBarColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Text(
                            'How do I cancel my booking?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: defaultLabelFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(), // This pushes the icon to the bottom
                          Align(
                            alignment: Alignment.bottomRight, // Align icon to the bottom right
                            child: Icon(
                              Icons.history,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              )
            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appBarColor,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatDetailsScreen(userId: widget.userId, receiverUserId: 'A1001'))
          );
        },
        tooltip: 'Customer Support',
        child: Icon(
          Icons.contact_support,
          color: Colors.white,
        ),
      ),
    );
  }
}