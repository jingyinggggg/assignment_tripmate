import 'package:assignment_tripmate/constants.dart';
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
      // Reference to the car_rental and travelAgent collections
      CollectionReference carRef = FirebaseFirestore.instance.collection('car_rental');
      CollectionReference agentRef = FirebaseFirestore.instance.collection('travelAgent');

      // Fetch the documents from the car_rental collection
      QuerySnapshot querySnapshot = await carRef.get();

      // Create a list of car rentals
      List<CarList> cars = querySnapshot.docs.map((doc) {
        return CarList(
          doc['carID'] ?? '',
          doc['carModel'] ?? 'Unknown Model',
          carImage: doc['carImage'],
          carType: doc['carType'],
          transmission: doc['transmission'],
          seat: doc['seat'],
          price: doc['pricePerDay'],
          agentID: doc['agencyID'],
        );
      }).toList();

      // Create a map to hold agency names by agentID
      Map<String, String> agentNames = {};

      // Fetch agency names for the corresponding agentIDs
      for (var car in cars) {
        String agencyID = car.agentID ?? ''; // Ensure agencyID is not null
        if (agencyID.isNotEmpty && !agentNames.containsKey(agencyID)) {
          try {
            DocumentSnapshot agentDoc = await agentRef.doc(agencyID).get();
            if (agentDoc.exists) {
              agentNames[agencyID] = agentDoc['agencyName'] ?? 'Unknown Agency'; // Handle potential null value
            }
          } catch (e) {
            print('Error fetching agency: $e'); // Handle error appropriately
          }
        }
      }

      // Now update the car list with agency names
      _carList = cars.map((car) {
        String agencyName = agentNames[car.agentID] ?? 'Unknown Agency';
        return CarList(
          car.carID,
          car.carModel,
          carImage: car.carImage,
          carType: car.carType,
          transmission: car.transmission,
          seat: car.seat,
          price: car.price,
          agentID: car.agentID,
          agencyName: agencyName, // Pass the agency name here
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

  Widget carComponent({required CarList carList, bool isLast = false, required int rowNumber}) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20), // Padding around the row
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        border: Border.all(color: Colors.grey.shade500, width: 1.5),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [

          Container(
            width: screenWidth * 0.7,
            height: screenHeight * 0.2,
            // color: Colors.grey.shade300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(carList.carImage!),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Text(
            '${carList.carModel} - ${carList.carType}' ,
            style: TextStyle(
              fontSize: defaultFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black, // You can customize the color if needed
            ),
          ),

          // Row(
          //   children: [
          //     // Display the row number
          //     Text(
          //       '$rowNumber. ', // Adding the row number
          //       style: TextStyle(
          //         fontSize: defaultLabelFontSize,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black, // You can customize the color if needed
          //       ),
          //     ),
          //     SizedBox(width: 10),
          //     Text(
          //       carList.carModel,
          //       style: TextStyle(
          //         fontSize: defaultLabelFontSize,
          //         fontWeight: FontWeight.bold,
          //       ),
          //       maxLines: null,
          //       overflow: TextOverflow.visible,
          //     ),
          //   ],
          // ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: (){}, 
                icon: Icon(Icons.edit_document),
                iconSize: 20,
                color: Colors.grey.shade600,
              ),
              IconButton(
                onPressed: (){}, 
                icon: Icon(Icons.delete),
                iconSize: 20,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}