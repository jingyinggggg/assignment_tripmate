import 'package:assignment_tripmate/screens/admin/adminAccountPage.dart';
import 'package:assignment_tripmate/screens/admin/admin_bottom_nav_bar.dart';
// import 'package:assignment_tripmate/screens/user/bookings.dart';
// import 'package:assignment_tripmate/screens/user/itinerary.dart';
import 'package:assignment_tripmate/screens/user/messages.dart';
import 'package:flutter/material.dart';

class AdminHomepageScreen extends StatefulWidget {
  final String userId;

  const AdminHomepageScreen({super.key, required this.userId});

  @override
  State<AdminHomepageScreen> createState() => _AdminHomepageScreenState();
}

class _AdminHomepageScreenState extends State<AdminHomepageScreen> {
  int currentPageIndex = 0;

  final List<String> _screenTitles = [
    "Tripmate",
    "Messages",
    "Account",
  ];

  void _onNavBarTap(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12, top: 10, bottom: 10),
            child: Text(
              "Explore",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle navigation or other actions here.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF749CB9), // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    side: BorderSide(color: Color(0xFF467BA1), width: 2),
                  ),
                  minimumSize: const Size(120, 70),
                ),
                child: Column(
                  children: const [
                    SizedBox(height: 10),
                    Image(
                      image: AssetImage("images/car-rental.png"),
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Car Rental",
                      style: TextStyle(
                        fontFamily: "Inika",
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle navigation or other actions here.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF749CB9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Color(0xFF467BA1), width: 2),
                  ),
                  minimumSize: const Size(120, 70),
                ),
                child: Column(
                  children: const [
                    SizedBox(height: 10),
                    Image(
                      image: AssetImage("images/location.png"),
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Local Buddy",
                      style: TextStyle(
                        fontFamily: "Inika",
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle navigation or other actions here.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF749CB9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Color(0xFF467BA1), width: 2),
                  ),
                  minimumSize: const Size(120, 70),
                ),
                child: Column(
                  children: const [
                    SizedBox(height: 10),
                    Image(
                      image: AssetImage("images/tour-guide.png"),
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Group Tour",
                      style: TextStyle(
                        fontFamily: "Inika",
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      MessagesScreen(),
      AdminAccountScreen(userId: widget.userId), // Access widget.userId here
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(_screenTitles[currentPageIndex]),
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        automaticallyImplyLeading: false, // This removes the default leading widget
      ),
      bottomNavigationBar: AdminCustomBottomNavBar(
        currentIndex: currentPageIndex,
        onTap: _onNavBarTap,
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: _screens,
      ),
    );
  }
}
