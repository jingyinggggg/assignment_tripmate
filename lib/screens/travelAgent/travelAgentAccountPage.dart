import 'package:assignment_tripmate/screens/login.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentProfile.dart';
import 'package:assignment_tripmate/screens/user/setting.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TravelAgentAccountScreen extends StatefulWidget {
  final String userId;

  const TravelAgentAccountScreen({super.key, required this.userId});

  @override
  State<TravelAgentAccountScreen> createState() => _TravelAgentAccountScreenState();
}

class _TravelAgentAccountScreenState extends State<TravelAgentAccountScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('travelAgent')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text("Travel agent not found"));
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
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Container(
                  width: 150,
                  height: 170,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userData['username'] ?? userData['name'],
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: 128,  // Width and height should match the CircleAvatar's diameter (2 * radius)
                        height: 128,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF467BA1),  // Border color
                            width: 3.0,  // Border width
                          ),
                        ),
                        child: userData['profileImage'] != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(userData['profileImage']),
                              )
                            : const CircleAvatar(
                                radius: 64,
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
                    top: 100,
                    left: 30,
                    child: Image(
                      image: AssetImage("images/flight_line.png"),
                      height: 500,
                      width: 330,
                    ),
                  ),
                  Positioned(
                    top: 120,
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
                                      TravelAgentProfileScreen(userId: widget.userId)),
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
                    top: 240,
                    left: 320,
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
                                      SettingScreen(userId: widget.userId)),
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
                  // Positioned(
                  //   top: 280,
                  //   left: 230,
                  //   child: Column(
                  //     children: [
                  //       const Text(
                  //         "Wishlist",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.w900,
                  //             color: Colors.black,
                  //             fontSize: 16),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           // Navigator.push(
                  //           //   context,
                  //           //   MaterialPageRoute(
                  //           //       builder: (context) =>
                  //           //           const SettingScreen()),
                  //           // );
                  //         },
                  //         child: Image.asset(
                  //           'images/location-pin.png',
                  //           width: 50,
                  //           height: 50,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Positioned(
                    top: 300,
                    left: 140,
                    child: Column(
                      children: [
                        const Text(
                          "Review",
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
                  // Positioned(
                  //   top: 330,
                  //   left: 40,
                  //   child: Column(
                  //     children: [
                  //       const Text(
                  //         "Blog",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.w900,
                  //             color: Colors.black,
                  //             fontSize: 16),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           // Navigator.push(
                  //           //   context,
                  //           //   MaterialPageRoute(
                  //           //       builder: (context) =>
                  //           //           const SettingScreen()),
                  //           // );
                  //         },
                  //         child: Image.asset(
                  //           'images/location-pin.png',
                  //           width: 50,
                  //           height: 50,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Positioned(
                    top: 470,
                    left: 55,
                    child: Column(
                      children: [
                        const Text(
                          "Agenda",
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
                    top: 485,
                    left: 170,
                    child: Column(
                      children: [
                        const Text(
                          "Help Center",
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
                    top: 500,
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
                    top: 580,
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