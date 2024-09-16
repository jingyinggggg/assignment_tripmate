import 'package:assignment_tripmate/screens/admin/addCarBrand.dart';
import 'package:assignment_tripmate/screens/admin/homepage.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminManageCarBrandScreen extends StatefulWidget{
  final String userId;

  const AdminManageCarBrandScreen({super.key, required this.userId});

  @override
  State<AdminManageCarBrandScreen> createState() => _AdminManageCarBrandScreenState();
}

class _AdminManageCarBrandScreenState extends State<AdminManageCarBrandScreen> {
  List<CarBrand> _carBrandList = [];
  List<CarBrand> _foundedCarBrand = [];
  bool isLoading = false;  // Add a loading indicator flag

  @override
  void initState() {
    super.initState();
    fetchCarBrandList();
  }

  Future<void> fetchCarBrandList() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Reference to the cities collection in Firestore
      CollectionReference citiesRef = FirebaseFirestore.instance.collection('carBrand');

      // Fetch the documents from the cities collection
      QuerySnapshot querySnapshot = await citiesRef.get();

      // Convert each document into a City object and add to _cityList
      _carBrandList = querySnapshot.docs.map((doc) {
        return CarBrand(
          doc['carBrandID'],
          doc['carBrandImage'],
          doc['carBrandName'],
        );
      }).toList();

      setState(() {
        _foundedCarBrand = _carBrandList;
        isLoading = false;  // Stop loading when the data is fetched
      });
    } catch (e) {
      // Handle any errors
      print('Error fetching car brand list: $e');
      setState(() {
        isLoading = false;  // Stop loading in case of an error
      });
    }
  }

  void onSearch(String search) {
    setState(() {
      _foundedCarBrand = _carBrandList.where((carBrand) => carBrand.carName.toUpperCase().contains(search.toUpperCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Car Brand List"),
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminHomepageScreen(userId: widget.userId))
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
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
                      hintText: "Search car brand...",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add new brand action
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminAddCarBrandScreen(userId: widget.userId))
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF467BA1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Color(0xFF467BA1), width: 2),
                        ),
                      ),
                      child: Text(
                        "Add Brand",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Display the content based on the loading state and list data
          Positioned.fill(
            child: isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator
                : _carBrandList.isEmpty
                    ? Center(
                        child: Text(
                          "No car brand available in the system.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ) // Show message if list is empty
                    : Container(
                        padding: EdgeInsets.only(right: 10, left: 15, top:130),
                        child: ListView.builder(
                          itemCount: _foundedCarBrand.length,
                          itemBuilder: (context, index) {
                            return carBrandComponent(carBrand: _foundedCarBrand[index]);
                          }
                        ),
                      ),
          ),
        ],
      ),
    );
  }

Widget carBrandComponent({required CarBrand carBrand}) {
  return Container(
    padding: EdgeInsets.only(bottom: 15, top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.15, 
              height: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Set background color to white
                border: Border.all(color: Colors.grey.shade300, width: 1), // Optional: border around the circle
              ),
              child: ClipOval(
                child: FittedBox(
                  fit: BoxFit.contain, // Adjusts the image size to fit within the circle
                  child: Image.network(carBrand.carImage),
                ),
              ),
            ),
            SizedBox(width: 20), // Spacing between image and text
            Text(
              carBrand.carName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                // Handle view action
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => CarBrandDetailScreen(carBrand: carBrand)),
                // );
              },
              icon: Icon(Icons.remove_red_eye),
              iconSize: 20,
              color: Colors.grey.shade600,
            ),
            IconButton(
              onPressed: () {
                // Handle edit action
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => EditCarBrandScreen(carBrand: carBrand)),
                // );
              },
              icon: Icon(Icons.edit),
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

