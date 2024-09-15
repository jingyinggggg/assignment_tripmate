import 'package:assignment_tripmate/screens/admin/adminAccountPage.dart';
import 'package:assignment_tripmate/screens/admin/admin_bottom_nav_bar.dart';
import 'package:assignment_tripmate/screens/admin/manageCarBrandList.dart';
import 'package:assignment_tripmate/screens/admin/manageCountryList.dart';
import 'package:assignment_tripmate/screens/admin/registrationRequest.dart';
import 'package:assignment_tripmate/screens/user/chatPage.dart';
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
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: GridView.builder(
          padding: const EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two buttons per row
            crossAxisSpacing: 20, // Horizontal spacing between buttons
            mainAxisSpacing: 25,  // Vertical spacing between buttons
            childAspectRatio: 1, // Buttons will be square
          ),
          itemCount: 5, // Total number of menu buttons
          itemBuilder: (context, index) {
            final menuItems = [
              {
                'icon': 'images/countries.png',
                'label': 'Tour',
                'onPressed': () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminManageCountryListScreen(userId: widget.userId),
                    ),
                  );
                },
              },
              {
                'icon': 'images/CarRentalIcon.png',
                'label': 'Car Listing',
                'onPressed': () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminManageCarBrandScreen(userId: widget.userId),
                    ),
                  );
                },
              },
              {
                'icon': 'images/registration_request.png',
                'label': 'Registration',
                'onPressed': () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationRequestScreen(userId: widget.userId),
                    ),
                  );
                },
              },
              {
                'icon': 'images/manage_booking.png',
                'label': 'Booking',
                'onPressed': () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminManageCountryListScreen(userId: widget.userId),
                    ),
                  );
                },
              },
              {
                'icon': 'images/posting.png',
                'label': 'Posting',
                'onPressed': () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminManageCountryListScreen(userId: widget.userId),
                    ),
                  );
                },
              },
            ];

            return _buildMenuButton(
              context,
              icon: menuItems[index]['icon'] as String,
              label: menuItems[index]['label'] as String,
              onPressed: menuItems[index]['onPressed'] as VoidCallback,
            );
          },
        ),
      ),
      ChatScreen(userId: widget.userId),
      AdminAccountScreen(userId: widget.userId),
    ];

    return Scaffold(
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
        minimumSize: Size(screenWidth * 0.4, screenWidth * 0.4), // 40% of screen width for the button
        elevation: 10,
        shadowColor: const Color(0xFF467BA1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(icon),
            width: screenWidth * 0.2, // 20% of screen width for the icon
            height: screenWidth * 0.2, // 20% of screen width for the icon
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
