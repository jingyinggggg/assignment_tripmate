import 'dart:io';
import 'dart:math';
import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/customerModel.dart';
import 'package:assignment_tripmate/invoiceModel.dart';
import 'package:assignment_tripmate/pdf_invoice_api.dart';
import 'package:assignment_tripmate/supplierModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class AdminViewCustomerDetailsScreen extends StatefulWidget {
  final String userId;
  final String customerId;
  final String? tourID;
  final String? carRentalID;
  final String? localBuddyID;
  final String? tourBookingID;
  final String? carRentalBookingID;
  final String? localBuddyBookingID;

  const AdminViewCustomerDetailsScreen({
    super.key, 
    required this.userId,
    required this.customerId,
    this.tourID,
    this.carRentalID,
    this.localBuddyID,
    this.tourBookingID,
    this.carRentalBookingID,
    this.localBuddyBookingID
  });

  @override
  State<AdminViewCustomerDetailsScreen> createState() => _AdminViewCustomerDetailsScreenState();
}

class _AdminViewCustomerDetailsScreenState extends State<AdminViewCustomerDetailsScreen> {
  bool isFetchingCustomerDetails = false;
  bool isFetchingTourBooking = false;
  bool isFetchingCarBooking = false;
  bool isFetchingLocalBuddyBooking = false;
  bool isFetchingTour = false;
  bool isFetchingCar = false;
  bool isFetchingLocalBuddy = false;
  bool isOpenFile = false;
  bool isOpenInvoice = false;
  bool isOpenRefundInvoice = false;
  bool isOpenDepositRefundInvoice = false;
  bool isRefunding = false;
  Map<String, dynamic>? custData;
  Map<String, dynamic>? tourData;
  Map<String, dynamic>? carData;
  Map<String, dynamic>? localBuddyData;
  Map<String, dynamic>? tourBookingData;
  Map<String, dynamic>? carBookingData;
  Map<String, dynamic>? localBuddyBookingData;

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
    } else if(widget.localBuddyBookingID != null){
      _fetchLocalBuddyBookingDetails();
      _fetchLocalBuddyDetails();
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

  Future<void>_fetchLocalBuddyBookingDetails() async {
    setState(() {
      isFetchingLocalBuddy = true;
    });
    try{
      DocumentReference localBuddyRef = FirebaseFirestore.instance.collection('localBuddyBooking').doc(widget.localBuddyBookingID);
      DocumentSnapshot localBuddySnapshot = await localBuddyRef.get();

      if(localBuddySnapshot.exists){
        Map<String, dynamic>? data = localBuddySnapshot.data() as  Map<String, dynamic>?;
        setState(() {
          localBuddyBookingData = data;
        });
      }
    } catch(e){
      print('Error fetch local buddy booking data: $e');
    } finally{
      setState(() {
        isFetchingLocalBuddy = false;
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

  Future<void>_fetchLocalBuddyDetails() async {
    setState(() {
      isFetchingLocalBuddy = true;
    });
    try{
      DocumentReference localBuddyRef = FirebaseFirestore.instance.collection('localBuddy').doc(widget.localBuddyID);
      DocumentSnapshot localBuddySnapshot = await localBuddyRef.get();

      if(localBuddySnapshot.exists){
        Map<String, dynamic>? data = localBuddySnapshot.data() as  Map<String, dynamic>?;

        if(data != null){
          DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(data['userID']);
          DocumentSnapshot userSnapshot = await userRef.get();

           Map<String, dynamic>? userData = userSnapshot.data() as  Map<String, dynamic>?;

           if (userData != null) {
            // Add user name and profile image to local buddy data
            data['localBuddyName'] = userData['name'] ?? 'Unknown Name';
            data['profileImage'] = userData['profileImage'] ?? 'default_image_url';
          }

        }
        setState(() {
          localBuddyData = data;
        });
      }
    } catch(e){
      print('Error fetch local buddy data: $e');
    } finally{
      setState(() {
        isFetchingLocalBuddy = false;
      });
    }
  }

  Future<void> downloadAndOpenPdfFromUrl(String url, String fileName) async {
    try {
      // Get the directory to store the file
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName.pdf');
      
      // Download the file from the URL using Dio
      final response = await Dio().download(url, file.path);
      
      // Check if the download was successful
      if (response.statusCode == 200) {
        
        // Open the file
        final result = await OpenFile.open(file.path);
      } else {
        print("Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      // Handle errors
      print("Error downloading or opening the file: $e");
    }
  }

  Future<void> refundToCustomer(String type, String bookingID, int price, String collection, {bool isDepositRefund = false}) async{
    setState(() {
      isRefunding = true;
    });
    try{
      if(type == "Car Rental"){
        await FirebaseFirestore.instance.collection('carRentalBooking').doc(bookingID).update({
          'isRefund': isDepositRefund ? 0 : 1,
          'isRefundDeposit': isDepositRefund ? 1 : 0
        });
        setState(() {
            carBookingData!['isRefundDeposit'] = isDepositRefund;
          });
      } else{
        await FirebaseFirestore.instance.collection('localBuddyBooking').doc(bookingID).update({
          'isRefund': 1
        });
      }

      // Show success dialog
      showCustomDialog(
        context: context, 
        title: "Refund Successful", 
        content: "The amount is refunded to customer successfully.", 
        onPressed: () async {
          // Close the payment successful dialog
          Navigator.of(context).pop();

          // Use Future.microtask to show the loading dialog after the previous dialog is closed
          Future.microtask(() {
            showLoadingDialog(context, "Generating Invoice...");
          });

          final date = DateTime.now();

          final invoice = Invoice(
            supplier: Supplier(
              name: "Admin",
              address: "admin@tripmate.com",
            ),
            customer: Customer(
              name: custData!['name'],
              address: custData!['address'],
            ),
            info: InvoiceInfo(
              date: date,
              description: "Below is the refund invoice summary:",
              number: '${DateTime.now().year}-Ref${Random().nextInt(9000) + 1000}',
            ),
            // Wrap the single InvoiceItem in a list
            items: [
              InvoiceItem(
                description: isDepositRefund ? "Deposit refund (Booking ID: ${bookingID})" : "Refund (Booking ID: ${bookingID})",
                quantity: 1,
                unitPrice: price,
                total: price.toDouble(),
              ),
            ],
          );

          // Perform some async operation
          await generateInvoice(bookingID, invoice, type, collection, "refund_invoice", false, true, isDepositRefund ? true : false);

          // After the operation is done, hide the loading dialog
          Navigator.of(context).pop(); // This will close the loading dialog

          // Navigate to the homepage after PDF viewer
          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.pop(context);
          });
        },
        textButton: "View Invoice",
      );
    } catch(e){
      showCustomDialog(
        context: context, 
        title: "Failed", 
        content: "Something went wrong! Please try again...", 
        onPressed: () {
          Navigator.pop(context);
        }
      );
    } finally {
      setState(() {
        isRefunding = false;
      });
    }
  }

  Future<void> generateInvoice(String id, Invoice invoices, String servicesType, String collectionName, String pdfFileName, bool isDeposit, bool isRefund, bool isDepositRefund) async {
    setState(() {
      bool isGeneratingInvoice = true; // Correctly set the loading state variable
    });

    try {
      // Small delay to allow the UI to update
      await Future.delayed(Duration(milliseconds: 100));

      // Generate the PDF file
      final pdfFile = await PdfInvoiceApi.generate(
        invoices, 
        custData!['id'], 
        id, 
        servicesType, 
        collectionName, 
        pdfFileName, 
        isDeposit,
        isRefund,
        isDepositRefund,
      );

      // Open the generated PDF file
      await PdfInvoiceApi.openFile(pdfFile);

    } catch (e) {
      // Handle errors during invoice generation
      showCustomDialog(
        context: context,
        title: "Invoice Generation Failed",
        content: "Could not generate invoice. Please try again.",
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } finally {
      setState(() {
        bool isGeneratingInvoice = false; // Reset loading state correctly
      });
    }
  }

  void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please Wait'),
          content: Row(
            children: [
              CircularProgressIndicator(color: primaryColor,), // Loading indicator
              SizedBox(width: 20),
              Expanded(child: Text(message)),
            ],
          ),
        );
      },
    );
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
      body: isFetchingCustomerDetails || isFetchingCarBooking || isFetchingTourBooking || isFetchingLocalBuddyBooking
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
                                    isOpenFile
                                    ? SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(color: primaryColor),
                                      ) 
                                    : SizedBox(
                                      height: 35,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            isOpenFile = true; // Update the loading state
                                          });
                                          String url = tourBookingData!['depositInvoice']; 
                                          String fileName = 'deposit_invoice'; 
                                          await downloadAndOpenPdfFromUrl(url, fileName);
                                          setState(() {
                                            isOpenFile = false; // Update the state when done
                                          });
                                        }, 
                                        child:Text(
                                          "View Deposit Invoice",
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,  
                                          foregroundColor: primaryColor,  
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: primaryColor, width: 2),
                                            borderRadius: BorderRadius.circular(10)
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
                                    isOpenInvoice
                                    ? SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(color: primaryColor),
                                      ) 
                                    : SizedBox(
                                      height: 35,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            isOpenInvoice = true; // Update the loading state
                                          });
                                          String url = tourBookingData!['invoice']; 
                                          String fileName = 'invoice'; 
                                          await downloadAndOpenPdfFromUrl(url, fileName);
                                          setState(() {
                                            isOpenInvoice = false; // Update the state when done
                                          });
                                        }, 
                                        child:Text(
                                          "View Deposit Invoice",
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,  
                                          foregroundColor: primaryColor,  
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: primaryColor, width: 2),
                                            borderRadius: BorderRadius.circular(10)
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
                                ]
                              )
                            ],

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
                                    width: 100,
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
                                    isOpenInvoice
                                    ? SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(color: primaryColor),
                                      ) 
                                    : SizedBox(
                                      height: 35,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            isOpenInvoice = true; // Update the loading state
                                          });
                                          String url = carBookingData!['invoice']; 
                                          String fileName = 'invoice'; 
                                          await downloadAndOpenPdfFromUrl(url, fileName);
                                          setState(() {
                                            isOpenInvoice = false; // Update the state when done
                                          });
                                        }, 
                                        child:Text(
                                          "View Deposit Invoice",
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,  
                                          foregroundColor: primaryColor,  
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: primaryColor, width: 2),
                                            borderRadius: BorderRadius.circular(10)
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
                              if (carBookingData!['refundInvoice'] != null)
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        "Refund",
                                        style: TextStyle(
                                          fontSize: defaultFontSize,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      ":",
                                      style: TextStyle(
                                        fontSize: defaultFontSize,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    if (carBookingData!['refundInvoice'] != null)
                                      isOpenRefundInvoice
                                          ? SizedBox(
                                              width: 20.0,
                                              height: 20.0,
                                              child: CircularProgressIndicator(color: primaryColor),
                                            )
                                          : SizedBox(
                                              height: 35,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    isOpenRefundInvoice = true; // Update the loading state
                                                  });
                                                  String url = carBookingData!['refundInvoice'];
                                                  String fileName = 'invoice';
                                                  await downloadAndOpenPdfFromUrl(url, fileName);
                                                  setState(() {
                                                    isOpenRefundInvoice = false; // Update the state when done
                                                  });
                                                },
                                                child: Text(
                                                  "View Refund Invoice",
                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(color: primaryColor, width: 2),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                              ),
                                            )
                                    else
                                      Text(
                                        "N/A",
                                        style: TextStyle(
                                          fontSize: defaultFontSize,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                  ],
                                ),
                              if (carBookingData!['depositRefundInvoice'] != null || carBookingData!['isRefundDeposit'] == 1)
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        "Deposit Refund",
                                        style: TextStyle(
                                          fontSize: defaultFontSize,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      ":",
                                      style: TextStyle(
                                        fontSize: defaultFontSize,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    if (carBookingData!['depositRefundInvoice'] != null)
                                      isOpenDepositRefundInvoice
                                          ? SizedBox(
                                              width: 20.0,
                                              height: 20.0,
                                              child: CircularProgressIndicator(color: primaryColor),
                                            )
                                          : SizedBox(
                                              height: 35,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    isOpenDepositRefundInvoice = true; // Update the loading state
                                                  });
                                                  String url = carBookingData!['depositRefundInvoice'];
                                                  String fileName = 'deposit_refund_invoice';
                                                  await downloadAndOpenPdfFromUrl(url, fileName);
                                                  setState(() {
                                                    isOpenDepositRefundInvoice = false; // Update the state when done
                                                  });
                                                },
                                                child: Text(
                                                  "View Deposit Refund Invoice",
                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(color: primaryColor, width: 2),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                              ),
                                            )
                                    else
                                      Text(
                                        "N/A",
                                        style: TextStyle(
                                          fontSize: defaultFontSize,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                  ],
                                ),
                              if (carBookingData!['isCheckCarCondition'] == 1 && carBookingData!['isRefundDeposit'] == 0)
                                Container(
                                  constraints: BoxConstraints(maxHeight: 60), // or any appropriate height
                                  child: Text(
                                    '*** Remarks: Travel agent has checked the car condition and submitted a request for deposit refund to customer. You can click on the "Issue Deposit Refund" button to refund the deposit to the customer. ***',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                )
                              else
                                Container(),

                              SizedBox(height: 10),
                              carBookingData!['bookingStatus'] == 2
                              ? Container(
                                width: double.infinity,
                                height: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Confirmation"),
                                            content: Text(
                                              "Due to the cancellation fee is RM100.00. Therefore, only amount of RM${NumberFormat('#,##0.00').format((carBookingData!['totalPrice'] - 100) ?? 0)} will be refunded to customer.",
                                              textAlign: TextAlign.justify,
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: primaryColor, // Set the background color
                                                  foregroundColor: Colors.white, // Set the text color
                                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                                  ),
                                                ),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                  refundToCustomer('Car Rental', carBookingData!['bookingID'], (carBookingData!['totalPrice'] - 100).toInt(), 'carRentalBooking');
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: primaryColor, // Set the background color
                                                  foregroundColor: Colors.white, // Set the text color
                                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                                  ),
                                                ),
                                                child: const Text("Refund"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }, 
                                    child: isRefunding
                                      ? CircularProgressIndicator(color: Colors.white)
                                      : Text(
                                          "Issue Refund",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10), // Set the button radius to 0
                                      ),
                                    ),
                                  )
                                )
                              : carBookingData!['isCheckCarCondition'] == 1 && carBookingData!['isRefundDeposit'] == 0
                                ? Container(
                                    width: double.infinity,
                                    height: 50,
                                      child: TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Confirmation"),
                                                content: Text(
                                                  'This booking is completed and the car has been check by travel agent. So, the deposit with amount of RM300.00 can be refunded to customer. Click on the "Confirm" button to proceed the refund.',
                                                  textAlign: TextAlign.justify,
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Close the dialog
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: primaryColor, // Set the background color
                                                      foregroundColor: Colors.white, // Set the text color
                                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                                      ),
                                                    ),
                                                    child: const Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Close the dialog
                                                      refundToCustomer('Car Rental', carBookingData!['bookingID'], 300, 'carRentalBooking', isDepositRefund: true);
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: primaryColor, // Set the background color
                                                      foregroundColor: Colors.white, // Set the text color
                                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                                      ),
                                                    ),
                                                    child: const Text("Refund"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }, 
                                        child: isRefunding
                                          ? CircularProgressIndicator(color: Colors.white)
                                          : Text(
                                              "Issue Deposit Refund",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10), // Set the button radius to 0
                                          ),
                                        ),
                                      )
                                    )
                                : Container()
                              
                            ],

                            if(localBuddyBookingData != null && localBuddyData != null) ...[
                              localBuddyComponent(data: localBuddyBookingData!, localBuddyData: localBuddyData!),
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
                                    width: 50,
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
                                  if(localBuddyBookingData!['invoice'] != null)
                                    isOpenInvoice
                                    ? SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(color: primaryColor),
                                      ) 
                                    : SizedBox(
                                      height: 35,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            isOpenInvoice = true; // Update the loading state
                                          });
                                          String url = localBuddyBookingData!['invoice']; 
                                          String fileName = 'invoice'; 
                                          await downloadAndOpenPdfFromUrl(url, fileName);
                                          setState(() {
                                            isOpenInvoice = false; // Update the state when done
                                          });
                                        }, 
                                        child:Text(
                                          "View Deposit Invoice",
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,  
                                          foregroundColor: primaryColor,  
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: primaryColor, width: 2),
                                            borderRadius: BorderRadius.circular(10)
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
                              if(localBuddyBookingData!['refundInvoice'] != null)
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      child: Text(
                                        "Refund",
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
                                    if(localBuddyBookingData!['refundInvoice'] != null)
                                      isOpenRefundInvoice
                                      ? SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: CircularProgressIndicator(color: primaryColor),
                                        ) 
                                      : SizedBox(
                                        height: 35,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              isOpenRefundInvoice = true; // Update the loading state
                                            });
                                            String url = localBuddyBookingData!['refundInvoice']; 
                                            String fileName = 'invoice'; 
                                            await downloadAndOpenPdfFromUrl(url, fileName);
                                            setState(() {
                                              isOpenRefundInvoice = false; // Update the state when done
                                            });
                                          }, 
                                          child:Text(
                                            "View Refund Invoice",
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,  
                                            foregroundColor: primaryColor,  
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(color: primaryColor, width: 2),
                                              borderRadius: BorderRadius.circular(10)
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
                              localBuddyBookingData!['bookingStatus'] == 2
                              ? Container(
                                width: double.infinity,
                                height: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Confirmation"),
                                            content: Text(
                                              "Due to the cancellation fee is RM100.00. Therefore, only amount of RM${NumberFormat('#,##0.00').format((localBuddyBookingData!['totalPrice'] - 100) ?? 0)} will be refunded to customer.",
                                              textAlign: TextAlign.justify,
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: primaryColor, // Set the background color
                                                  foregroundColor: Colors.white, // Set the text color
                                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                                  ),
                                                ),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                  refundToCustomer('Local Buddy', localBuddyBookingData!['bookingID'], (localBuddyBookingData!['totalPrice'] - 100).toInt(), 'localBuddyBooking');
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: primaryColor, // Set the background color
                                                  foregroundColor: Colors.white, // Set the text color
                                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                                  ),
                                                ),
                                                child: const Text("Refund"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }, 
                                    child: isRefunding
                                      ? CircularProgressIndicator(color: Colors.white)
                                      : Text(
                                          "Issue Refund",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10), // Set the button radius to 0
                                      ),
                                    ),
                                  )
                                )
                              : Container()
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
                        "Booking Date: ${data['travelDate'] ?? "N/A"}",
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

    List<DateTime> bookingDates = (data['bookingDate'] as List<dynamic>)
      .map((date) => (date as Timestamp).toDate())
      .toList();

    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
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
              border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: getScreenWidth(context) * 0.25,
                  height: getScreenHeight(context) * 0.15,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(carData['carImage'] ?? ''),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carData['carModel'] ?? "N/A",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 240, // Set a desired width
                        child: Text(
                          "Booking Date: ${bookingDates.map((date) => DateFormat('dd/MM/yyyy').format(date)).join(', ')}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                          maxLines: 1, // Optional: Limits to a single line
                        ),
                      ),
                      SizedBox(height: 5),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget localBuddyComponent({required Map<String, dynamic> data, required Map<String, dynamic> localBuddyData}) {
    List<DateTime> bookingDates = (data['bookingDate'] as List<dynamic>)
      .map((date) => (date as Timestamp).toDate())
      .toList();

    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
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
              border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: getScreenWidth(context) * 0.22,
                  height: getScreenHeight(context) * 0.13,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(localBuddyData['profileImage'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localBuddyData['localBuddyName'] ?? "N/A",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 240, // Set a desired width
                        child: Text(
                          "Booking Date: ${bookingDates.map((date) => DateFormat('dd/MM/yyyy').format(date)).join(', ')}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                          maxLines: 1, // Optional: Limits to a single line
                        ),
                      ),
                      SizedBox(height: 5),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
