import 'dart:io';

import 'package:assignment_tripmate/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class TravelAgentViewCustomerDetailsScreen extends StatefulWidget {
  final String userId;
  final String customerId;
  final String? tourID;
  final String? carRentalID;
  final String? tourBookingID;
  final String? carRentalBookingID;

  const TravelAgentViewCustomerDetailsScreen({
    super.key, 
    required this.userId,
    required this.customerId,
    this.tourID,
    this.carRentalID,
    this.tourBookingID,
    this.carRentalBookingID,
  });

  @override
  State<TravelAgentViewCustomerDetailsScreen> createState() => _TravelAgentViewCustomerDetailsScreenState();
}

class _TravelAgentViewCustomerDetailsScreenState extends State<TravelAgentViewCustomerDetailsScreen> {

  bool isFetchingCustomerDetails = false;
  bool isFetchingTourBooking = false;
  bool isFetchingCarBooking = false;
  bool isFetchingTour = false;
  bool isFetchingCar = false;
  bool isOpenFile = false;
  Map<String, dynamic>? custData;
  Map<String, dynamic>? tourData;
  Map<String, dynamic>? carData;
  Map<String, dynamic>? tourBookingData;
  Map<String, dynamic>? carBookingData;

  @override
  void initState() {
    super.initState();
    _fetchCustomerDetails();
    if(widget.tourBookingID != null){
      _fetchTourBookingDetails();
      _fetchTourDetails();
    } else if(widget.carRentalBookingID != null){
      _fetchCarBookingDetails();
      _fetchCarDetails();
    }
  }

  Future<void>_fetchCustomerDetails() async {
    setState(() {
      isFetchingCustomerDetails = true;
    });
    try{
      DocumentReference custRef = FirebaseFirestore.instance.collection('users').doc(widget.customerId);
      DocumentSnapshot custSnapshot = await custRef.get();

      if(custSnapshot.exists){
        Map<String, dynamic>? data = custSnapshot.data() as  Map<String, dynamic>?;
        setState(() {
          custData = data;
        });
      }
    } catch(e){
      print('Error fetch customer data: $e');
    } finally{
      setState(() {
        isFetchingCustomerDetails = false;
      });
    }
  }

  Future<void>_fetchTourBookingDetails() async {
    setState(() {
      isFetchingTourBooking = true;
    });
    try{
      DocumentReference tourRef = FirebaseFirestore.instance.collection('tourBooking').doc(widget.tourBookingID);
      DocumentSnapshot tourSnapshot = await tourRef.get();

      if(tourSnapshot.exists){
        Map<String, dynamic>? data = tourSnapshot.data() as  Map<String, dynamic>?;
        setState(() {
          tourBookingData = data;
        });
      }
    } catch(e){
      print('Error fetch tour booking data: $e');
    } finally{
      setState(() {
        isFetchingTourBooking = false;
      });
    }
  }

  Future<void>_fetchCarBookingDetails() async {
    setState(() {
      isFetchingCarBooking = true;
    });
    try{
      DocumentReference carRef = FirebaseFirestore.instance.collection('carRentalBooking').doc(widget.carRentalBookingID);
      DocumentSnapshot carSnapshot = await carRef.get();

      if(carSnapshot.exists){
        Map<String, dynamic>? data = carSnapshot.data() as  Map<String, dynamic>?;
        setState(() {
          carBookingData = data;
        });
      }
    } catch(e){
      print('Error fetch car booking data: $e');
    } finally{
      setState(() {
        isFetchingCarBooking = false;
      });
    }
  }

  Future<void>_fetchTourDetails() async {
    setState(() {
      isFetchingTour = true;
    });
    try{
      DocumentReference tourRef = FirebaseFirestore.instance.collection('tourPackage').doc(widget.tourID);
      DocumentSnapshot tourSnapshot = await tourRef.get();

      if(tourSnapshot.exists){
        Map<String, dynamic>? data = tourSnapshot.data() as  Map<String, dynamic>?;
        setState(() {
          tourData = data;
        });
      }
    } catch(e){
      print('Error fetch tour data: $e');
    } finally{
      setState(() {
        isFetchingTour = false;
      });
    }
  }

  Future<void>_fetchCarDetails() async {
    setState(() {
      isFetchingCar = true;
    });
    try{
      DocumentReference carRef = FirebaseFirestore.instance.collection('car_rental').doc(widget.carRentalID);
      DocumentSnapshot carSnapshot = await carRef.get();

      if(carSnapshot.exists){
        Map<String, dynamic>? data = carSnapshot.data() as  Map<String, dynamic>?;
        setState(() {
          carData = data;
        });
      }
    } catch(e){
      print('Error fetch car data: $e');
    } finally{
      setState(() {
        isFetchingCar = false;
      });
    }
  }

  Future<void> downloadAndOpenPdfFromUrl(String url, String fileName) async {
    try {
      // Get the directory to store the file
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName.pdf');
      
      // Download the file from the URL using Dio
      print("Downloading file from URL: $url");
      final response = await Dio().download(url, file.path);
      
      // Check if the download was successful
      if (response.statusCode == 200) {
        print("File downloaded to: ${file.path}");
        
        // Open the file
        final result = await OpenFile.open(file.path);
        print('OpenFile Result: ${result.message}, Type: ${result.type}');
      } else {
        print("Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      // Handle errors
      print("Error downloading or opening the file: $e");
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
            Navigator.pop(context);
          },
        ),
      ),
      body: isFetchingCustomerDetails || isFetchingCarBooking || isFetchingTourBooking
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : custData == null 
            ? Center(child: Text('No customer details available.'))
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.black, width: 1.5),
                                  bottom: BorderSide(color: Colors.black, width: 1.5),
                                ),
                              ),
                              child: Text(
                                'Customer Info',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1.5),
                                  ),
                                  child: _buildImage(custData?['profileImage'], 75, 110),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow('Name', custData?['name'], 55),
                                      SizedBox(height: 10),
                                      _buildDetailRow('Contact', custData?['contact'], 55),
                                      SizedBox(height: 10),
                                      _buildDetailRow('Email', custData?['email'], 55),
                                      SizedBox(height: 10),
                                      _buildDetailRow('Address', custData?['address'], 55),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.black, width: 1.5),
                                  bottom: BorderSide(color: Colors.black, width: 1.5),
                                ),
                              ),
                              child: Text(
                                'Booking Info',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 20),
                            if(tourBookingData != null && tourData != null) ...[
                              tourComponent(data: tourBookingData!, tourData: tourData!),
                              Text(
                                "Remarks: Half Payment (Pay deposit only), Full payment (Pay deposit and total booking fee)",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(height: 20),
                              Container(
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.black, width: 1.5),
                                    bottom: BorderSide(color: Colors.black, width: 1.5),
                                  ),
                                ),
                                child: Text(
                                  'Payment Info',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    width: 90,
                                    child: Text(
                                      "Deposit",
                                      style: TextStyle(
                                        fontSize: defaultFontSize,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                      fontSize: defaultFontSize,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  if(tourBookingData!['depositInvoice'] != null)
                                    SizedBox(
                                      height: 35,
                                      // width: 170,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          // setState(() {
                                          //   isOpenFile = true; // Update the loading state
                                          // });
                                          print("Button Pressed: Starting file download.");
                                          String url = tourBookingData!['depositInvoice']; 
                                          String fileName = 'deposit_invoice'; 
                                          print("Deposit URL: $url");
                                          await downloadAndOpenPdfFromUrl(url, fileName);
                                          // setState(() {
                                          //   isOpenFile = false; // Update the state when done
                                          // });
                                        }, 
                                        child: isOpenFile
                                          ? SizedBox(
                                              width: 20.0,
                                              height: 20.0,
                                              child: CircularProgressIndicator(color: Colors.white),
                                            ) 
                                          : Text(
                                              "View Deposit Invoice",
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF749CB9),  
                                          foregroundColor: Colors.white,  
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: primaryColor)
                                          ),
                                        ),
                                      )

                                    )
                                  else
                                    Text(
                                      "N/A",
                                      style: TextStyle(
                                        fontSize: defaultFontSize,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    width: 90,
                                    child: Text(
                                      "Full Payment",
                                      style: TextStyle(
                                        fontSize: defaultFontSize,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                      fontSize: defaultFontSize,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  if(tourBookingData!['invoice'] != null)
                                    SizedBox(
                                      height: 30,
                                      child: ElevatedButton(
                                        onPressed: (){

                                        }, 
                                        child: Text(
                                          "View Full Payment Invoice",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF749CB9),  // Active color
                                          foregroundColor: Colors.white,  // Text color
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: primaryColor)
                                          ),
                                        ),
                                      )
                                    )
                                  else
                                    Text(
                                      "N/A",
                                      style: TextStyle(
                                        fontSize: defaultFontSize,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),

                            if(carBookingData != null && carData != null) ...[
                              carComponent(data: carBookingData!, carData: carData!),
                              SizedBox(height: 20),
                              Container(
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.black, width: 1.5),
                                    bottom: BorderSide(color: Colors.black, width: 1.5),
                                  ),
                                ),
                                child: Text(
                                  'Payment Info',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    width: 90,
                                    child: Text(
                                      "Invoice",
                                      style: TextStyle(
                                        fontSize: defaultFontSize,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                      fontSize: defaultFontSize,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  if(carBookingData!['invoice'] != null)
                                    SizedBox(
                                      height: 30,
                                      child: ElevatedButton(
                                        onPressed: (){

                                        }, 
                                        child: Text(
                                          "View Invoice",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF749CB9),  // Active color
                                          foregroundColor: Colors.white,  // Text color
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: primaryColor)
                                          ),
                                        ),
                                      )
                                    )
                                  else
                                    Text(
                                      "N/A",
                                      style: TextStyle(
                                        fontSize: defaultFontSize,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                ],
                              )
                            ]
                          ],
                        ),
                            ]
                          ]
                        )
                      )
                    ],
                  ),
                ),
              )
      
    );    
  }

  Widget _buildImage(String? imageUrl, double width, double height) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: Center(child: Icon(Icons.error, color: Colors.red)),
      );
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                backgroundDecoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
            );
          },
        );
      },
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }


  Widget _buildDetailRow(String label, String? value, double width) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          width: 10,
          child: Text(
            ':',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value ?? 'N/A',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: null,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget tourComponent({required Map<String, dynamic> data, required Map<String, dynamic> tourData}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        // borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ID: ${data['bookingID'] ?? "N/A"}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: data['bookingStatus'] == 0
                        ? Colors.orange.shade100
                        : data['bookingStatus'] == 1
                            ? Colors.green.shade100
                            : data['bookingStatus'] == 2
                                ? Colors.red.shade100
                                : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    data['bookingStatus'] == 0
                        ? "Upcoming"
                        : data['bookingStatus'] == 1
                            ? "Completed"
                            : data['bookingStatus'] == 2
                                ? "Canceled"
                                : "Unknown",
                    style: TextStyle(
                      color: data['bookingStatus'] == 0
                          ? Colors.orange
                          : data['bookingStatus'] == 1
                              ? Colors.green
                              : data['bookingStatus'] == 2
                                  ? Colors.red
                                  : Colors.grey.shade900,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1.5))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: getScreenWidth(context) * 0.2,
                  height: getScreenHeight(context) * 0.15,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(tourData['tourCover'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded( // Use Expanded to allow the column to take remaining space
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align contents vertically
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tourData['tourName'] ?? "N/A",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Date: ${data['travelDate'] ?? "N/A"}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "Payment: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "${data['fullyPaid'] == 0 ? 'Half Payment' : 'Completed'}",
                            style: TextStyle(
                              color: data['fullyPaid'] == 0 ? Colors.red : const Color.fromARGB(255, 103, 178, 105),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Padding( // Add Padding here
                        padding: EdgeInsets.only(right: 10.0), // Right padding of 10
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Qty: ${(data['numberOfPeople'] ?? "N/A").toString()}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Total Price: RM ${NumberFormat('#,##0.00').format(data['totalPrice'] ?? 0)}", 
                  style: TextStyle(
                    color: Colors.black, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.right,
                ),
              ]
            )
          )
        ],
      ),
    );
  }

  Widget carComponent({required Map<String, dynamic> data, required Map<String, dynamic> carData}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        // borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ID: ${data['bookingID'] ?? "N/A"}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: data['bookingStatus'] == 0
                        ? Colors.orange.shade100
                        : data['bookingStatus'] == 1
                            ? Colors.green.shade100
                            : data['bookingStatus'] == 2
                                ? Colors.red.shade100
                                : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    data['bookingStatus'] == 0
                        ? "Upcoming"
                        : data['bookingStatus'] == 1
                            ? "Completed"
                            : data['bookingStatus'] == 2
                                ? "Canceled"
                                : "Unknown",
                    style: TextStyle(
                      color: data['bookingStatus'] == 0
                          ? Colors.orange
                          : data['bookingStatus'] == 1
                              ? Colors.green
                              : data['bookingStatus'] == 2
                                  ? Colors.red
                                  : Colors.grey.shade900,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1.5))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: getScreenWidth(context) * 0.2,
                  height: getScreenHeight(context) * 0.12,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(carData['carImage'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded( // Use Expanded to allow the column to take remaining space
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align contents vertically
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carData['carModel'] ?? "N/A",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Date: ${DateFormat('dd/MM/yyyy').format(carData['bookingStartDate'].toDate())} - ${DateFormat('dd/MM/yyyy').format(carData['bookingEndDate'].toDate())}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      // Padding( // Add Padding here
                      //   padding: EdgeInsets.only(right: 10.0), // Right padding of 10
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: Text(
                      //       'Qty: ${(data['numberOfPeople'] ?? "N/A").toString()}',
                      //       style: TextStyle(
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Total Price: RM ${NumberFormat('#,##0.00').format(data['totalPrice'] ?? 0)}", 
                  style: TextStyle(
                    color: Colors.black, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.right,
                ),
              ]
            )
          )
        ],
      ),
    );
  }

}
