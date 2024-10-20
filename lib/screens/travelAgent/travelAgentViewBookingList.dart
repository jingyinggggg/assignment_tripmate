import 'package:assignment_tripmate/constants.dart';
import 'package:flutter/material.dart';

class TravelAgentViewBookingListScreen extends StatefulWidget {
  final String userID;

  const TravelAgentViewBookingListScreen({
    super.key, 
    required this.userID,
  });

  @override
  State<TravelAgentViewBookingListScreen> createState() => _TravelAgentViewBookingListScreenState();
}

class _TravelAgentViewBookingListScreenState extends State<TravelAgentViewBookingListScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
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
              Navigator.pop(context);
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: Container(
              height: 60,
              color: Colors.white,
              child: TabBar(
                tabs: [
                  Tab(
                    child: Text("Tour Package"),
                  ),
                  Tab(
                    child: Text("Car Rental"),
                  )
                ]
              ),
            ),
          ),
        ),
      )
    );
  }
}