import 'package:flutter/material.dart';
// import 'package:assignment_tripmate/screens/login.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:assignment_tripmate/firebase_auth_services.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin{

  int currentPageIndex = 0;

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                    // onChanged: (value) => onSearch(value),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      // fillColor: Color.fromARGB(255, 218, 232, 243),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2), // Set the border color to black
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2), // Black border when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFF467BA1), width: 2), // Black border when focused
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red, width: 2), // Red border for error state
                      ),
                      hintText: "Search",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (){}, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF467BA1),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Completed",
                        style: TextStyle(
                          color: Colors.white,
                        ),

                      )
                    ),
                    ElevatedButton(
                      onPressed: (){}, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF467BA1),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Upcoming",
                        style: TextStyle(
                          color: Colors.white,
                        ),

                      )
                    ),
                    ElevatedButton(
                      onPressed: (){}, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF467BA1),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Canceled",
                        style: TextStyle(
                          color: Colors.white,
                        ),

                      )
                    ),
                  ],
                ),
              ),  
            ],
          ),
        ],
      ),
      
    );
  }



}