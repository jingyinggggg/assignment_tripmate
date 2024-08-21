import 'package:assignment_tripmate/screens/admin/addCountry.dart';
import 'package:assignment_tripmate/screens/admin/homepage.dart';
import 'package:flutter/material.dart';

class AdminManageCountryListScreen extends StatefulWidget {
  final String userId;

  const AdminManageCountryListScreen({super.key, required this.userId});

  @override
  State<AdminManageCountryListScreen> createState() => _AdminManageCountryListScreenState();
}

class _AdminManageCountryListScreenState extends State<AdminManageCountryListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Country List"),
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
            // Navigator.pop(context);
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => AdminHomepageScreen(userId: widget.userId))
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight, // Aligns the button to the right
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0,right: 10.0), // Adds padding to the right
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => AdminAddCountryScreen(userId: widget.userId))
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF467BA1), // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    side: BorderSide(color: Color(0xFF467BA1), width: 2),
                  ),
                  // minimumSize: const Size(120, 65),
                ),
                child: Text(
                  "Add Country",
                  style: TextStyle(
                    fontFamily: "Inika",
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}

