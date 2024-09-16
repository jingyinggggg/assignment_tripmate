import 'package:assignment_tripmate/screens/travelAgent/travelAgentAddCarInfo.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentHomepage.dart';
import 'package:flutter/material.dart';

class TravelAgentViewCarListingScreen extends StatefulWidget {
  final String userId;

  const TravelAgentViewCarListingScreen({
    super.key,
    required this.userId,
  });

  @override
  State<StatefulWidget> createState() => _TravelAgentViewCarListingScreenState();
}

class _TravelAgentViewCarListingScreenState extends State<TravelAgentViewCarListingScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
            appBar: AppBar(
        title: const Text("Car Listing"),
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TravelAgentHomepageScreen(userId: widget.userId))
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30,),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => TravelAgentAddCarInfoScreen(userId: widget.userId))
              );
            },
          ),
        ]
      ),

      body: Column(
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
                  hintText: "Search car listing...",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}