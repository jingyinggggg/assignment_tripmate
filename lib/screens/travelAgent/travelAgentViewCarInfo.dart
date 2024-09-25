import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentAddCarInfo.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentEditCarInfo.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentHomepage.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TravelAgentViewCarListingScreen extends StatefulWidget {
  final String userId;

  const TravelAgentViewCarListingScreen({
    super.key,
    required this.userId,
  });

  @override
  State<StatefulWidget> createState() => _TravelAgentViewCarListingScreenState();
}

class _TravelAgentViewCarListingScreenState extends State<TravelAgentViewCarListingScreen>{
  List<CarList> _carList = [];
  List<CarList> _foundedCar = [];

  @override
  void initState(){
    super.initState();
    fetchCarList();
    setState(() {
      _foundedCar = _carList;
    });
  }
  Future<void> fetchCarList() async {
    try {
      // Reference to the car_rental collection in Firestore
      CollectionReference carRef = FirebaseFirestore.instance.collection('car_rental');

      // Fetch the documents from the car_rental collection
      QuerySnapshot querySnapshot = await carRef.where('agencyID', isEqualTo: widget.userId).get();

      // Convert each document into a Car List object and add to _carList
      _carList = querySnapshot.docs.map((doc) {
        return CarList(
          doc['carID'],
          doc['carModel']
        );
      }).toList();

      // Update _foundedCar
      setState(() {
        _foundedCar = _carList;
      });
    } catch (e) {
      // Handle any errors
      print('Error fetching car list: $e');
    }
  }

  void onSearch(String search) {
    setState(() {
      _foundedCar = _carList
          .where((carList) =>
              carList.carModel.toUpperCase().contains(search.toUpperCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
            appBar: AppBar(
        title: const Text("Car Listing"),
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30,),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => TravelAgentAddCarInfoScreen(userId: widget.userId))
              );
            },
          ),
        ]
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 20),
            child: Container(
              height: 60,
              child: TextField(
                onChanged: (value) => onSearch(value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
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
                  hintText: "Search car listing...",
                  hintStyle: TextStyle(
                    fontSize: defaultFontSize,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _foundedCar.isNotEmpty
                ? ListView.builder(
                    itemCount: _foundedCar.length,
                    itemBuilder: (context, index) {
                      return carComponent(
                        carList: _foundedCar[index],
                        isLast: index == _foundedCar.length - 1,
                        rowNumber: index + 1,
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "No car listings added in the system yet.",
                      style: TextStyle(
                        fontSize: defaultFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget carComponent({required CarList carList, bool isLast = false, required int rowNumber}) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20), // Padding around the row
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Background color
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Adjust shadow color and opacity as needed
            blurRadius: 4.0,
            offset: Offset(0, -2), // Shadow above the container
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Display the row number
              Text(
                '$rowNumber. ', // Adding the row number
                style: TextStyle(
                  fontSize: defaultLabelFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // You can customize the color if needed
                ),
              ),
              SizedBox(width: 10),
              Text(
                carList.carModel,
                style: TextStyle(
                  fontSize: defaultLabelFontSize,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: null,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 35, // Set a specific width to reduce space
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => TravelAgentEditCarInfoScreen(userId: widget.userId, carId: carList.carID))
                    );
                  },
                  icon: Icon(Icons.edit_document),
                  iconSize: 20,
                  color: Colors.grey.shade600,
                  tooltip: "Edit",
                  padding: EdgeInsets.zero,
                ),
              ),
              Container(
                width: 35, // Set a specific width to reduce space
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.build),
                  iconSize: 20,
                  color: Colors.grey.shade600,
                  tooltip: "Maintenance",
                  padding: EdgeInsets.zero,
                ),
              ),
              Container(
                width: 35, // Set a specific width to reduce space
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                  iconSize: 20,
                  color: Colors.grey.shade600,
                  tooltip: "Delete",
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}