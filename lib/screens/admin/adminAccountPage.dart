import 'package:assignment_tripmate/screens/admin/adminProfile.dart';
import 'package:assignment_tripmate/screens/admin/adminSetting.dart';
import 'package:assignment_tripmate/screens/login.dart';
// import 'package:assignment_tripmate/screens/user/profile.dart';
// import 'package:assignment_tripmate/screens/user/setting.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminAccountScreen extends StatefulWidget {
  final String userId;

  const AdminAccountScreen({super.key, required this.userId});

  @override
  State<AdminAccountScreen> createState() => _AdminAccountScreenState();
}

class _AdminAccountScreenState extends State<AdminAccountScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('admin')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text("User not found"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var username = userData['username'] ?? '';

          
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/account_background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                color: const Color(0xFFEDF2F6).withOpacity(0.6),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 30, left: 10),
                child: Container(
                  width: 150,
                  height: 170,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white, // Set background color
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF467BA1), width: 4)
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0), // Adding padding
                            child: Image.asset(
                              'images/logo.png', // Your updated logo asset
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Stack(
                children: [
                  Positioned(
                    top: 120,
                    left: 30,
                    child: Image(
                      image: AssetImage("images/flight_line.png"),
                      height: 500,
                      width: 330,
                    ),
                  ),
                  Positioned(
                    top: 140,
                    left: 220,
                    child: Column(
                      children: [
                        const Text(
                          "Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AdminProfileScreen(userId: widget.userId)),
                            );
                          },
                          child: Image.asset(
                            'images/location-pin.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 230,
                    left: 310,
                    child: Column(
                      children: [
                        const Text(
                          "Setting",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AdminSettingScreen(userId: widget.userId,)),
                            );
                          },
                          child: Image.asset(
                            'images/location-pin.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 290,
                    left: 200,
                    child: Column(
                      children: [
                        const Text(
                          "Registration\nRequest",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           const SettingScreen()),
                            // );
                          },
                          child: Image.asset(
                            'images/location-pin.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 320,
                    left: 110,
                    child: Column(
                      children: [
                        const Text(
                          "Booking",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           const SettingScreen()),
                            // );
                          },
                          child: Image.asset(
                            'images/location-pin.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 365,
                    left: 20,
                    child: Column(
                      children: [
                        const Text(
                          "Posting",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           const SettingScreen()),
                            // );
                          },
                          child: Image.asset(
                            'images/location-pin.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 490,
                    left: 55,
                    child: Column(
                      children: [
                        const Text(
                          "Tour",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           const SettingScreen()),
                            // );
                          },
                          child: Image.asset(
                            'images/location-pin.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 505,
                    left: 170,
                    child: Column(
                      children: [
                        const Text(
                          "Car Rental",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           const SettingScreen()),
                            // );
                          },
                          child: Image.asset(
                            'images/location-pin.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 520,
                    left: 330,
                    child: Column(
                      children: [
                        const Text(
                          "Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginScreen()),
                            );
                          },
                          child: Image.asset(
                            'images/location-pin.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 600,
                    left: 355,
                    child: Image.asset(
                      'images/flag.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
