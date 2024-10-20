import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingsScreen extends StatefulWidget {
  final String userID;

  const BookingsScreen({super.key, required this.userID});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin{
  List<tourBooking> _tourBookingCompleted = [];
  List<tourBooking> _tourBookingUpcoming = [];
  List<tourBooking> _tourBookingCanceled = [];
  List<carRentalBooking> _carRentalBookingCompleted = [];
  List<carRentalBooking> _carRentalBookingUpcoming = [];
  List<carRentalBooking> _carRentalBookingCanceled = [];
  List<localBuddyBooking> _localBuddyBookingCompleted = [];
  List<localBuddyBooking> _localBuddyBookingUpcoming = [];
  List<localBuddyBooking> _localBuddyBookingCanceled = [];
  bool isFetching = false;
  int _outerTabIndex = 0;  // For the outer Upcoming, Completed, Canceled
  int _innerTabIndex = 0;  // For the inner Tour Package, Car Rental, Local Buddy

  @override
  void initState(){
    super.initState();
    _fetchTourBooking();
    _fetchCarRentalBooking();
    _fetchLocalBuddyBooking();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Fetch tour bookings
  Future<void> _fetchTourBooking() async {
    setState(() {
      isFetching = true;
    });

    try {
      CollectionReference upTourBookingRef = FirebaseFirestore.instance.collection('tourBooking');
      QuerySnapshot upTourBookingSnapshot = await upTourBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 0)
          .get();

      // Initialize an empty list for upcoming tour bookings
      List<tourBooking> tourBookings = [];

      if (upTourBookingSnapshot.docs.isNotEmpty) {
        for (var tourDoc in upTourBookingSnapshot.docs) {
          String tourID = tourDoc['tourID'] as String;

          // Fetch tour details
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('tourPackage').doc(tourID).get();

          if (documentSnapshot.exists) {
            String tourName = documentSnapshot['tourName'] as String;
            String tourImage = documentSnapshot['tourCover'] as String;

            // Create a tourBooking object and add tour details
            tourBooking tourBook = tourBooking.fromFirestore(tourDoc);
            tourBook.tourName = tourName;
            tourBook.tourImage = tourImage;

            tourBookings.add(tourBook);
          }
        }

        // Update state with the list of upcoming bookings
        setState(() {
          _tourBookingUpcoming = tourBookings;
        });
      } else {
        // If no results found, set _tourBookingUpcoming to an empty list
        setState(() {
          _tourBookingUpcoming = [];
        });
      }

      CollectionReference comTourBookingRef = FirebaseFirestore.instance.collection('tourBooking');
      QuerySnapshot comTourBookingSnapshot = await comTourBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 1)
          .get();

      // Initialize an empty list for completed tour bookings
      List<tourBooking> comTourBookings = [];

      if (comTourBookingSnapshot.docs.isNotEmpty) {
        for (var comTourDoc in comTourBookingSnapshot.docs) {
          String comTourID = comTourDoc['tourID'] as String;

          // Fetch tour details
          DocumentSnapshot comDocumentSnapshot = await FirebaseFirestore.instance.collection('tourPackage').doc(comTourID).get();

          if (comDocumentSnapshot.exists) {
            String comTourName = comDocumentSnapshot['tourName'] as String;
            String comTourImage = comDocumentSnapshot['tourCover'] as String;

            // Create a tourBooking object and add tour details
            tourBooking comTourBook = tourBooking.fromFirestore(comTourDoc);
            comTourBook.tourName = comTourName;
            comTourBook.tourImage = comTourImage;

            comTourBookings.add(comTourBook);
          }
        }

        setState(() {
          _tourBookingCompleted = comTourBookings;
        });
      } else {
        setState(() {
          _tourBookingCompleted = [];
        });
      }

      CollectionReference canTourBookingRef = FirebaseFirestore.instance.collection('tourBooking');
      QuerySnapshot canTourBookingSnapshot = await canTourBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 2)
          .get();

      // Initialize an empty list for completed tour bookings
      List<tourBooking> canTourBookings = [];

      if (canTourBookingSnapshot.docs.isNotEmpty) {
        for (var canTourDoc in canTourBookingSnapshot.docs) {
          String canTourID = canTourDoc['tourID'] as String;

          // Fetch tour details
          DocumentSnapshot canDocumentSnapshot = await FirebaseFirestore.instance.collection('tourPackage').doc(canTourID).get();

          if (canDocumentSnapshot.exists) {
            String canTourName = canDocumentSnapshot['tourName'] as String;
            String canTourImage = canDocumentSnapshot['tourCover'] as String;

            // Create a tourBooking object and add tour details
            tourBooking canTourBook = tourBooking.fromFirestore(canTourDoc);
            canTourBook.tourName = canTourName;
            canTourBook.tourImage = canTourImage;

            canTourBookings.add(canTourBook);
          }
        }

        setState(() {
          _tourBookingCanceled = canTourBookings;
        });
      } else {
        setState(() {
          _tourBookingCanceled = [];
        });
      }

      setState(() {
        isFetching = false;
      });
    } catch (e) {
      print('Error fetching booking: $e');
      setState(() {
        isFetching = false;
      });
    }
  }

  // Fetch car rental bookings
  Future<void> _fetchCarRentalBooking() async {
    setState(() {
      isFetching = true;
    });

    try {
      CollectionReference upCarRentalBookingRef = FirebaseFirestore.instance.collection('carRentalBooking');
      QuerySnapshot upCarRentalBookingSnapshot = await upCarRentalBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 0)
          .get();

      // Initialize an empty list for upcoming car rental bookings
      List<carRentalBooking> upCarRentalBookings = [];

      if (upCarRentalBookingSnapshot.docs.isNotEmpty) {
        for (var upCarDoc in upCarRentalBookingSnapshot.docs) {
          String upCarID = upCarDoc['carID'] as String;

          // Fetch car details
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('car_rental').doc(upCarID).get();

          if (documentSnapshot.exists) {
            String carName = documentSnapshot['carModel'] as String;
            String carImage = documentSnapshot['carImage'] as String;

            // Create a carRentalBooking object and add car rental details
            carRentalBooking carRentalBook = carRentalBooking.fromFirestore(upCarDoc);
            carRentalBook.carName = carName;
            carRentalBook.carImage = carImage;

            upCarRentalBookings.add(carRentalBook);
          }
        }

        // Update state with the list of upcoming bookings
        setState(() {
          _carRentalBookingUpcoming = upCarRentalBookings;
        });
      } else {
        // If no results found, set _tourBookingUpcoming to an empty list
        setState(() {
          _carRentalBookingUpcoming = [];
        });
      }

      CollectionReference comCarRentalBookingRef = FirebaseFirestore.instance.collection('carRentalBooking');
      QuerySnapshot comCarRentalBookingSnapshot = await comCarRentalBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 1)
          .get();

      List<carRentalBooking> comCarRentalBookings = [];

      if (comCarRentalBookingSnapshot.docs.isNotEmpty) {
        for (var comCarDoc in comCarRentalBookingSnapshot.docs) {
          String comCarID = comCarDoc['carID'] as String;

          // Fetch car details
          DocumentSnapshot comDocumentSnapshot = await FirebaseFirestore.instance.collection('car_rental').doc(comCarID).get();

          if (comDocumentSnapshot.exists) {
            String comCarName = comDocumentSnapshot['carModel'] as String;
            String comCarImage = comDocumentSnapshot['carImage'] as String;

            // Create a carRentalBooking object and add car rental details
            carRentalBooking comCarRentalBook = carRentalBooking.fromFirestore(comCarDoc);
            comCarRentalBook.carName = comCarName;
            comCarRentalBook.carImage = comCarImage;

            comCarRentalBookings.add(comCarRentalBook);
          }
        }

        setState(() {
          _carRentalBookingCompleted = comCarRentalBookings;
        });
      } else {
        setState(() {
          _carRentalBookingCompleted = [];
        });
      }

      CollectionReference canCarRentalBookingRef = FirebaseFirestore.instance.collection('carRentalBooking');
      QuerySnapshot canCarRentalBookingSnapshot = await canCarRentalBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 2)
          .get();

      List<carRentalBooking> canCarRentalBookings = [];

      if (canCarRentalBookingSnapshot.docs.isNotEmpty) {
        for (var canCarDoc in canCarRentalBookingSnapshot.docs) {
          String canCarID = canCarDoc['carID'] as String;

          // Fetch car details
          DocumentSnapshot canDocumentSnapshot = await FirebaseFirestore.instance.collection('car_rental').doc(canCarID).get();

          if (canDocumentSnapshot.exists) {
            String canCarName = canDocumentSnapshot['carModel'] as String;
            String canCarImage = canDocumentSnapshot['carImage'] as String;

            // Create a carRentalBooking object and add car rental details
            carRentalBooking canCarRentalBook = carRentalBooking.fromFirestore(canCarDoc);
            canCarRentalBook.carName = canCarName;
            canCarRentalBook.carImage = canCarImage;

            canCarRentalBookings.add(canCarRentalBook);
          }
        }

        setState(() {
          _carRentalBookingCanceled = canCarRentalBookings;
        });
      } else {
        // If no results found, set _tourBookingUpcoming to an empty list
        setState(() {
          _carRentalBookingCanceled = [];
        });
      }

      setState(() {
        isFetching = false;
      });
    } catch (e) {
      print('Error fetching booking: $e');
      setState(() {
        isFetching = false;
      });
    }
  }

  // Fetch local buddy bookings
  Future<void> _fetchLocalBuddyBooking() async {
    setState(() {
      isFetching = true;
    });

    try {
      CollectionReference upLocalBuddyBookingRef = FirebaseFirestore.instance.collection('localBuddyBooking');
      QuerySnapshot upLocalBuddyBookingSnapshot = await upLocalBuddyBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 0)
          .get();

      List<String> localBuddyIDs = [];
      List<localBuddyBooking> upLocalBuddyBookings = [];

      if (upLocalBuddyBookingSnapshot.docs.isNotEmpty) {
        // Inside the loop for the localBuddyBooking collection
        for (var upLBDoc in upLocalBuddyBookingSnapshot.docs) {
          localBuddyBooking localBuddyBooks = localBuddyBooking.fromFirestore(upLBDoc); // Use the booking doc here
          
          String localBuddyID = upLBDoc['localBuddyID'] as String;

          // Fetch the local buddy details
          DocumentSnapshot localBuddyDoc = await FirebaseFirestore.instance.collection('localBuddy').doc(localBuddyID).get();
          String userId = localBuddyDoc['userID'] as String;

          // Fetch user details including profile image from 'users' collection
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
          String profileImage = userDoc['profileImage'] as String;
          String localBuddyName = userDoc['name'] as String;

          // Get full address from the document
          String fullAddress = localBuddyDoc['location'];

          // Call the Geocoding API to extract country and area
          String? country = '';
          String? area = '';

          if (fullAddress.isNotEmpty) {
            var locationData = await _getLocationAreaAndCountry(fullAddress);
            country = locationData['country'];
            area = locationData['area'];
          }

          String locationArea = '$area, $country';

          // Assign the user details to the localBuddyBooking object
          localBuddyBooks.localBuddyName = localBuddyName;
          localBuddyBooks.localBuddyImage = profileImage;
          localBuddyBooks.locationArea = locationArea;

          upLocalBuddyBookings.add(localBuddyBooks);
        }
        setState(() {
          _localBuddyBookingUpcoming = upLocalBuddyBookings;
        });
      } else {
        setState(() {
          _localBuddyBookingUpcoming = [];
        });
      }

      setState(() {
        isFetching = false;
      });
    } catch (e) {
      print('Error fetching local buddy booking: $e');
      setState(() {
        isFetching = false;
      });
    }
  }

  // Function to get area and country from the full address using the Google Geocoding API
  Future<Map<String, String>> _getLocationAreaAndCountry(String address) async {
    final String apiKeys = apiKey; // Replace with your API key
    final String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKeys';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['results'].isNotEmpty) {
        final addressComponents = data['results'][0]['address_components'];

        String country = '';
        String area = '';

        for (var component in addressComponents) {
          List<String> types = List<String>.from(component['types']);
          if (types.contains('country')) {
            country = component['long_name'];
          } else if (types.contains('administrative_area_level_1') || types.contains('locality')) {
            area = component['long_name'];
          }
        }

        return {'country': country, 'area': area};
      } else {
        return {'country': '', 'area': ''};
      }
    } else {
      print('Error fetching location data: ${response.statusCode}');
      return {'country': '', 'area': ''};
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,  // Outer tab count
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 241, 246, 249),
        body: Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
              child: Container(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blueGrey, width: 2),
                    ),
                    hintText: "Search bookings ...",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            // Outer TabBar (Upcoming, Completed, Canceled)
            TabBar(
              onTap: (index) {
                setState(() {
                  _outerTabIndex = index;
                  _innerTabIndex = 0;  // Reset inner tab index on outer tab change
                });
              },
              labelColor: Color(0xFF467BA1),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF467BA1),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: "Upcoming"),
                Tab(text: "Completed"),
                Tab(text: "Canceled"),
              ],
            ),

            // Inner Tabs (Tour Package, Car Rental, Local Buddy) using buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInnerTabButton(0, "Tour Package"),
                  _buildInnerTabButton(1, "Car Rental"),
                  _buildInnerTabButton(2, "Local Buddy"),
                ],
              ),
            ),

            // TabBarView for the outer tabs
            Expanded(
              child: isFetching 
                ? Center(
                    child: CircularProgressIndicator(color: primaryColor,),  // Show loading indicator when isFetching is true
                  )
                : TabBarView(
                    physics: NeverScrollableScrollPhysics(), // Prevents swipe gesture
                    children: [
                      _buildContentForTab(),  // For Upcoming
                      _buildContentForTab(),  // For Completed
                      _buildContentForTab(),  // For Canceled
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create inner tab buttons
  Widget _buildInnerTabButton(int index, String title) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _innerTabIndex = index; // Update inner tab index on button press
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _innerTabIndex == index ? Color(0xFF749CB9) : Colors.white,  // Active color
        foregroundColor: _innerTabIndex == index ? Colors.white : Color(0xFF749CB9),  // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: primaryColor)
        ),
      ),
      child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
    );
  }

  // Method to build content for the selected outer and inner tabs
  Widget _buildContentForTab() {
    if (_outerTabIndex == 0) {
      // Handle Upcoming
      if (_innerTabIndex == 0) {
        return _buildTourPackageContent(_tourBookingUpcoming, 0);
      } else if (_innerTabIndex == 1) {
        return _buildCarRentalContent(_carRentalBookingUpcoming, 0);
      } else {
        return _buildLocalBuddyContent(_localBuddyBookingUpcoming, 0);
      }
    } else if (_outerTabIndex == 1) {
      // Handle Completed
      if (_innerTabIndex == 0) {
        return _buildTourPackageContent(_tourBookingCompleted, 1);
      } else if (_innerTabIndex == 1) {
        return _buildCarRentalContent(_carRentalBookingCompleted, 1);
      } else {
        return _buildLocalBuddyContent(_localBuddyBookingCompleted, 1);
      }
    } else {
      // Handle Canceled
      if (_innerTabIndex == 0) {
        return _buildTourPackageContent(_tourBookingCanceled, 2);
      } else if (_innerTabIndex == 1) {
        return _buildCarRentalContent(_carRentalBookingCanceled, 2);
      } else {
        return _buildLocalBuddyContent(_localBuddyBookingCanceled, 2);
      }
    }
  }

  // Mock content for different inner tabs
  Widget _buildTourPackageContent(List<tourBooking> bookings,int status) {
    if(bookings.isNotEmpty){
      // If data exists, show the list of bookings
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                itemCount: bookings.length,
                shrinkWrap: true, // Allows ListView to be nested
                physics: NeverScrollableScrollPhysics(), // Prevents ListView from scrolling independently
                itemBuilder: (context, index) {
                  return tourComponent(tourbookings: bookings[index], status: status);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(child: Text(status == 0 ? 'You have no upcoming tour bookings.' : status == 1 ? 'You have no completed tour bookings' : status == 2 ? 'You have no canceled tour bookings.' : 'Error'));
    }
  }

  Widget _buildCarRentalContent(List<carRentalBooking> bookings, int status) {
      if(bookings.isNotEmpty){
      // If data exists, show the list of bookings
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                itemCount: bookings.length,
                shrinkWrap: true, // Allows ListView to be nested
                physics: NeverScrollableScrollPhysics(), // Prevents ListView from scrolling independently
                itemBuilder: (context, index) {
                  return carComponent(carRentalbookings: bookings[index], status: status);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(child: Text(status == 0 ? 'You have no upcoming car rental bookings.' : status == 1 ? 'You have no completed car rental bookings' : status == 2 ? 'You have no canceled car rental bookings.' : 'Error'));
    }
  }

  Widget _buildLocalBuddyContent(List<localBuddyBooking> bookings, int status) {
      if(bookings.isNotEmpty){
      // If data exists, show the list of bookings
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                itemCount: bookings.length,
                shrinkWrap: true, // Allows ListView to be nested
                physics: NeverScrollableScrollPhysics(), // Prevents ListView from scrolling independently
                itemBuilder: (context, index) {
                  return localBuddyComponent(localBuddyBookings: bookings[index], status: status);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(child: Text(status == 0 ? 'You have no upcoming local buddy bookings.' : status == 1 ? 'You have no completed local buddy bookings' : status == 2 ? 'You have no canceled local buddy bookings.' : 'Error'));
    }
  }

  Widget tourComponent({required tourBooking tourbookings, required int status}){
    return GestureDetector(
      onTap: (){
        // Navigator.push(
        //   context, 
        //   MaterialPageRoute(builder: (context) => ViewTourDetailsScreen(userId: widget.userID, countryName: tourPackage.countryName, cityName: tourPackage.cityName, tourID: tourPackage.tourID, fromAppLink: 'false',))
        // );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border.all(color: Colors.grey.shade200, width: 1.5),
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ID: ${tourbookings.tourBookingID}",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: status == 0 ? Colors.orange.shade100 : status == 1 ? Colors.green.shade100 : status == 2 ? Colors.red.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(
                      status == 0 ? "Upcoming" : status == 1 ? "Completed" : status == 2 ? "Canceled" : "Unknown",
                      style: TextStyle(
                        color: status == 0 ? Colors.orange : status == 1 ? Colors.green : status == 3 ? Colors.red : Colors.grey.shade900,
                        fontSize: 10,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  )
                ],
              )
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: getScreenWidth(context) * 0.15,
                    height: getScreenHeight(context) * 0.1,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(tourbookings.tourImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tourbookings.tourName, 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Date: ${tourbookings.travelDate}", 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.w500, 
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "Payment: ", 
                            style: TextStyle(
                              color: Colors.black, 
                              fontWeight: FontWeight.w500, 
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "${tourbookings.fullyPaid == 0 ? 'Half Payment' : 'Completed'}", 
                            style: TextStyle(
                              color: tourbookings.fullyPaid == 0 ? Colors.red : const Color.fromARGB(255, 103, 178, 105), 
                              fontWeight: FontWeight.bold, 
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Total Price: RM ${NumberFormat('#,##0.00').format(tourbookings.totalPrice)}", 
                    style: TextStyle(
                      color: Colors.black, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (status == 0) ...[
                          if (tourbookings.fullyPaid == 0)
                            SizedBox(
                              height: 30, // Set the button height
                              child: TextButton(
                                onPressed: (){
                                  showDialog(
                                    context: context, 
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text(
                                          "Please note that payments are non-refundable once the booking is canceled after full payment is made. Kindly ensure that all details are thoroughly checked before proceeding.",
                                          textAlign: TextAlign.justify,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: primaryColor, // Set the background color
                                              foregroundColor: Colors.white, // Set the text color
                                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                              ),
                                            ),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                              // showPaymentOption(context, 'RM 1000.00', (selectedOption) {
                                              //   bookTour(); // Call bookTour when payment option is selected
                                              // });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: primaryColor, // Set the background color
                                              foregroundColor: Colors.white, // Set the text color
                                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                              ),
                                            ),
                                            child: const Text("Pay"),
                                          ),
                                        ],
                                      );
                                    }
                                  );
                                }, 
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Color(0xFF749CB9),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text(
                                  "Pay", 
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          SizedBox(width: 5), // Space between buttons
                          SizedBox(
                            height: 30, // Set the button height
                            child: TextButton(
                              onPressed: (){
                                showDialog(
                                  context: context, 
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Text('Confirmation'),
                                      content: Text(
                                        "Please noted that the deposit of RM1000.00 will not be refunded once you can this booking. Are you sure you still want to cancel this booking?",
                                        textAlign: TextAlign.justify,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: primaryColor, // Set the background color
                                            foregroundColor: Colors.white, // Set the text color
                                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                            ),
                                          ),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                            // showPaymentOption(context, 'RM 1000.00', (selectedOption) {
                                            //   bookTour(); // Call bookTour when payment option is selected
                                            // });
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: primaryColor, // Set the background color
                                            foregroundColor: Colors.white, // Set the text color
                                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                            ),
                                          ),
                                          child: const Text("Confirm"),
                                        ),
                                      ],
                                    );
                                  }
                                );
                              }, 
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                backgroundColor: Colors.white,
                                foregroundColor: Color(0xFF749CB9),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                "Cancel Booking", 
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ] else if (status == 1) 
                          SizedBox(
                            height: 30, // Set the button height
                            child: TextButton(
                              onPressed: (){}, 
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                backgroundColor: Colors.white,
                                foregroundColor: Color(0xFF749CB9),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                "Write a Review", 
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        else
                          SizedBox.shrink(),  // Return an empty widget when no buttons are required
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      )
    );
  }

  Widget carComponent({required carRentalBooking carRentalbookings, required int status}){
    return GestureDetector(
      onTap: (){
        // Navigator.push(
        //   context, 
        //   MaterialPageRoute(builder: (context) => ViewTourDetailsScreen(userId: widget.userID, countryName: tourPackage.countryName, cityName: tourPackage.cityName, tourID: tourPackage.tourID, fromAppLink: 'false',))
        // );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border.all(color: Colors.grey.shade200, width: 1.5),
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ID: ${carRentalbookings.carRentalBookingID}",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: status == 0 ? Colors.orange.shade100 : status == 1 ? Colors.green.shade100 : status == 2 ? Colors.red.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(
                      status == 0 ? "Upcoming" : status == 1 ? "Completed" : status == 2 ? "Canceled" : "Unknown",
                      style: TextStyle(
                        color: status == 0 ? Colors.orange : status == 1 ? Colors.green : status == 3 ? Colors.red : Colors.grey.shade900,
                        fontSize: 10,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  )
                ],
              )
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: getScreenWidth(context) * 0.2,
                    height: getScreenHeight(context) * 0.12,
                    margin: EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(carRentalbookings.carImage),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carRentalbookings.carName, 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Date: ${carRentalbookings.bookingDate}", 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.w500, 
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                    ],
                  )
                ],
              )
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Total Price: RM ${NumberFormat('#,##0.00').format(carRentalbookings.totalPrice)}", 
                    style: TextStyle(
                      color: Colors.black, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: status == 0
                      ? SizedBox(
                          height: 30, // Set the button height
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context, 
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('Confirmation'),
                                    content: Text(
                                      "Please noted that a cancellation fee of RM100.00 will be deducted from the total price which means that you will only received RM${NumberFormat('#,##0.00').format((carRentalbookings.totalPrice - 100))}. Are you sure you still want to cancel this booking?",
                                      textAlign: TextAlign.justify,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryColor, // Set the background color
                                          foregroundColor: Colors.white, // Set the text color
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                          ),
                                        ),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                          // showPaymentOption(context, 'RM 1000.00', (selectedOption) {
                                          //   bookTour(); // Call bookTour when payment option is selected
                                          // });
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryColor, // Set the background color
                                          foregroundColor: Colors.white, // Set the text color
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                          ),
                                        ),
                                        child: const Text("Confirm"),
                                      ),
                                    ],
                                  );
                                }
                              );
                            }, 
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF749CB9),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Cancel Booking", 
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : status == 1
                        ? SizedBox(
                          height: 30, // Set the button height
                          child: TextButton(
                            onPressed: () {}, 
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF749CB9),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Write a Review", 
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : SizedBox.shrink(), // Return an empty widget when no buttons are required
                  )
                ],
              ),
            )
          ],
        )
      )
    );
  }

  Widget localBuddyComponent({required localBuddyBooking localBuddyBookings, required int status}){
    return GestureDetector(
      onTap: (){
        // Navigator.push(
        //   context, 
        //   MaterialPageRoute(builder: (context) => ViewTourDetailsScreen(userId: widget.userID, countryName: tourPackage.countryName, cityName: tourPackage.cityName, tourID: tourPackage.tourID, fromAppLink: 'false',))
        // );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border.all(color: Colors.grey.shade200, width: 1.5),
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ID: ${localBuddyBookings.localBuddyBookingID}",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: status == 0 ? Colors.orange.shade100 : status == 1 ? Colors.green.shade100 : status == 2 ? Colors.red.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(
                      status == 0 ? "Upcoming" : status == 1 ? "Completed" : status == 2 ? "Canceled" : "Unknown",
                      style: TextStyle(
                        color: status == 0 ? Colors.orange : status == 1 ? Colors.green : status == 3 ? Colors.red : Colors.grey.shade900,
                        fontSize: 10,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  )
                ],
              )
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: getScreenWidth(context) * 0.15,
                    height: getScreenHeight(context) * 0.1,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(localBuddyBookings.localBuddyImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localBuddyBookings.localBuddyName, 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Date: ${localBuddyBookings.bookingDate}", 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.w500, 
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Location: ${localBuddyBookings.locationArea}", 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.w500, 
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                    ],
                  )
                ],
              )
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Total Price: RM ${NumberFormat('#,##0.00').format(localBuddyBookings.totalPrice)}", 
                    style: TextStyle(
                      color: Colors.black, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: status == 0
                      ? SizedBox(
                          height: 30, // Set the button height
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context, 
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('Confirmation'),
                                    content: Text(
                                      "Please noted that a cancellation fee of RM100.00 will be deducted from the total price which means that you will only received RM${NumberFormat('#,##0.00').format((localBuddyBookings.totalPrice - 100))}. Are you sure you still want to cancel this booking?",
                                      textAlign: TextAlign.justify,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryColor, // Set the background color
                                          foregroundColor: Colors.white, // Set the text color
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                          ),
                                        ),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                          // showPaymentOption(context, 'RM 1000.00', (selectedOption) {
                                          //   bookTour(); // Call bookTour when payment option is selected
                                          // });
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryColor, // Set the background color
                                          foregroundColor: Colors.white, // Set the text color
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                          ),
                                        ),
                                        child: const Text("Confirm"),
                                      ),
                                    ],
                                  );
                                }
                              );
                            }, 
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF749CB9),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Cancel Booking", 
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : status == 1
                        ? SizedBox(
                          height: 30, // Set the button height
                          child: TextButton(
                            onPressed: () {}, 
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF749CB9),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Write a Review", 
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : SizedBox.shrink(), // Return an empty widget when no buttons are required
                  )
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}

