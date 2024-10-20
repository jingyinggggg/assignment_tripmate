import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentViewBookingList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TravelAgentViewBookingDetailsScreen extends StatefulWidget {
  final String userId;
  final String? tourID;
  final String? carRentalID;
  final int totalBookingNumber;

  const TravelAgentViewBookingDetailsScreen({
    super.key, 
    required this.userId,
    this.tourID,
    this.carRentalID,
    required this.totalBookingNumber
  });

  @override
  State<TravelAgentViewBookingDetailsScreen> createState() => _TravelAgentViewBookingDetailsScreenState();
}

class _TravelAgentViewBookingDetailsScreenState extends State<TravelAgentViewBookingDetailsScreen> {
  bool isFetchingTourDetails = false;
  bool isFetchingCarRentalDetails = false;
  Map<String, dynamic>? tourData;

  @override
  void initState() {
    super.initState();
    if(widget.tourID != null){
      _fetchTourDetails();
    }
  }

  Future<void>_fetchTourDetails() async {
    setState(() {
      isFetchingTourDetails = true;
    });

    try{
      DocumentReference tourRef = FirebaseFirestore.instance.collection('tourPackage').doc(widget.tourID);
      DocumentSnapshot tourSnap = await tourRef.get();

      if(tourSnap.exists){
        Map<String, dynamic>? data = tourSnap.data() as Map<String, dynamic>?;

        setState(() {
          tourData = data;
        });
      }
    } catch(e){
      print("Error fetch tour data: $e");
    } finally{
      setState(() {
        isFetchingTourDetails = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Booking"),
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
              MaterialPageRoute(builder: (context) => TravelAgentViewBookingListScreen(userId: widget.userId))
            );
          },
        ),
      ),
      body: isFetchingTourDetails
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
            child: Column(
                children: [
                  if(tourData?['tourCover'] != null)...[
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
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
                        color: Colors.grey.shade200,
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
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        tourDetailsComponent(tourData),
                        SizedBox(height: 20),
                        Text(
                          "Booking List",
                          style: TextStyle(
                            fontSize: defaultFontSize,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
            
    );    
  }

  Widget tourDetailsComponent(Map<String, dynamic>? data) {
    // Initialize variables to store cheapest and most expensive prices
    int? cheapestPrice;
    int? expensivePrice;

    // Check if availability is present and is a list
    if (data != null && data['availability'] is List) {
      // Iterate through the availability array to find prices
      for (var item in data['availability']) {
        int price = item['price'] ?? 0; // Use a default value if price is null

        // Determine the cheapest price
        if (cheapestPrice == null || price < cheapestPrice) {
          cheapestPrice = price;
        }

        // Determine the most expensive price
        if (expensivePrice == null || price > expensivePrice) {
          expensivePrice = price;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: primaryColor, width: 1.5),
          ),
          child: Table(
            columnWidths: {
              0: FixedColumnWidth(100), // Width for Header column
              // 1: FixedColumnWidth(100), // Width for Value column
            },
            border: TableBorder.all(color: primaryColor, width: 1.5),
            children: [
              // Define header and corresponding data
              TableRow(
                children: [
                  _buildTextFieldCell("ID", isBold: true),
                  _buildTextFieldCell(data?['tourID']?.toString() ?? 'N/A'),
                ],
              ),
              TableRow(
                children: [
                  _buildTextFieldCell("Amount", isBold: true),
                  _buildTextFieldCell(cheapestPrice != null && expensivePrice != null ? 'RM${cheapestPrice.toStringAsFixed(0)} - RM${expensivePrice.toStringAsFixed(0)}' : 'N/A'),
                ],
              ),
              TableRow(
                children: [
                  _buildTextFieldCell("Total Booking", isBold: true),
                  _buildTextFieldCell(widget.totalBookingNumber.toString()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildTextFieldCell(String text, {bool isBold = false}) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        color: isBold ? primaryColor.withOpacity(0.4)  :Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500
          ),
          maxLines: null, // Allows multiline input
          textAlign: TextAlign.center,
        ),
      )
    );
  }  
}