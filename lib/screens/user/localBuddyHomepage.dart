import 'dart:convert';
import 'dart:math';
import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/user/localBuddyDetails.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:assignment_tripmate/screens/user/homepage.dart';
import 'package:assignment_tripmate/screens/user/localBuddyBottomNavigationBar.dart';
import 'package:assignment_tripmate/screens/user/localBuddyEditInfo.dart';
import 'package:assignment_tripmate/screens/user/localBuddyMeScreen.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LocalBuddyHomepageScreen extends StatefulWidget {
  final String userId;

  const LocalBuddyHomepageScreen({
    super.key,
    required this.userId,
  });

  @override
  State<StatefulWidget> createState() => _LocalBuddyHomepageScreenState();
}

class _LocalBuddyHomepageScreenState extends State<LocalBuddyHomepageScreen> {
  bool isLoading = false;
  bool isVerifyLoading = false;
  int? registrationStatus;
  int _currentIndex = 0;
  List<LocalBuddy> _localBuddyList = [];
  List<LocalBuddy> _foundedLocalBuddy = [];
  Position? _currentPosition;
  String _currentAddress = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    fetchLocalBuddyData();
    _checkCurrentUserStatus();
  }

  Future<void> fetchLocalBuddyData() async {
    setState(() {
      isLoading = true;
    });
    try {
      CollectionReference localBuddyRef = FirebaseFirestore.instance.collection('localBuddy');
      CollectionReference userRef = FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot = await localBuddyRef.where('registrationStatus', isEqualTo: 2).get();

      _localBuddyList = [];

      for (var doc in querySnapshot.docs) {
        DocumentSnapshot userSnapshot = await userRef.doc(doc['userID']).get();

        if (userSnapshot.exists) {
          _localBuddyList.add(LocalBuddy(
            localBuddyID: doc['localBuddyID'],
            localBuddyName: userSnapshot['name'],
            localBuddyImage: userSnapshot['profileImage'],
            languageSpoken: doc['languageSpoken'],
            locationArea: doc['locationArea'],
            locationAddress: doc['location'],
          ));
        }
      }

      setState(() {
        _localBuddyList;
        isLoading = false;
        _foundedLocalBuddy = _localBuddyList;
      });
    } catch (e) {
      print('Error fetching local buddy data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _checkCurrentUserStatus() async {
    setState(() {
      isVerifyLoading = true;
    });
    try {
      QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
          .collection('localBuddy')
          .where('userID', isEqualTo: widget.userId)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        var userSnapshot = userQuerySnapshot.docs.first;
        registrationStatus = userSnapshot['registrationStatus'];

        print(registrationStatus);
      } else {
        registrationStatus = null;
      }
    } catch (e) {
      print('Error checking current user: $e');
    } finally {
      setState(() {
        isVerifyLoading = false;
      });
    }
  }

  Future<Map<String, double>> getCoordinatesFromAddress(String address) async {
    final String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        double lat = location['lat'];
        double lng = location['lng'];
        return {'lat': lat, 'lng': lng};
      }
    }
    throw Exception('Failed to get coordinates for address: $response');
  }

  // // Function to get current location
  // Future<void> _getCurrentLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Check if location services are enabled
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled, don't proceed
  //     return Future.error('Location services are disabled.');
  //   }

  //   // Check location permissions
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, return error
  //       return Future.error('Location permissions are denied.');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are permanently denied, handle accordingly
  //     return Future.error('Location permissions are permanently denied.');
  //   }

  //   // Get the current position
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
  //   // Set the position
  //   setState(() {
  //     _currentPosition = position;
  //   });

  //   // Now convert the position to a human-readable address
  //   _getAddressFromLatLng(position);
  // }

  // // Function to convert lat/lng to address
  // Future<void> _getAddressFromLatLng(Position position) async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  //     Placemark place = placemarks[0];

  //     setState(() {
  //       // Combine the address parts into a readable string
  //       _currentAddress = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
  //     });
  //   } catch (e) {
  //     print('Error occurred while trying to get the address: $e');
  //     setState(() {
  //       _currentAddress = "Address not found";
  //     });
  //   }
  // }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double radiusOfEarth = 6371;
    double latDistance = (lat2 - lat1) * (pi / 180.0);
    double lonDistance = (lon2 - lon1) * (pi / 180.0);

    double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(lat1 * (pi / 180.0)) * cos(lat2 * (pi / 180.0)) *
        sin(lonDistance / 2) * sin(lonDistance / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radiusOfEarth * c;
  }

  void onSearch(String searchQuery) async {
    if (searchQuery.trim().isEmpty) {
      // If the search query is empty, reset the list to the full list of local buddies
      setState(() {
        _foundedLocalBuddy = _localBuddyList; // Reset to full list
      });
      return;
    }

    try {
      Map<String, double> userLocation = await getCoordinatesFromAddress(searchQuery);
      double userLat = userLocation['lat']!;
      double userLng = userLocation['lng']!;

      List<LocalBuddy> filteredBuddies = [];

      for (var localBuddy in _localBuddyList) {
        Map<String, double> buddyLocation = await getCoordinatesFromAddress(localBuddy.locationAddress ?? '');
        double buddyLat = buddyLocation['lat']!;
        double buddyLng = buddyLocation['lng']!;

        double distance = calculateDistance(userLat, userLng, buddyLat, buddyLng);

        if (distance <= 50) {
          filteredBuddies.add(localBuddy);
        }
      }

      setState(() {
        _foundedLocalBuddy = filteredBuddies; // Update with filtered list
      });
    } catch (e) {
      print('Error during search: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
      final List<Widget> _screens = [
      Column(
        children: [
          // Display current location
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              _currentAddress,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),

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
                  hintText: "Search local buddy with destination...",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : _foundedLocalBuddy.isNotEmpty
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ListView.builder(
                    itemCount: _foundedLocalBuddy.length,
                    itemBuilder: (context, index) {
                      return buildLocalBuddyButton(localBuddy: _foundedLocalBuddy[index]);
                    },
                  ),
                ),
              )
            : Center(
                child: Text(
                  'No local buddy found in nearby of the input address.',
                  style: TextStyle(fontSize: defaultFontSize, color: Colors.black),
                ),
              ),
        ],
      ),

      // Your screen 2
      registrationStatus == 2 ? LocalBuddyEditInfoScreen(userId: widget.userId) : LocalBuddyMeScreen(userId: widget.userId,),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Local Buddy"),
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
              MaterialPageRoute(builder: (context) => UserHomepageScreen(userId: widget.userId)),
            );
          },
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: LocalBuddyCustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget buildLocalBuddyButton({required LocalBuddy localBuddy}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => LocalBuddyDetailsScreen(userId: widget.userId, localBuddyId: localBuddy.localBuddyID, fromAppLink: 'false'))
        );
      },
      child: Container(
        width: double.infinity,
        height: 180,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(localBuddy.localBuddyImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 70,
                color: Colors.white.withOpacity(0.8), // Semi-transparent overlay
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localBuddy.localBuddyName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: defaultLabelFontSize,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              offset: Offset(0.5, 0.5),
                              color: Colors.black87,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Live in: ${localBuddy.locationArea ?? ''}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: defaultFontSize,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              offset: Offset(0.5, 0.5),
                              color: Colors.black87,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Language Spoken: ${localBuddy.languageSpoken ?? ''}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: defaultFontSize,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              offset: Offset(0.5, 0.5),
                              color: Colors.black87,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}