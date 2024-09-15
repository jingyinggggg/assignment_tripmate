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
  Widget build(BuildContext content) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
              child: Container(
                height: 50,
                child: TextField(
                  // controller: _searchController, // Bind search controller
                  // onChanged: (value) {
                  //   setState(() {}); // Trigger the UI update on text change
                  // },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
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
                    hintText: "Search bookings ...",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const TabBar(
              labelColor: Color(0xFF467BA1),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF467BA1),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
              tabs: [
                Tab(text: "Completed"),
                Tab(text: "Upcoming"),
                Tab(text: "Canceled"),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [

                  Center(child: Icon(Icons.done)),
                  Center(child: Icon(Icons.upcoming)),
                  Center(child: Icon(Icons.cancel)),
                  // // Unpublished Tab
                  // _buildTourList(isPublished: false),

                  // // Published Tab
                  // _buildTourList(isPublished: true),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }



}