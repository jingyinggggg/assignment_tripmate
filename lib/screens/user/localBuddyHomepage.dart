import 'dart:convert';

import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/user/localBuddyDetails.dart';
import 'package:http/http.dart' as http;
import 'package:assignment_tripmate/screens/user/homepage.dart';
import 'package:assignment_tripmate/screens/user/localBuddyBottomNavigationBar.dart';
import 'package:assignment_tripmate/screens/user/localBuddyEditInfo.dart';
import 'package:assignment_tripmate/screens/user/localBuddyMeScreen.dart';
import 'package:assignment_tripmate/screens/user/localBuddyRegistration.dart';
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

  @override
  void initState() {
    super.initState();
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
      QuerySnapshot querySnapshot = await localBuddyRef.where('userID', isEqualTo: widget.userId).where('registrationStatus', isEqualTo: 2).get();

      _localBuddyList = [];

      for (var doc in querySnapshot.docs){
        DocumentSnapshot userSnapshot = await userRef.doc(doc['userID']).get();

        if(userSnapshot.exists){
          // Get full address from the document
          String fullAddress = doc['location'];

          // Call the Geocoding API to extract country and area
          String? country = '';
          String? area = '';

          if (fullAddress.isNotEmpty) {
            var locationData = await _getLocationAreaAndCountry(fullAddress);
            country = locationData['country'];
            area = locationData['area'];
          }

          String locationArea = '$area, $country';

          _localBuddyList.add(LocalBuddy(
            localBuddyID: doc['localBuddyID'], 
            localBuddyName: userSnapshot['name'], 
            localBuddyImage: userSnapshot['profileImage'], 
            languageSpoken: doc['languageSpoken'],
            locationArea: locationArea
          ));
        }
      }

      setState(() {
        _localBuddyList;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching local buddy data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to get area and country from the full address using the Google Geocoding API
  Future<Map<String, String>> _getLocationAreaAndCountry(String address) async {
    final String apiKeys = apiKey; // Replace with your API key
    final String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKeys';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['results'].isNotEmpty) {
        final addressComponents = data['results'][0]['address_components'];

        String country = '';
        String area = '';

        for (var component in addressComponents) {
          List<String> types = List<String>.from(component['types']);
          if (types.contains('country')) {
            country = component['long_name'];
          } else if (types.contains('administrative_area_level_1') || types.contains('locality')) {
            area = component['long_name'];
          }
        }

        return {'country': country, 'area': area};
      } else {
        return {'country': '', 'area': ''};
      }
    } else {
      print('Error fetching location data: ${response.statusCode}');
      return {'country': '', 'area': ''};
    }
  }

  // Handling bottom navigation bar tap
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the current index
    });
  }

  Future<void> _checkCurrentUserStatus() async {
    setState(() {
      isVerifyLoading = true;
    });
    try {
      // Fetch the user document based on the userId using a where condition
      QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
          .collection('localBuddy')
          .where('userID', isEqualTo: widget.userId) // Filter by userID
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        // If the query returns documents
        var userSnapshot = userQuerySnapshot.docs.first; // Get the first document
        registrationStatus = userSnapshot['registrationStatus'];

      } else {
        registrationStatus = null;
      }
    } catch (e) {
      print('Error checking current user: $e');
    } finally {
      setState(() {
        isVerifyLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      final List<Widget> _screens = [
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
            : _localBuddyList.isNotEmpty
              ? Expanded(  // Constrain ListView to available space
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ListView.builder(
                      itemCount: _localBuddyList.length,
                      itemBuilder: (context, index) {
                        return buildLocalBuddyButton(localBuddy: _localBuddyList[index]);
                      },
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'No local buddy exist in the system.',
                    style: TextStyle(
                      fontSize: defaultFontSize,
                      color: Colors.black,
                    ),
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
          MaterialPageRoute(builder: (context) => LocalBuddyDetailsScreen(userId: widget.userId, localBuddyId: localBuddy.localBuddyID))
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
