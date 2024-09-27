import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/user/carRentalDetails.dart';
import 'package:assignment_tripmate/screens/user/homepage.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CarRentalHomepageScreen extends StatefulWidget {
  final String userId;

  const CarRentalHomepageScreen({
    super.key,
    required this.userId,
  });

  @override
  State<StatefulWidget> createState() => _CarRentalHomepageScreenState();
}

class _CarRentalHomepageScreenState extends State<CarRentalHomepageScreen>{
  List<CarList> _carList = [];
  List<CarList> _foundedCar = [];
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    fetchCarList();
    setState(() {
      _foundedCar = _carList;
    });
  }

  Future<void> fetchCarList() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Reference to the car_rental and travelAgent collections
      CollectionReference carRef = FirebaseFirestore.instance.collection('car_rental');
      CollectionReference agentRef = FirebaseFirestore.instance.collection('travelAgent');

      // Fetch the documents from the car_rental collection
      QuerySnapshot querySnapshot = await carRef.get();

      // Create a list of car rentals
      List<CarList> _carList = querySnapshot.docs.map((doc) {
        return CarList(
          doc['carID'] ?? '',
          doc['carModel'] ?? 'Unknown Model',
          carImage: doc['carImage'],
          carType: doc['carType'],
          fuel: doc['fuel'],
          transmission: doc['transmission'],
          seat: doc['seat'],
          price: doc['pricePerDay'],
          agentID: doc['agencyID'],
          agencyName: doc['agencyName'],
          pickUpLocation: doc['pickUpLocation']
        );
      }).toList();

      // Update _foundedCar
      setState(() {
        _foundedCar = _carList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
        title: const Text("Car Rental"),
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
              MaterialPageRoute(builder: (context) => UserHomepageScreen(userId: widget.userId))
            );
          },
        ),
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
                  hintText: "Search car...",
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
            child: isLoading
              ? Center(child: CircularProgressIndicator())
              : _foundedCar.isNotEmpty
                ? Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: ListView.builder(
                    itemCount: _foundedCar.length,
                    itemBuilder: (context, index) {
                      return carComponent(
                        carList: _foundedCar[index],
                        isLast: index == _foundedCar.length - 1,
                        rowNumber: index + 1,
                      );
                    },
                  )
                )
                : Center(
                    child: Text(
                      "No car exist in the system yet.",
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

Widget carComponent({
  required CarList carList,
  bool isLast = false,
  required int rowNumber,
}) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;

  return InkWell(
    onTap: () {
      // Navigate to another page when tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CarRentalDetailsScreen(userId: widget.userId, carId: carList.carID,)),
      );
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 15), // Space between containers
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Padding around the content
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        border: Border.all(color: Colors.grey.shade500, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center( // Align image to the center
            child: Container(
              width: screenWidth * 0.85,
              height: screenHeight * 0.25,
              alignment: Alignment.center, // Center the content inside
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(carList.carImage!),
                  fit: BoxFit.cover, // Ensure the image scales down but retains aspect ratio
                ),
              ),
            ),
          ),
          SizedBox(height: 10), // Add space between image and text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${carList.carModel} - ${carList.carType}',
                style: TextStyle(
                  fontSize: defaultLabelFontSize, // Adjusted font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Customize the color if needed
                ),
                textAlign: TextAlign.left, // Ensure the text aligns to the start
              ),
              Text(
                'RM${(carList.price ?? 0).toStringAsFixed(0)}/day',
                style: TextStyle(
                  fontSize: defaultFontSize, // Adjusted font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Customize the color if needed
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            'Provider: ${carList.agencyName}',
            style: TextStyle(
              fontSize: defaultFontSize,
              color: Colors.black,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildInfoContainer(
                image: carList.transmission == "Auto"
                    ? AssetImage("images/automatic-transmission.png")
                    : AssetImage("images/gearbox.png"),
                text: carList.transmission ?? '',
              ),
              SizedBox(width: 10),
              buildInfoContainer(
                image: carList.fuel == "Petrol"
                    ? AssetImage("images/gasoline.png")
                    : carList.fuel == "Electricity"
                        ? AssetImage("images/charging-station.png")
                        : AssetImage("images/hybrid-car.png"),
                text: carList.fuel ?? '',
              ),
              SizedBox(width: 10),
              buildInfoContainer(
                image: AssetImage("images/car-seat.png"),
                text: '${carList.seat.toString()} Seats',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildInfoContainer({required AssetImage image, required String text}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    height: 40,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: primaryColor, width: 1.5),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(image: image, width: 18, height: 18),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: defaultCarRentalFontSize, // Adjusted font size
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}

}