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
  bool isFetching = false;

  @override
  void initState(){
    super.initState();
    _fetchTourBooking();
    _fetchCarRentalBooking();
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

  // Fetch tour bookings
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


  @override
  Widget build(BuildContext content) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
              child: Container(
                height: 50,
                child: TextField(
                  // controller: _searchController, // Bind search controller
                  // onChanged: (value) {
                  //   setState(() {}); // Trigger the UI update on text change
                  // },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blueGrey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blueGrey, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF467BA1), width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    hintText: "Search bookings ...",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const TabBar(
              labelColor: Color(0xFF467BA1),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF467BA1),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
              tabs: [
                Tab(text: "Upcoming"),
                Tab(text: "Completed"),
                Tab(text: "Canceled"),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  isFetching
                    ? Center(child: CircularProgressIndicator(color: primaryColor))
                    : _tourBookingUpcoming.isNotEmpty
                      ? SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   "Tour Package", 
                                //   style: TextStyle(
                                //     color: Colors.black, 
                                //     fontWeight: FontWeight.bold, 
                                //     fontSize: defaultLabelFontSize,
                                //   ),
                                // ),
                                // ListView.builder wrapped with shrinkWrap: true and physics set to NeverScrollableScrollPhysics
                                ListView.builder(
                                  itemCount: _tourBookingUpcoming.length,
                                  shrinkWrap: true, // Allows ListView to be nested
                                  physics: NeverScrollableScrollPhysics(), // Prevents ListView from scrolling independently
                                  itemBuilder: (context, index){
                                    return tourComponent(tourbookings: _tourBookingUpcoming[index]);
                                  }
                                ),
                                
                                if(_carRentalBookingUpcoming.length != 0)...[
                                  SizedBox(height: 10),
                                  // Text(
                                  //   "Car Rental", 
                                  //   style: TextStyle(
                                  //     color: Colors.black54, 
                                  //     fontWeight: FontWeight.bold, 
                                  //     fontSize: defaultLabelFontSize,
                                  //   ),
                                  // ),
                                  // ListView.builder wrapped with shrinkWrap: true and physics set to NeverScrollableScrollPhysics
                                  ListView.builder(
                                    itemCount: _carRentalBookingUpcoming.length,
                                    shrinkWrap: true, // Allows ListView to be nested
                                    physics: NeverScrollableScrollPhysics(), // Prevents ListView from scrolling independently
                                    itemBuilder: (context, index){
                                      return carComponent(carRentalbookings: _carRentalBookingUpcoming[index]);
                                    }
                                  ),
                                ]
                              ],
                            )
                          ),
                        )
                      : Center(child: Text('No upcoming bookings found.')),

                  // Completed Tab
                  isFetching
                    ? Center(child: CircularProgressIndicator(color: primaryColor))
                    : _tourBookingCompleted.isNotEmpty
                      ? SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tour Package", 
                                  style: TextStyle(
                                    color: Colors.black, 
                                    fontWeight: FontWeight.bold, 
                                    fontSize: defaultLabelFontSize,
                                  ),
                                ),
                                // ListView.builder wrapped with shrinkWrap: true and physics set to NeverScrollableScrollPhysics
                                ListView.builder(
                                  itemCount: _tourBookingCompleted.length,
                                  shrinkWrap: true, // Allows ListView to be nested
                                  physics: NeverScrollableScrollPhysics(), // Prevents ListView from scrolling independently
                                  itemBuilder: (context, index){
                                    return tourComponent(tourbookings: _tourBookingCompleted[index]);
                                  }
                                ),
                              ],
                            )
                          ),
                        )
                      : Center(child: Text('No completed bookings found.')),

                  // Canceled Tab
                  isFetching
                    ? Center(child: CircularProgressIndicator(color: primaryColor))
                    : _tourBookingCanceled.isNotEmpty
                      ? SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tour Package", 
                                  style: TextStyle(
                                    color: Colors.black, 
                                    fontWeight: FontWeight.bold, 
                                    fontSize: defaultLabelFontSize,
                                  ),
                                ),
                                // ListView.builder wrapped with shrinkWrap: true and physics set to NeverScrollableScrollPhysics
                                ListView.builder(
                                  itemCount: _tourBookingCanceled.length,
                                  shrinkWrap: true, // Allows ListView to be nested
                                  physics: NeverScrollableScrollPhysics(), // Prevents ListView from scrolling independently
                                  itemBuilder: (context, index){
                                    return tourComponent(tourbookings: _tourBookingCanceled[index]);
                                  }
                                ),
                              ],
                            )
                          ),
                        )
                      : Center(child: Text('No canceled bookings found.')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tourComponent({required tourBooking tourbookings}){
    return GestureDetector(
      onTap: (){
        // Navigator.push(
        //   context, 
        //   MaterialPageRoute(builder: (context) => ViewTourDetailsScreen(userId: widget.userID, countryName: tourPackage.countryName, cityName: tourPackage.cityName, tourID: tourPackage.tourID, fromAppLink: 'false',))
        // );
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1.5))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Wrap this inner Row with Expanded to make sure it takes the available space
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image container with fixed width and height
                  Container(
                    width: getScreenWidth(context) * 0.23,
                    height: getScreenHeight(context) * 0.15,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(tourbookings.tourImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Text widget wrapped in Expanded to take remaining space
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tourbookings.tourName, 
                          style: TextStyle(
                            color: Colors.black, 
                            fontWeight: FontWeight.bold, 
                            fontSize: defaultLabelFontSize,
                          ),
                          overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Date: ${tourbookings.travelDate}", 
                          style: TextStyle(
                            color: Colors.black, 
                            fontWeight: FontWeight.w500, 
                            fontSize: defaultFontSize,
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
                                fontSize: defaultFontSize,
                              ),
                            ),
                            Text(
                              "${tourbookings.fullyPaid == 0 ? 'Half Payment' : 'Completed'}", 
                              style: TextStyle(
                                color: tourbookings.fullyPaid == 0 ? Colors.red : const Color.fromARGB(255, 103, 178, 105), 
                                fontWeight: FontWeight.bold, 
                                fontSize: defaultFontSize,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Price: RM ${NumberFormat('#,##0.00').format((tourbookings.totalPrice / tourbookings.pax))}", 
                              style: TextStyle(
                                color: Colors.black, 
                                fontWeight: FontWeight.w500, 
                                fontSize: defaultFontSize,
                              ),
                              overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                            ),
                              Text(
                              "Pax: ${tourbookings.pax}", 
                              style: TextStyle(
                                color: Colors.black, 
                                fontWeight: FontWeight.w500, 
                                fontSize: defaultFontSize,
                              ),
                              overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Total Price: RM ${NumberFormat('#,##0.00').format(tourbookings.totalPrice)}", 
                            style: TextStyle(
                              color: Colors.black, 
                              fontWeight: FontWeight.bold, 
                              fontSize: defaultFontSize,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                    
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget carComponent({required carRentalBooking carRentalbookings}){
    return GestureDetector(
      onTap: (){
        // Navigator.push(
        //   context, 
        //   MaterialPageRoute(builder: (context) => ViewTourDetailsScreen(userId: widget.userID, countryName: tourPackage.countryName, cityName: tourPackage.cityName, tourID: tourPackage.tourID, fromAppLink: 'false',))
        // );
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1.5))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Wrap this inner Row with Expanded to make sure it takes the available space
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image container with fixed width and height
                  Container(
                    width: getScreenWidth(context) * 0.23,
                    height: getScreenHeight(context) * 0.11,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(carRentalbookings.carImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Text widget wrapped in Expanded to take remaining space
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          carRentalbookings.carName, 
                          style: TextStyle(
                            color: Colors.black, 
                            fontWeight: FontWeight.bold, 
                            fontSize: defaultLabelFontSize,
                          ),
                          overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Date: ${carRentalbookings.bookingDate}", 
                          style: TextStyle(
                            color: Colors.black, 
                            fontWeight: FontWeight.w500, 
                            fontSize: defaultFontSize,
                          ),
                          overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                        ),
                        SizedBox(height: 5),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Total Price: RM ${NumberFormat('#,##0.00').format(carRentalbookings.totalPrice)}", 
                            style: TextStyle(
                              color: Colors.black, 
                              fontWeight: FontWeight.bold, 
                              fontSize: defaultFontSize,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                    
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

