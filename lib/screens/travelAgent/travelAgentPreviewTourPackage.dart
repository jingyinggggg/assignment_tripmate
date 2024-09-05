import 'package:assignment_tripmate/screens/travelAgent/travelAgentViewTourList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TravelAgentPreviewTourPackageScreen extends StatefulWidget {
  final String userId;
  final String countryName;
  final String cityName;
  final String tourID;

  const TravelAgentPreviewTourPackageScreen({super.key, required this.userId, required this.countryName, required this.cityName, required this.tourID});

  @override
  State<StatefulWidget> createState() => _TravelAgentPreviewTourPackageScreenState();
}

class _TravelAgentPreviewTourPackageScreenState extends State<TravelAgentPreviewTourPackageScreen> {
  Map<String, dynamic>? tourData;

  @override
  void initState() {
    super.initState();
    _fetchTourData();
  }

  Future<void> _fetchTourData() async {
    try {
      // Get a reference to the tourPackage collection
      CollectionReference tourRef = FirebaseFirestore.instance.collection('tourPackage');

      // Query to get the specific document with the provided tourID
      QuerySnapshot querySnapshot = await tourRef.where('tourID', isEqualTo: widget.tourID).get();

      // Check if any documents are returned
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming tourID is unique and only one document is returned)
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;

        // Extract data from the document
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        setState(() {
          tourData = data;
        });
      } else {
        print('No tour found with the given tourID.');
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching tour data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              MaterialPageRoute(builder: (context) => TravelAgentViewTourListScreen(userId: widget.userId, countryName: widget.countryName, cityName: widget.cityName))
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white, size: 25,),
            onPressed: () {
              // Navigator.push(
              //   context, 
              //   MaterialPageRoute(builder: (context) => TravelAgentAddTourPackageScreen(userId: widget.userId, countryName: widget.countryName, cityName: widget.cityName,))
              // );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (tourData?['tourCover'] != null) ...[
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(tourData!['tourCover']), 
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Centered overlay container
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,  // Adjust width as needed
                      height: 50, // Adjust height as needed
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7), // Semi-transparent overlay
                      ),
                      child: Center(
                        child: Text(
                          tourData!['tourName'] ?? 'No Name', 
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(0.5, 0.5),
                                color: Colors.black87,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ] else ...[
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey, // Placeholder if no image is available
              child: Center(
                child: Text(
                  'No Image Available',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
