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
        child: Center(
          child: Wrap(
            spacing: 25, // Horizontal space between buttons
            runSpacing: 25, // Vertical space between rows
            alignment: WrapAlignment.start, 
            children: [
              _buildMenuButton(
                context,
                icon: "images/countries.png",
                label: "Tour",
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => AdminManageCountryListScreen(userId: widget.userId))
                  );
                },
              ),
              _buildMenuButton(
                context,
                icon: "images/CarRentalIcon.png",
                label: "Car Listing",
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => AdminManageCarBrandScreen(userId: widget.userId))
                  );
                },
              ),
              _buildMenuButton(
                context,
                icon: "images/registration_request.png",
                label: "Registration",
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => RegistrationRequestScreen(userId: widget.userId))
                  );
                },
              ),
              _buildMenuButton(
                context,
                icon: "images/manage_booking.png",
                label: "Booking",
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => AdminManageCountryListScreen(userId: widget.userId))
                  );
                },
              ),
              _buildMenuButton(
                context,
                icon: "images/posting.png",
                label: "Posting",
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => AdminManageCountryListScreen(userId: widget.userId))
                  );
                },
              ),
            ],
          ),
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
        titleTextStyle: TextStyle(
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xFF467BA1), width: 2),
        ),
        minimumSize: const Size(160, 160), // Adjust the size as needed
        elevation: 10,
        shadowColor: Color(0xFF467BA1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: AssetImage(icon),
            width: 80,
            height: 80,
          ),
          SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center, // Center text if it wraps to the next line
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF467BA1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
