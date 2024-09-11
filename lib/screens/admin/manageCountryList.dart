import 'package:assignment_tripmate/screens/admin/addCountry.dart';
import 'package:assignment_tripmate/screens/admin/homepage.dart';
import 'package:assignment_tripmate/screens/admin/manageCityList.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminManageCountryListScreen extends StatefulWidget {
  final String userId;

  const AdminManageCountryListScreen({super.key, required this.userId});

  @override
  State<AdminManageCountryListScreen> createState() => _AdminManageCountryListScreenState();
}

class _AdminManageCountryListScreenState extends State<AdminManageCountryListScreen> {
  List<Country> _countryList = [];
  List<Country> _foundedCountry = [];

  @override
  void initState() {
    super.initState();
    fetchCountryList();
    setState(() {
      _foundedCountry = _countryList;
    });
  }

  Future<void> fetchCountryList() async {
    try {
      // Reference to the countries collection in Firestore
      CollectionReference countriesRef = FirebaseFirestore.instance.collection('countries');

      // Fetch the documents from the countries collection
      QuerySnapshot querySnapshot = await countriesRef.get();

      // Convert each document into a Country object and add to _countryList
      _countryList = querySnapshot.docs.map((doc) {
        return Country(
          doc['name'],
          doc['countryID'],
          doc['countryImage'],
        );
      }).toList();

      // Update _foundedCountry
      setState(() {
        _foundedCountry = _countryList;
      });
    } catch (e) {
      // Handle any errors
      print('Error fetching country list: $e');
    }
  }

  void onSearch(String search) {
    setState(() {
      _foundedCountry = _countryList
          .where((country) =>
              country.countryName.toUpperCase().contains(search.toUpperCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Country List"),
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
                      hintText: "Search country...",
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
                          MaterialPageRoute(builder: (context) => AdminAddCountryScreen(userId: widget.userId))
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
                        "Add Country",
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
              itemCount: _foundedCountry.length,
              itemBuilder: (context, index) {
                return countryComponent(country: _foundedCountry[index]);
              }
            ),
          ),
        ]
      )
    );
  }

  Widget countryComponent({required Country country}) {
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
                    image: NetworkImage(country.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 20), // Spacing between image and text
              Text(
                country.countryName,
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
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => AdminManageCityListScreen(userId: widget.userId, countryName: country.countryName))
                  );
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

