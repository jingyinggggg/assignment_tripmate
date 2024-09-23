import 'package:assignment_tripmate/screens/user/accountPage.dart';
import 'package:assignment_tripmate/screens/user/bookings.dart';
import 'package:assignment_tripmate/screens/user/carRentalHomepage.dart';
import 'package:assignment_tripmate/screens/user/currencyConverter.dart';
import 'package:assignment_tripmate/screens/user/custom_animation.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
   
    final List<Widget> _screens = [
      Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Explore",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => CarRentalHomepageScreen(userId: widget.userId))
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                        side: BorderSide(color: Color(0xFF467BA1), width: 1.5),
                      ),
                      minimumSize: Size(screenWidth * 0.35, screenHeight * 0.1)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Image(
                          image: AssetImage("images/car-rental.png"),
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
                          color: Color(0xFF467BA1),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Car Rental",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF467BA1),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between buttons if necessary
                  ElevatedButton(
                    onPressed: () {
                      // Handle navigation or other actions here.
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Color(0xFF467BA1), width: 1.5),
                      ),
                      minimumSize: Size(screenWidth * 0.35, screenHeight * 0.1)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Image(
                          image: AssetImage("images/location.png"),
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
                          color: Color(0xFF467BA1),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Local Buddy",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF467BA1),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => ViewCountryScreen(userId: widget.userId))
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Color(0xFF467BA1), width: 1.5),
                      ),
                      minimumSize: Size(screenWidth * 0.35, screenHeight * 0.1)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Image(
                          image: AssetImage("images/tour-guide.png"),
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
                          color: Color(0xFF467BA1),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Group Tour",
                          style: TextStyle(
                            fontSize: 14,
                            color:Color(0xFF467BA1),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
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
                  MaterialPageRoute(builder: (context) => CurrencyConverterScreen(userId: widget.userId))
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
            ElevatedButton(
              onPressed: () {
                // Handle navigation or other actions here.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomAnimation())
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
                "CA",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
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
          fontSize: 20
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

// class UserHomepageScreen extends StatefulWidget {
//   final String userId;

//   const UserHomepageScreen({Key? key, required this.userId}) : super(key: key);

//   @override
//   State<UserHomepageScreen> createState() => _UserHomepageScreenState();
// }

// class _UserHomepageScreenState extends State<UserHomepageScreen> {
//   int currentPageIndex = 0;
//   bool _isMenuExpanded = false;

//   final List<String> _screenTitles = [
//     "Tripmate",
//     "Itinerary",
//     "Messages",
//     "Bookings",
//     "Account",
//   ];

//   void _onNavBarTap(int index) {
//     setState(() {
//       currentPageIndex = index;
//     });
//   }

//   void _toggleMenu() {
//     setState(() {
//       _isMenuExpanded = !_isMenuExpanded;
//     });
//   }

//   void _onMenuItemSelected(int index) {
//     // Handle menu item selection here
//     print('Menu item $index selected');
//     _toggleMenu(); // Optionally close the menu after selection
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;


//     final List<Widget> _screens = [
//       Container(
//         padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
//         child: SingleChildScrollView(
//           // padding: EdgeInsets.all(10),
//           child: 
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Explore",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal, // Enable horizontal scrolling
//                   child: Row(
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           // Handle navigation or other actions here.
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white, // Button background color
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10), // Rounded corners
//                             side: BorderSide(color: Color(0xFF467BA1), width: 1.5),
//                           ),
//                           minimumSize: Size(screenWidth * 0.35, screenHeight * 0.1)
//                         ),
//                         child: Column(
//                           children: [
//                             SizedBox(height: 10),
//                             Image(
//                               image: AssetImage("images/car-rental.png"),
//                               width: screenWidth * 0.1,
//                               height: screenWidth * 0.1,
//                               color: Color(0xFF467BA1),
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               "Car Rental",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Color(0xFF467BA1),
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                           ],
//                         ),
//                       ),
//                       SizedBox(width: 10), // Add spacing between buttons if necessary
//                       ElevatedButton(
//                         onPressed: () {
//                           // Handle navigation or other actions here.
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: BorderSide(color: Color(0xFF467BA1), width: 1.5),
//                           ),
//                           minimumSize: Size(screenWidth * 0.35, screenHeight * 0.1)
//                         ),
//                         child: Column(
//                           children: [
//                             SizedBox(height: 10),
//                             Image(
//                               image: AssetImage("images/location.png"),
//                               width: screenWidth * 0.1,
//                               height: screenWidth * 0.1,
//                               color: Color(0xFF467BA1),
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               "Local Buddy",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Color(0xFF467BA1),
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                           ],
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context, 
//                             MaterialPageRoute(builder: (context) => ViewCountryScreen(userId: widget.userId))
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: BorderSide(color: Color(0xFF467BA1), width: 1.5),
//                           ),
//                           minimumSize: Size(screenWidth * 0.35, screenHeight * 0.1)
//                         ),
//                         child: Column(
//                           children: [
//                             SizedBox(height: 10),
//                             Image(
//                               image: AssetImage("images/tour-guide.png"),
//                               width: screenWidth * 0.1,
//                               height: screenWidth * 0.1,
//                               color: Color(0xFF467BA1),
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               "Group Tour",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color:Color(0xFF467BA1),
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height:50),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle navigation or other actions here.
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => LanguageTranslatorScreen(userId: widget.userId))
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF749CB9), // Button background color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10), // Rounded corners
//                       side: BorderSide(color: Color(0xFF467BA1), width: 2),
//                     ),
//                     minimumSize: const Size(120, 70),
//                   ),
//                   child: Text(
//                     "Language translator",
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height:50),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle navigation or other actions here.
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => CurrencyConverterScreen(userId: widget.userId))
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF749CB9), // Button background color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10), // Rounded corners
//                       side: BorderSide(color: Color(0xFF467BA1), width: 2),
//                     ),
//                     minimumSize: const Size(120, 70),
//                   ),
//                   child: Text(
//                     "Currency converter",
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 Container(

//                 )
//                 CustomAnimation(),
//               ],
//             )
//         ),
//       ),
      
//       ItineraryScreen(),
//       ChatScreen(userId: widget.userId),
//       BookingsScreen(),
//       AccountScreen(userId: widget.userId), // Access widget.userId here
//     ];

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Scaffold(
//             appBar: AppBar(
//               title: Text(_screenTitles[currentPageIndex]),
//               centerTitle: true,
//               backgroundColor: const Color(0xFF749CB9),
//               titleTextStyle: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'Inika',
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//               automaticallyImplyLeading: false,
//               // leading: CustomAnimation(
//               //   onTap: _toggleMenu,
//               //   onMenuItemSelected: _onMenuItemSelected,
//               //   isExpanded: _isMenuExpanded,
//               // ),
//             ),
//             bottomNavigationBar: CustomBottomNavBar(
//               currentIndex: currentPageIndex,
//               onTap: _onNavBarTap,
//             ),
//             body: IndexedStack(
//               children: [
//                 _screens[currentPageIndex],
//               ],
//             ),
//           ),

//           // CustomAnimation(),

//         ],
//       ),

      
//     );
//   }
// }

