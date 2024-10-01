import 'dart:convert';
import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/user/chatDetailsPage.dart';
import 'package:http/http.dart' as http;
import 'package:assignment_tripmate/screens/user/localBuddyHomepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LocalBuddyDetailsScreen extends StatefulWidget {
  final String userId;
  final String localBuddyId;

  const LocalBuddyDetailsScreen({
    super.key,
    required this.userId,
    required this.localBuddyId,
  });

  @override
  State<StatefulWidget> createState() => _LocalBuddyDetailsScreenState();
}

class _LocalBuddyDetailsScreenState extends State<LocalBuddyDetailsScreen> {
  Map<String, dynamic>? localBuddyData;
  Map<String, dynamic>? userData;
  String? locationArea;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLocalBuddyData();
  }

  Future<void> _fetchLocalBuddyData() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentReference localBuddyRef =
          FirebaseFirestore.instance.collection('localBuddy').doc(widget.localBuddyId);
      DocumentSnapshot docSnapshot = await localBuddyRef.get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(data!['userID'] ?? '');
        DocumentSnapshot userSnapshot = await userRef.get();

        Map<String, dynamic>? usersData = userSnapshot.data() as Map<String, dynamic>?;

        // Ensure userData is not null and contains the 'location' key
        if (data.containsKey('location')) {
          String fullAddress = data['location'] ?? '';

          String? country = '';
          String? area = '';

          if (fullAddress.isNotEmpty) {
            var locationData = await _getLocationAreaAndCountry(fullAddress);
            country = locationData['country'];
            area = locationData['area'];
          } else {
            country = 'Unknown Country';
            area = 'Unknown Area';
          }

          locationArea = '$area, $country';

          setState(() {
            localBuddyData = data;
            userData = usersData;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User data is incomplete or missing location.')),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No local buddy details found with the given id.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching local buddy data: $e')),
      );
    }
  }

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

  // Method to build a row with an icon and text
  Widget _buildInfoRow(IconData? icon, Image? image, String text, Color? color) {
    return Row(
      children: [
        if (image != null) ...[
          image,
        ] else if (icon != null) ...[
          Icon(
            icon,
            size: 18,
            color: color,
          ),
        ],
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: defaultFontSize,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Local Buddy"),
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
              MaterialPageRoute(builder: (context) => LocalBuddyHomepageScreen(userId: widget.userId)),
            );
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (userData?['profileImage'] != null) ...[
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(userData!['profileImage']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ] else ...[
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(color: Colors.grey),
                      child: const Center(
                        child: Text(
                          'No Profile Image Available',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                  if (localBuddyData != null) ...[
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            localBuddyData!['bio'] ?? '',
                            style: TextStyle(fontSize: defaultFontSize, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.justify,
                            maxLines: null,
                          ),
                        ),
                        Container(
                          color: primaryColor.withOpacity(0.2),
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(Icons.location_on, null, 'I live in $locationArea', Colors.red),
                                  SizedBox(height: 5),
                                  _buildInfoRow(Icons.language, null, 'I speak ${localBuddyData?['languageSpoken']}', Colors.blue),
                                  SizedBox(height: 5),
                                  _buildInfoRow(Icons.verified, null, 'Verified local buddy', Colors.orange),
                                  SizedBox(height: 5),
                                  _buildInfoRow(
                                    null, 
                                    Image.asset(
                                      "images/rm.png", // Replace with your image asset path
                                      width: 18, // Set width as needed
                                      height: 18, // Set height as needed
                                    ),
                                    'RM ${localBuddyData?['pricePerHour'].toString()}/per hour', 
                                    null
                                  )
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final receiverUserId = localBuddyData?['userID']; // Safely get the value

                                  if (receiverUserId != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatDetailsScreen(userId: widget.userId, receiverUserId: receiverUserId),
                                      ),
                                    );
                                  } else {
                                    // Handle the case where receiverUserId is null
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Local buddy is not available')),
                                    );
                                  }
                                },
                                child: Row(
                                  children: [
                                    const Text(
                                      "Chat",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    const ImageIcon(
                                      AssetImage("images/communication.png"),
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF467BA1),
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              )
                            ],
                          )
                        ),
                      ],
                    )
                  ] else ...[
                    Center(
                      child: Text(
                        'No data available.',
                        style: TextStyle(fontSize: defaultFontSize, fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ],
              ),
            ),
      bottomNavigationBar: (localBuddyData != null && widget.userId != localBuddyData!['userID'])
          ? null // Hides the bottom navigation bar
          : Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 7.0,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: BottomAppBar(
                color: Colors.white,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RM ${localBuddyData?['pricePerHour']}/per hour',
                        style: TextStyle(
                          fontSize: defaultLabelFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (){}, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: defaultFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

}
