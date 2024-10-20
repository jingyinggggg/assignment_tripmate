import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentHomepage.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentViewBookingDetails.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TravelAgentViewBookingListScreen extends StatefulWidget {
  final String userId;

  const TravelAgentViewBookingListScreen({
    super.key, 
    required this.userId,
  });

  @override
  State<TravelAgentViewBookingListScreen> createState() => _TravelAgentViewBookingListScreenState();
}

class _TravelAgentViewBookingListScreenState extends State<TravelAgentViewBookingListScreen> {
  List<TravelAgentTourBookingList> tourBookingList = [];
  List<TravelAgentCarRentalBookingList> carRentalBookingList = [];
  bool isFetchingTour = false;
  bool isFetchingCarRental = false;

  @override
  void initState() {
    super.initState();
    _fetchTourBookingList();
    _fetchCarRentalBookingList();
  }

  Future<void> _fetchTourBookingList() async {
    setState(() {
      isFetchingTour = true;
    });

    try {
      // Fetch all tour packages uploaded by the current user
      CollectionReference tourRef = FirebaseFirestore.instance.collection('tourPackage');
      QuerySnapshot querySnapshot = await tourRef.where('agentID', isEqualTo: widget.userId).get();

      List<TravelAgentTourBookingList> tourBookingLists = [];

      // Loop through each tour package
      for (var doc in querySnapshot.docs) {
        // Extract tour details
        TravelAgentTourBookingList tourPackage = TravelAgentTourBookingList.fromFirestore(doc);

        // Fetch all bookings related to the current tourID
        CollectionReference tourBookingRef = FirebaseFirestore.instance.collection('tourBooking');
        QuerySnapshot tourBookingSnapshot = await tourBookingRef.where('tourID', isEqualTo: tourPackage.tourID).get();

        // Sum the total number of bookings for the current tour package
        int totalBookingCount = tourBookingSnapshot.size;

        // Update the totalBookingNumber for the tourPackage
        tourPackage.totalBookingNumber = totalBookingCount;

        // Add the tour package with booking info to the list
        tourBookingLists.add(tourPackage);
      }

      // After fetching all data, update the state
      setState(() {
        isFetchingTour = false;
        // Update the list with fetched data (assuming you have a list for display)
        tourBookingList = tourBookingLists;
      });

    } catch (e) {
      setState(() {
        isFetchingTour = false;
      });
      print('Error fetching tour booking list: $e');
    }
  }

  Future<void> _fetchCarRentalBookingList() async {
    setState(() {
      isFetchingCarRental = true;
    });

    try {
      // Fetch all car rental uploaded by the current user
      CollectionReference carRentalRef = FirebaseFirestore.instance.collection('car_rental');
      QuerySnapshot querySnapshot = await carRentalRef.where('agencyID', isEqualTo: widget.userId).get();

      List<TravelAgentCarRentalBookingList> carRentalBookingLists = [];

      // Loop through each car rental
      for (var doc in querySnapshot.docs) {
        // Extract car details
        TravelAgentCarRentalBookingList carRental = TravelAgentCarRentalBookingList.fromFirestore(doc);

        // Fetch all bookings related to the current carID
        CollectionReference carRentalBookingRef = FirebaseFirestore.instance.collection('carRentalBooking');
        QuerySnapshot carRentalBookingSnapshot = await carRentalBookingRef.where('carID', isEqualTo: carRental.carRentalID).get();

        // Sum the total number of bookings for the current car rental
        int totalBookingCount = carRentalBookingSnapshot.size;

        // Update the totalBookingNumber for the carRental
        carRental.totalBookingNumber = totalBookingCount;

        // Add the tour package with booking info to the list
        carRentalBookingLists.add(carRental);
      }

      // After fetching all data, update the state
      setState(() {
        isFetchingCarRental = false;
        // Update the list with fetched data (assuming you have a list for display)
        carRentalBookingList = carRentalBookingLists;
      });

    } catch (e) {
      setState(() {
        isFetchingCarRental = false;
      });
      print('Error fetching tour booking list: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 241, 246, 249),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Booking"),
          centerTitle: true,
          backgroundColor: const Color(0xFF749CB9),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Inika',
            fontWeight: FontWeight.bold,
            fontSize: defaultAppBarTitleFontSize,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TravelAgentHomepageScreen(userId: widget.userId))
              );
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Container(
              height: 50,
              color: Colors.white,
              child: TabBar(
                tabs: [
                  Tab(
                    child: Text("Tour Package"),
                  ),
                  Tab(
                    child: Text("Car Rental"),
                  )
                ],
                labelColor: primaryColor,
                indicatorColor: primaryColor,
                indicatorWeight: 2,
                unselectedLabelColor: Color(0xFFA4B4C0), // Unselected tab text color
                indicatorPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelStyle: TextStyle(fontSize: defaultFontSize),
                labelStyle: TextStyle(fontSize: defaultFontSize),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              child: isFetchingTour
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : tourBookingList.isEmpty
                ? Center(child: Text('No tour booking in the system.', style: TextStyle(fontSize: defaultFontSize, color: Colors.black)))
                : ListView.builder(
                    itemCount: tourBookingList.length,
                    itemBuilder: (context, index) {
                      return TourBookingComponent(tourBooking: tourBookingList[index]);
                    }
                  ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: isFetchingCarRental
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : tourBookingList.isEmpty
                ? Center(child: Text('No car rental booking in the system.', style: TextStyle(fontSize: defaultFontSize, color: Colors.black)))
                : ListView.builder(
                    itemCount: carRentalBookingList.length,
                    itemBuilder: (context, index) {
                      return CarRentalBookingComponent(carRentalBooking: carRentalBookingList[index]);
                    }
                  ),
            ),
          ],
        ),
      )
    );
  }

  Widget TourBookingComponent({required TravelAgentTourBookingList tourBooking}){
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => TravelAgentViewBookingDetailsScreen(userId: widget.userId, tourID: tourBooking.tourID, totalBookingNumber: tourBooking.totalBookingNumber,))
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.5))
              ),
              child: Text(
                "Tour Package ID: ${tourBooking.tourID}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: getScreenWidth(context) * 0.18,
                    height: getScreenHeight(context) * 0.13,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(tourBooking.tourImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tourBooking.tourName, 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.w800, 
                          fontSize: defaultFontSize,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Total Bookings: ${tourBooking.totalBookingNumber}", 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.w500, 
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                    ],
                  )
                ],
              )
            ),
          ],
        )
      )
    );
  }

  Widget CarRentalBookingComponent({required TravelAgentCarRentalBookingList carRentalBooking}){
    return GestureDetector(
      onTap: (){},
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.5))
              ),
              child: Text(
                "Car Rental ID: ${carRentalBooking.carRentalID}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: getScreenWidth(context) * 0.3,
                    height: getScreenHeight(context) * 0.15,
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(carRentalBooking.carImage),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carRentalBooking.carName, 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.w800, 
                          fontSize: defaultFontSize,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Total Bookings: ${carRentalBooking.totalBookingNumber}", 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.w500, 
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                    ],
                  )
                ],
              )
            ),
          ],
        )
      )
    );
  }
}