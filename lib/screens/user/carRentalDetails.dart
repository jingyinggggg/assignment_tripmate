import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/user/carRentalHomepage.dart';
import 'package:flutter/material.dart';

class CarRentalDetailsScreen extends StatefulWidget {
  final String userId;
  final String carId;

  const CarRentalDetailsScreen({
    super.key,
    required this.userId,
    required this.carId
  });

  @override
  State<StatefulWidget> createState() => _CarRentalDetailsScreenState();
}

class _CarRentalDetailsScreenState extends State<CarRentalDetailsScreen>{


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
          fontSize: defaultAppBarTitleFontSize,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CarRentalHomepageScreen(userId: widget.userId))
            );
          },
        ),
      ),
    );
  }

}