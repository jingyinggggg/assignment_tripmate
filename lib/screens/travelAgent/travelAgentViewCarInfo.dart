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
        title: const Text("Car Rental"),
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: 24,
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
    );
  }
}