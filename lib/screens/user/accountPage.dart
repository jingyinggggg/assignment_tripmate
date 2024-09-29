import 'package:assignment_tripmate/screens/login.dart';
import 'package:assignment_tripmate/screens/user/blog.dart';
import 'package:assignment_tripmate/screens/user/profile.dart';
import 'package:assignment_tripmate/screens/user/setting.dart';
import 'package:assignment_tripmate/screens/user/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatefulWidget {
  final String userId;

  const AccountScreen({super.key, required this.userId});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
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
                padding: EdgeInsets.only(top: screenHeight * 0.02, left: screenWidth * 0.08 ,),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        userData['username'] ?? userData['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: screenWidth * 0.25,  
                        height: screenWidth * 0.25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF467BA1),  
                            width: 3.0,  
                          ),
                        ),
                        child: userData['profileImage'] != null
                            ? CircleAvatar(
                                radius: screenWidth * 0.125,
                                backgroundImage: NetworkImage(userData['profileImage']),
                              )
                            : CircleAvatar(
                                radius: screenWidth * 0.125,
                                backgroundImage: AssetImage("images/profile.png"),
                                backgroundColor: Colors.white,
                              ),
                      )
                    ]
                  ),
                ),
              ),
              Stack(
                children: [
                  Positioned(
                    top: screenHeight * 0.115,
                    left: screenWidth * 0.06,
                    child: Image(
                      image: AssetImage("images/flight_line.png"),
                      height: screenHeight * 0.6,
                      width: screenWidth * 0.75,
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.16,
                    left: screenWidth * 0.55,
                    child: Column(
                      children: [
                        const Text(
                          "Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(userId: widget.userId)),
                            );
                          },
                          child: Image.asset(
                            'images/location-pin.png',
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.28,
                    left: screenWidth * 0.72,
                    child: Column(
                      children: [
                        const Text(
                          "Setting",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SettingScreen(userId: widget.userId)),
                            );
                          },
                          child: Image.asset(
                            'images/location-pin.png',
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.35,
                    left: screenWidth * 0.5,
                    child: Column(
                      children: [
                        const Text(
                          "Wishlist",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WishlistScreen(userID: widget.userId)),
                            );
                          },
                          child: Image.asset(
                            'images/location-pin.png',
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.37,
                    left: screenWidth * 0.26,
                    child: Column(
                      children: [
                        const Text(
                          "Review",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 14),
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
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.42,
                    left: screenWidth * 0.06,
                    child: Column(
                      children: [
                        const Text(
                          "Blog",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BlogMainScreen(userId: widget.userId)),
                            );
                          },
                          child: Image.asset(
                            'images/location-pin.png',
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.55,
                    left: screenWidth * 0.12,
                    child: Column(
                      children: [
                        const Text(
                          "Revenue",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 14),
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
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.6,
                    left: screenWidth * 0.35,
                    child: Column(
                      children: [
                        const Text(
                          "Help Center",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 14),
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
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.61,
                    left: screenWidth * 0.74,
                    child: Column(
                      children: [
                        const Text(
                          "Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 14),
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
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.68,
                    left: screenWidth * 0.81,
                    child: Image.asset(
                      'images/flag.png',
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.1,
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
