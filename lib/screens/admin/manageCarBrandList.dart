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
  bool isLoading = true;  // Add a loading indicator flag

  @override
  void initState() {
    super.initState();
    // fetchCityList();
  }

  Future<void> fetchCarBrandList() async {
    try {
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

  // void onSearch(String search) {
  //   setState(() {
  //     _foundedCity = _cityList.where((city) => city.cityName.toUpperCase().contains(search.toUpperCase())).toList();
  //   });
  // }

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
          fontSize: 24,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            // Navigate back
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
                    // onChanged: (value) => onSearch(value),
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
                        fontSize: 16,
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
                          fontSize: 16,
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
                          "No car brand available in the system",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ) // Show message if list is empty
                    : Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10, top: 100, bottom: 30),
                        child: GridView.builder(
                          itemCount: _foundedCarBrand.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns in the grid
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 20.0,
                            childAspectRatio: 1.0, // Aspect ratio of each item (width/height)
                          ),
                          itemBuilder: (context, index) {
                            return carBrandComponent(carBrand: _foundedCarBrand[index]);
                          },
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
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              image: DecorationImage(
                image: NetworkImage(carBrand.carImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            carBrand.carName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      )
    );
  }
}

