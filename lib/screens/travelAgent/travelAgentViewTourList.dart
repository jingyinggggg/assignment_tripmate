import 'package:assignment_tripmate/screens/travelAgent/travelAgentAddTourPackage.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentViewCity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TravelAgentViewTourListScreen extends StatefulWidget {
  final String userId;
  final String countryName;
  final String cityName;

  const TravelAgentViewTourListScreen({super.key, required this.userId, required this.countryName, required this.cityName});

  @override
  State<StatefulWidget> createState() => _TravelAgentViewTourListScreenState();
}

class _TravelAgentViewTourListScreenState extends State<TravelAgentViewTourListScreen>{
  bool isLoading = true; 
  String? companyId;

  @override
  void initState() {
    super.initState();
    fetchCompanyID();
  }

  Future<void> fetchCompanyID() async {
    try {
      // Reference to the specific document in the travelAgent collection
      DocumentReference companyIDRef = FirebaseFirestore.instance.collection('travelAgent').doc(widget.userId);

      // Fetch the document snapshot
      DocumentSnapshot documentSnapshot = await companyIDRef.get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        setState(() {
          companyId = documentSnapshot.get("id").toString();
        });
        print('Company ID: $companyId');
      } else {
        print('No such document exists.');
      }

      setState(() {
        isLoading = false;  // Stop loading when the data is fetched
      });

    } catch (e) {
      // Handle any errors
      print('Error fetching company ID: $e');
      setState(() {
        isLoading = false;  // Stop loading in case of an error
      });
    }
  }

  @override
  Widget build(BuildContext content){
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Group Tour"),
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
              MaterialPageRoute(builder: (context) => TravelAgentViewCityScreen(userId: widget.userId, countryName: widget.countryName,))
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30,),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => TravelAgentAddTourPackageScreen(userId: widget.userId, countryName: widget.countryName, cityName: widget.cityName,))
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('countries')
            .doc(widget.countryName)
            .collection('cities')
            .doc(widget.cityName)
            .collection('tourPackage')
            .doc(companyId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(
              child: Text(
                "No tour package uploaded in the selected cities.",
                style: TextStyle(
                  fontSize: 16
                ),
              )
            );
          }

          var tourData = snapshot.data!.data() as Map<String, dynamic>;

          return Stack(
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

                ],
              )
            ]

          );
        }
      )
    );
  }
}