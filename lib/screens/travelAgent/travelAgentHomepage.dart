import 'package:assignment_tripmate/screens/admin/admin_bottom_nav_bar.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentAccountPage.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentViewCarInfo.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentViewCountry.dart';
import 'package:assignment_tripmate/screens/user/chatPage.dart';
import 'package:flutter/material.dart';

class TravelAgentHomepageScreen extends StatefulWidget {
  final String userId;

  const TravelAgentHomepageScreen({super.key, required this.userId});

  @override
  State<TravelAgentHomepageScreen> createState() => _TravelAgentHomepageScreenState();
}

class _TravelAgentHomepageScreenState extends State<TravelAgentHomepageScreen> {
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
      GridView.builder( // GridView replaces Wrap for scrollable grid
        padding: const EdgeInsets.all(20.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two buttons per row
          crossAxisSpacing: 20, // Horizontal spacing between buttons
          mainAxisSpacing: 25,  // Vertical spacing between buttons
          childAspectRatio: 1, // Keep square buttons
        ),
        itemCount: 4, // Number of items (buttons) in grid
        itemBuilder: (context, index) {
          final menuItems = [
            {
              'icon': 'images/countries.png',
              'label': 'Tour',
              'onPressed': () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TravelAgentViewCountryScreen(userId: widget.userId)),
                );
              }
            },
            {
              'icon': 'images/registration_request.png',
              'label': 'Car Rental',
              'onPressed': () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TravelAgentViewCarListingScreen(userId: widget.userId)),
                );
              }
            },
            {
              'icon': 'images/manage_booking.png',
              'label': 'Booking',
              'onPressed': () {
                // Placeholder for Booking screen
              }
            },
            {
              'icon': 'images/posting.png',
              'label': 'Analytics Report',
              'onPressed': () {
                // Placeholder for Analytics Report screen
              }
            }
          ];

          return _buildMenuButton(
            context,
            icon: menuItems[index]['icon'] as String,
            label: menuItems[index]['label'] as String,
            onPressed: menuItems[index]['onPressed'] as VoidCallback,
          );
        },
      ),
      ChatScreen(userId: widget.userId),
      TravelAgentAccountScreen(userId: widget.userId),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(_screenTitles[currentPageIndex]),
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        automaticallyImplyLeading: false,
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

  Widget _buildMenuButton(BuildContext context, {required String icon, required String label, required VoidCallback onPressed}) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF467BA1), width: 2),
        ),
        elevation: 10,
        shadowColor: const Color(0xFF467BA1),
        minimumSize: Size(screenWidth * 0.4, screenWidth * 0.4)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(icon),
            width: screenWidth * 0.2, 
            height: screenWidth * 0.2, 
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF467BA1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
