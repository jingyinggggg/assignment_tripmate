import 'package:assignment_tripmate/screens/user/accountPage.dart';
import 'package:assignment_tripmate/screens/user/bookings.dart';
import 'package:assignment_tripmate/screens/user/itinerary.dart';
import 'package:assignment_tripmate/screens/user/chatPage.dart';
import 'package:assignment_tripmate/screens/user/languageTranslator.dart';
import 'package:assignment_tripmate/screens/user/viewCountry.dart';
import 'package:flutter/material.dart';
import 'package:assignment_tripmate/screens/user/bottom_nav_bar.dart';

class UserHomepageScreen extends StatefulWidget {
  final String userId;

  const UserHomepageScreen({super.key, required this.userId});

  @override
  State<UserHomepageScreen> createState() => _UserHomepageScreenState();
}

class _UserHomepageScreenState extends State<UserHomepageScreen> {
  int currentPageIndex = 0;

  final List<String> _screenTitles = [
    "Tripmate",
    "Itinerary",
    "Messages",
    "Bookings",
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
                        fontSize: 15,
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
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => ViewCountryScreen(userId: widget.userId))
                  );
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
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height:50),
          ElevatedButton(
            onPressed: () {
              // Handle navigation or other actions here.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageTranslatorScreen(userId: widget.userId))
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF749CB9), // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
                side: BorderSide(color: Color(0xFF467BA1), width: 2),
              ),
              minimumSize: const Size(120, 70),
            ),
            child: Text(
              "Language translator",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height:50),
          ElevatedButton(
            onPressed: () {
              // Handle navigation or other actions here.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageTranslatorScreen(userId: widget.userId))
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF749CB9), // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
                side: BorderSide(color: Color(0xFF467BA1), width: 2),
              ),
              minimumSize: const Size(120, 70),
            ),
            child: Text(
              "Currency converter",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      ItineraryScreen(),
      ChatScreen(userId: widget.userId),
      BookingsScreen(),
      AccountScreen(userId: widget.userId), // Access widget.userId here
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
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
      bottomNavigationBar: CustomBottomNavBar(
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
