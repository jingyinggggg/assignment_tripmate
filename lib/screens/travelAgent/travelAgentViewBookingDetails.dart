import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentViewBookingList.dart';
import 'package:flutter/material.dart';

class TravelAgentViewBookingDetailsScreen extends StatefulWidget {
  final String userId;
  final String? tourID;
  final String? carRentalID;

  const TravelAgentViewBookingDetailsScreen({
    super.key, 
    required this.userId,
    this.tourID,
    this.carRentalID
  });

  @override
  State<TravelAgentViewBookingDetailsScreen> createState() => _TravelAgentViewBookingDetailsScreenState();
}

class _TravelAgentViewBookingDetailsScreenState extends State<TravelAgentViewBookingDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Booking"),
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
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => TravelAgentViewBookingListScreen(userId: widget.userId))
            );
          },
        ),
      ),
    );    
  }
}