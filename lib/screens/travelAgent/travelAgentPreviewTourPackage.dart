import 'package:assignment_tripmate/screens/travelAgent/travelAgentViewTourList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TravelAgentPreviewTourPackageScreen extends StatefulWidget {
  final String userId;
  final String countryName;
  final String cityName;
  final String tourID;

  const TravelAgentPreviewTourPackageScreen({
    super.key,
    required this.userId,
    required this.countryName,
    required this.cityName,
    required this.tourID,
  });

  @override
  State<StatefulWidget> createState() => _TravelAgentPreviewTourPackageScreenState();
}

class _TravelAgentPreviewTourPackageScreenState extends State<TravelAgentPreviewTourPackageScreen> {
  Map<String, dynamic>? tourData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTourData();
  }

  Future<void> _fetchTourData() async {
    try {
      CollectionReference tourRef = FirebaseFirestore.instance.collection('tourPackage');
      QuerySnapshot querySnapshot = await tourRef.where('tourID', isEqualTo: widget.tourID).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        setState(() {
          tourData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No tour found with the given tourID.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tour data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
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
                MaterialPageRoute(
                  builder: (context) => TravelAgentViewTourListScreen(
                    userId: widget.userId,
                    countryName: widget.countryName,
                    cityName: widget.cityName,
                  ),
                ),
              );
            },
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
              MaterialPageRoute(
                builder: (context) => TravelAgentViewTourListScreen(
                  userId: widget.userId,
                  countryName: widget.countryName,
                  cityName: widget.cityName,
                ),
              ),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              // Add navigation to edit screen here if needed
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (tourData?['tourCover'] != null) ...[
              Stack(
                children: [
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
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        color: Colors.white.withOpacity(0.7),
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
                  ),
                ],
              )
            ] else ...[
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: const Center(
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
            ],

            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Agency Info",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const ImageIcon(
                              AssetImage("images/download-pdf.png"),
                              size: 23,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              // Add PDF download functionality here if needed
                            },
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.favorite_border,
                            size: 23,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.share_rounded,
                            size: 23,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),

                  Text(
                    "Agency: ${tourData?['agency'] ?? 'No Agency Info'}",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Tour Highlights",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tourData?['tourHighlight']?.length ?? 0,
                    itemBuilder: (context, index) {
                      var tourHighlight = tourData!['tourHighlight'][index];
                      return tourHighlightComponent(
                        tourHighlight['no'] ?? 'No Numbering',
                        tourHighlight['description'] ?? 'No Description',
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Itinerary",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            const Text(
                              "Enquiry",
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
                  ),

                  SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tourData?['itinerary']?.length ?? 0,
                    itemBuilder: (context, index) {
                      var itinerary = tourData!['itinerary'][index];
                      return itineraryComponent(
                        itinerary['day'] ?? 'No Day',
                        itinerary['title'] ?? 'No Title',
                        itinerary['description'] ?? 'No Description',
                        itinerary['remarks'] ?? 'No Remarks',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tourHighlightComponent(String numbering, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
        children: [
          Text(
            numbering + '.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 10),
          // Use Expanded to make sure the description text wraps properly
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              textAlign: TextAlign.justify,
              maxLines: null, // Allow multi-line text
              overflow: TextOverflow.visible, // Show entire text
            ),
          ),
        ],
      ),
    );
  }


  Widget itineraryComponent(String day, String title, String description, String remarks) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: IntrinsicHeight( // Ensure both sides of the Row stretch to the tallest child
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch both columns to match heights
          children: [
            Column(
              children: [
                Container(
                  width: 60,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF467BA1),
                    border: Border(
                      left: BorderSide(color: Color(0xFF467BA1), width: 1.5),
                      top: BorderSide(color: Color(0xFF467BA1), width: 1.5),
                      bottom: BorderSide(color: Color(0xFF467BA1), width: 1.5),
                      right: BorderSide.none,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    "DAY",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded( // Use Expanded here to stretch the Day number container
                  child: Container(
                    alignment: Alignment.center,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(color: Color(0xFF467BA1), width: 1.5),
                        top: BorderSide(color: Color(0xFF467BA1), width: 1.5),
                        bottom: BorderSide(color: Color(0xFF467BA1), width: 1.5),
                        right: BorderSide.none,
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF467BA1),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF467BA1), width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '*** $remarks',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
