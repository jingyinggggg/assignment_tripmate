import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String userID;
  final String? tourBookingID;
  final String? carRentalBookingID;
  final String? localBuddyBookingID;

  const BookingDetailsScreen({
    super.key, 
    required this.userID,
    this.tourBookingID,
    this.carRentalBookingID,
    this.localBuddyBookingID
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      
    );    
  }
}