import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentHomepage.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TravelAgentViewAnalyticsChartScreen extends StatefulWidget {
  final String userId;

  const TravelAgentViewAnalyticsChartScreen({
    super.key,
    required this.userId,
  });

  @override
  State<TravelAgentViewAnalyticsChartScreen> createState() => _TravelAgentViewAnalyticsChartScreenState();
}

class _TravelAgentViewAnalyticsChartScreenState extends State<TravelAgentViewAnalyticsChartScreen> {
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
      CollectionReference tourRef = FirebaseFirestore.instance.collection('tourPackage');
      QuerySnapshot querySnapshot = await tourRef.where('agentID', isEqualTo: widget.userId).get();
      List<TravelAgentTourBookingList> tourBookingLists = [];

      for (var doc in querySnapshot.docs) {
        TravelAgentTourBookingList tourPackage = TravelAgentTourBookingList.fromFirestore(doc);
        CollectionReference tourBookingRef = FirebaseFirestore.instance.collection('tourBooking');
        QuerySnapshot tourBookingSnapshot = await tourBookingRef.where('tourID', isEqualTo: tourPackage.tourID).get();
        tourPackage.totalBookingNumber = tourBookingSnapshot.size;
        tourBookingLists.add(tourPackage);
      }

      setState(() {
        isFetchingTour = false;
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
      CollectionReference carRentalRef = FirebaseFirestore.instance.collection('car_rental');
      QuerySnapshot querySnapshot = await carRentalRef.where('agencyID', isEqualTo: widget.userId).get();
      List<TravelAgentCarRentalBookingList> carRentalBookingLists = [];

      for (var doc in querySnapshot.docs) {
        TravelAgentCarRentalBookingList carRental = TravelAgentCarRentalBookingList.fromFirestore(doc);
        CollectionReference carRentalBookingRef = FirebaseFirestore.instance.collection('carRentalBooking');
        QuerySnapshot carRentalBookingSnapshot = await carRentalBookingRef.where('carID', isEqualTo: carRental.carRentalID).get();
        carRental.totalBookingNumber = carRentalBookingSnapshot.size;
        carRentalBookingLists.add(carRental);
      }

      setState(() {
        isFetchingCarRental = false;
        carRentalBookingList = carRentalBookingLists;
      });
    } catch (e) {
      setState(() {
        isFetchingCarRental = false;
      });
      print('Error fetching car rental booking list: $e');
    }
  }

  // Create a pie chart for tours
  Widget _buildTourPieChart() {
    final tourData = getTourBookingData();
    final totalBookings = tourData.fold<int>(0, (sum, item) => sum + item.totalBookings);

    return PieChart(
      PieChartData(
        sections: tourData.map((data) {
          final percentage = (data.totalBookings / totalBookings) * 100;
          return PieChartSectionData(
            color: Colors.blue,
            value: data.totalBookings.toDouble(),
            title: '${data.name}\n${data.totalBookings} (${percentage.toStringAsFixed(1)}%)',
            radius: 100,
            titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          );
        }).toList(),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 0,
      ),
    );
  }

  // Create a pie chart for car rentals
  Widget _buildCarRentalPieChart() {
    final carRentalData = getCarRentalBookingData();
    final totalBookings = carRentalData.fold<int>(0, (sum, item) => sum + item.totalBookings);

    return PieChart(
      PieChartData(
        sections: carRentalData.map((data) {
          final percentage = (data.totalBookings / totalBookings) * 100;
          return PieChartSectionData(
            color: Colors.green,
            value: data.totalBookings.toDouble(),
            title: '${data.name}\n${data.totalBookings} (${percentage.toStringAsFixed(1)}%)',
            radius: 100,
            titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          );
        }).toList(),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 0,
      ),
    );
  }

  // Method to get booking data for tours
  List<BookingData> getTourBookingData() {
    return tourBookingList.map((tour) => BookingData(tour.tourName, tour.totalBookingNumber)).toList();
  }

  // Method to get booking data for car rentals
  List<BookingData> getCarRentalBookingData() {
    return carRentalBookingList.map((car) => BookingData(car.carName, car.totalBookingNumber)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Analytics"),
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
                MaterialPageRoute(builder: (context) => TravelAgentHomepageScreen(userId: widget.userId)),
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
                  Tab(child: Text("Tour Package")),
                  Tab(child: Text("Car Rental")),
                ],
                labelColor: primaryColor,
                indicatorColor: primaryColor,
                indicatorWeight: 2,
                unselectedLabelColor: Color(0xFFA4B4C0),
                indicatorPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelStyle: TextStyle(fontSize: defaultFontSize),
                labelStyle: TextStyle(fontSize: defaultFontSize),
              ),
            ),
          ),
        ),
        body: isFetchingTour || isFetchingCarRental
            ? Center(child: CircularProgressIndicator(color: primaryColor,))
            : TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Overall booking summary",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: defaultLabelFontSize,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: _buildTourPieChart(),
                          ),
                        ),
                        _buildObservation('Tour', getTourBookingData()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: _buildCarRentalPieChart(),
                          ),
                        ),
                        _buildObservation('Car Rental', getCarRentalBookingData()),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Method to build observation text below the chart
  Widget _buildObservation(String type, List<BookingData> bookingData) {
    if (bookingData.isEmpty) {
      return Text('No bookings available.');
    }
    BookingData bestSeller = bookingData.reduce((a, b) => a.totalBookings > b.totalBookings ? a : b);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Observation: The ${type.toLowerCase()} "${bestSeller.name}" has ${bestSeller.totalBookings} bookings. This is the best seller.',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class BookingData {
  final String name; // Tour name or car name
  final int totalBookings; // Total booking number

  BookingData(this.name, this.totalBookings);
}
