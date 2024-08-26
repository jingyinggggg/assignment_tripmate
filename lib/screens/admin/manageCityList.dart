import 'package:assignment_tripmate/screens/admin/addCity.dart';
import 'package:assignment_tripmate/screens/admin/manageCountryList.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminManageCityListScreen extends StatefulWidget{
  final String userId;
  final String countryName;

  const AdminManageCityListScreen({super.key, required this.userId, required this.countryName});

  @override
  State<AdminManageCityListScreen> createState() => _AdminManageCityListScreenState();

}

class _AdminManageCityListScreenState extends State<AdminManageCityListScreen> {
    List<City> _cityList = [];
    List<City> _foundedCity = [];

  @override
  void initState() {
    super.initState();
    fetchCityList();
    setState(() {
      _foundedCity = _cityList;
    });
  }

  Future<void> fetchCityList() async {
    try {
      // Reference to the countries collection in Firestore
      CollectionReference citiesRef = FirebaseFirestore.instance.collection('countries').doc(widget.countryName).collection("cities");

      // Fetch the documents from the countries collection
      QuerySnapshot querySnapshot = await citiesRef.get();

      // Convert each document into a Country object and add to _countryList
      _cityList = querySnapshot.docs.map((doc) {
        return City(
          doc['city_name'],
          doc['cityID'],
          doc['cityImage'],
        );
      }).toList();

      // Update _foundedCountry
      setState(() {
        _foundedCity = _cityList;
      });
    } catch (e) {
      // Handle any errors
      print('Error fetching country list: $e');
    }
  }

  void onSearch(String search) {
    setState(() {
      _foundedCity = _cityList
          .where((city) =>
              city.cityName.toUpperCase().contains(search.toUpperCase()))
          .toList();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("City List"),
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
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => AdminManageCountryListScreen(userId: widget.userId))
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
                      // fillColor: Color.fromARGB(255, 218, 232, 243),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2), // Set the border color to black
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2), // Black border when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFF467BA1), width: 2), // Black border when focused
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red, width: 2), // Red border for error state
                      ),
                      hintText: "Search city...",
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
                padding: const EdgeInsets.only(right: 10.0), // Adds padding to the right
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Aligns the button to the rightmost side
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => AdminAddCityScreen(userId: widget.userId, country: widget.countryName,))
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF467BA1), // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                          side: BorderSide(color: Color(0xFF467BA1), width: 2),
                        ),
                      ),
                      child: Text(
                        "Add City",
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
          Container(
            padding: EdgeInsets.only(right: 10, left: 15, top:140),
            child: ListView.builder(
              itemCount: _foundedCity.length,
              itemBuilder: (context, index) {
                return cityComponent(city: _foundedCity[index]);
              }
            ),
          ),
          // Container(
          //   padding: EdgeInsets.only(right: 10, left: 15, top:140),
          //   child: ListView.builder(
          //     itemCount: _foundedCountry.length,
          //     itemBuilder: (context, index) {
          //       return countryComponent(country: _foundedCountry[index]);
          //     }
          //   ),
          // ),
        ]
      )
    );
  }

    Widget cityComponent({required City city}) {
    return Container(
      // color: Colors.white,
      padding: EdgeInsets.only(bottom: 15, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 90,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  image: DecorationImage(
                    image: NetworkImage(city.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 20), // Spacing between image and text
              Text(
                city.cityName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: (){
                  // Navigator.push(
                  //   context, 
                  //   MaterialPageRoute(builder: (context) => AdminManageCityListScreen(userId: widget.userId, countryName: country.countryName))
                  // );
                }, 
                icon: Icon(Icons.remove_red_eye),
                iconSize: 25,
                color: Colors.grey.shade600,
              ),
              IconButton(
                onPressed: (){}, 
                icon: Icon(Icons.edit_document),
                iconSize: 25,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ],
      ),
    );
  }

}