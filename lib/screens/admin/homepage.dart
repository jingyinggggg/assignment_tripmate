import 'package:assignment_tripmate/screens/admin/adminAccountPage.dart';
import 'package:assignment_tripmate/screens/admin/admin_bottom_nav_bar.dart';
import 'package:assignment_tripmate/screens/admin/manageCountryList.dart';
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
      Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0), // Adjust the values as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => AdminManageCountryListScreen(userId: widget.userId))
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                      side: BorderSide(color: Color(0xFF467BA1), width: 2),
                    ),
                    minimumSize: const Size(120, 65),
                    elevation: 10, 
                    shadowColor: Color(0xFF467BA1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage("images/countries.png"),
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Manage Country List",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF467BA1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => AdminManageCountryListScreen(userId: widget.userId))
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                      side: BorderSide(color: Color(0xFF467BA1), width: 2),
                    ),
                    minimumSize: const Size(120, 65),
                    elevation: 10, 
                    shadowColor: Color(0xFF467BA1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage("images/countries.png"),
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Manage Registration Request",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF467BA1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => AdminManageCountryListScreen(userId: widget.userId))
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                      side: BorderSide(color: Color(0xFF467BA1), width: 2),
                    ),
                    minimumSize: const Size(120, 65),
                    elevation: 10, 
                    shadowColor: Color(0xFF467BA1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage("images/countries.png"),
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Manage Booking",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF467BA1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => AdminManageCountryListScreen(userId: widget.userId))
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                      side: BorderSide(color: Color(0xFF467BA1), width: 2),
                    ),
                    minimumSize: const Size(120, 65),
                    elevation: 10, 
                    shadowColor: Color(0xFF467BA1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage("images/countries.png"),
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Manage Tour",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF467BA1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => AdminManageCountryListScreen(userId: widget.userId))
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                      side: BorderSide(color: Color(0xFF467BA1), width: 2),
                    ),
                    minimumSize: const Size(120, 65),
                    elevation: 10, 
                    shadowColor: Color(0xFF467BA1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage("images/countries.png"),
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Manage Posting",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF467BA1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => AdminManageCountryListScreen(userId: widget.userId))
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                      side: BorderSide(color: Color(0xFF467BA1), width: 2),
                    ),
                    minimumSize: const Size(120, 65),
                    elevation: 10, 
                    shadowColor: Color(0xFF467BA1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage("images/countries.png"),
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Manage Car Rental",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF467BA1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
