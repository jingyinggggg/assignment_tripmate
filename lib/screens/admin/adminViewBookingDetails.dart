import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/admin/adminViewCustomerDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminViewBookingDetailsScreen extends StatefulWidget {
  final String userId;
  final String? tourID;
  final String? carRentalID;
  final String? localBuddyID;
  final String? localBuddyUserID;
  final int totalBookingNumber;

  const AdminViewBookingDetailsScreen({
    super.key, 
    required this.userId,
    this.tourID,
    this.carRentalID,
    this.localBuddyID,
    this.localBuddyUserID,
    required this.totalBookingNumber
  });

  @override
  State<AdminViewBookingDetailsScreen> createState() => _AdminViewBookingDetailsScreenState();
}

class _AdminViewBookingDetailsScreenState extends State<AdminViewBookingDetailsScreen> {
  bool isFetchingTourDetails = false;
  bool isFetchingCarRentalDetails = false;
  bool isFetchingLocalBuddyDetails = false;
  bool isFetchingCustomerList = false;
  Map<String, dynamic>? tourData;
  Map<String, dynamic>? carData;
  Map<String, dynamic>? localBuddyData;
  List<Map<String, dynamic>> customerList = [];

  @override
  void initState() {
    super.initState();
    if(widget.tourID != null){
      _fetchTourDetails();
    } else if(widget.carRentalID != null){
      _fetchCarRentalDetails();
    } else if(widget.localBuddyID != null){
      _fetchLocalBuddyDetails();
    }
    _fetchCustomerList();
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

  Future<void>_fetchCarRentalDetails() async {
    setState(() {
      isFetchingCarRentalDetails = true;
    });

    try{
      DocumentReference carRentalRef = FirebaseFirestore.instance.collection('car_rental').doc(widget.carRentalID);
      DocumentSnapshot carRentalSnap = await carRentalRef.get();

      if(carRentalSnap.exists){
        Map<String, dynamic>? data = carRentalSnap.data() as Map<String, dynamic>?;

        setState(() {
          carData = data;
        });
      }
    } catch(e){
      print("Error fetch car rental data: $e");
    } finally{
      setState(() {
        isFetchingCarRentalDetails = false;
      });
    }
  }

  Future<void> _fetchLocalBuddyDetails() async {
    setState(() {
      isFetchingLocalBuddyDetails = true;
    });

    try {
      // Fetch the local buddy data
      DocumentReference lbRef = FirebaseFirestore.instance.collection('localBuddy').doc(widget.localBuddyID);
      DocumentSnapshot lbSnap = await lbRef.get();

      if (lbSnap.exists) {
        Map<String, dynamic>? data = lbSnap.data() as Map<String, dynamic>?;

        // Fetch the user data from 'users' collection
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(widget.localBuddyUserID);
        DocumentSnapshot userSnapshot = await userRef.get();

        if (userSnapshot.exists) {
          Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            // Add user name and profile image to local buddy data
            data!['localBuddyName'] = userData['name'] ?? 'Unknown Name';
            data['profileImage'] = userData['profileImage'] ?? 'default_image_url';
          }
        }

        setState(() {
          localBuddyData = data;
        });
      }
    } catch (e) {
      print("Error fetching local buddy data: $e");
    } finally {
      setState(() {
        isFetchingLocalBuddyDetails = false;
      });
    }
  }

  Future<void>_fetchCustomerList() async{
    setState(() {
      isFetchingCustomerList = true;
    });
    try{
      if(widget.tourID != null){
        // Step 1: Query the tourBooking collection to get userIDs and tourBookingIDs for the given tourID
        QuerySnapshot tourBookings = await FirebaseFirestore.instance
          .collection('tourBooking')
          .where('tourID', isEqualTo:  widget.tourID)
          .get();
        
        // Loop thorugh each booking to get userID and tourBookingID
        for (var booking in tourBookings.docs){
          String userId = booking['userID'];
          String tourBookingID = booking.id;
          int bookingStatus = booking['bookingStatus'];

          // Step 2: Fetch customer details for each userID from the users collection
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
          
          if (userDoc.exists) {
            setState(() {
              // Save customer details along with tourBookingID
              customerList.add({
                'userID': userId,
                'tourBookingID': tourBookingID,
                'bookingStatus': bookingStatus,
                'customerInfo': userDoc.data() as Map<String, dynamic>,
              });
            });
          }
        }
      } else if(widget.carRentalID != null){
        // Step 1: Query the car rental booking collection to get userIDs and carRentalBookingIDs for the given tourID
        QuerySnapshot carBookings = await FirebaseFirestore.instance
          .collection('carRentalBooking')
          .where('carID', isEqualTo:  widget.carRentalID)
          .get();
        
        // Loop thorugh each booking to get userID and carRentalBookingID
        for (var booking in carBookings.docs){
          String userId = booking['userID'];
          String carRentalBookingID = booking.id;
          int bookingStatus = booking['bookingStatus'];
          int isRefund = booking['isRefund'];
          int refundStatus = booking['isRefundDeposit'];
          int isCheckCarCondition = booking['isCheckCarCondition'];

          // Step 2: Fetch customer details for each userID from the users collection
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
          
          if (userDoc.exists) {
            setState(() {
              // Save customer details along with tourBookingID
              customerList.add({
                'userID': userId,
                'carRentalBookingID': carRentalBookingID,
                'bookingStatus': bookingStatus,
                'isRefund': isRefund,
                'isRefundDeposit': refundStatus,
                'isCheckCarCondition': isCheckCarCondition,
                'customerInfo': userDoc.data() as Map<String, dynamic>,
              });
            });
          }
        }
      } else if(widget.localBuddyID != null){
        // Step 1: Query the local buddy booking collection to get userIDs and localBuddyBookingIDs for the given localBuddyID
        QuerySnapshot localBuddyBookings = await FirebaseFirestore.instance
          .collection('localBuddyBooking')
          .where('localBuddyID', isEqualTo:  widget.localBuddyID)
          .get();
        
        // Loop thorugh each booking to get userID and localBuddyBookingID
        for (var booking in localBuddyBookings.docs){
          String userId = booking['userID'];
          String localBuddyBookingID = booking.id;
          int bookingStatus = booking['bookingStatus'];
          int refundStatus = booking['isRefund'];

          // Step 2: Fetch customer details for each userID from the users collection
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
          
          if (userDoc.exists) {
            setState(() {
              // Save customer details along with tourBookingID
              customerList.add({
                'userID': userId,
                'localBuddyBookingID': localBuddyBookingID,
                'bookingStatus': bookingStatus,
                'isRefund': refundStatus,
                'customerInfo': userDoc.data() as Map<String, dynamic>,
              });
            });
          }
        }
      }
    }catch(e){
      print('Error fetch customer list: $e');
    } finally{
      setState(() {
        isFetchingCustomerList = false;
      });
    }
  }

  List<Map<String, dynamic>> sortedCustomerList(List<Map<String, dynamic>> customerList, String type) {
    customerList.sort((a, b) {
      int statusA = a['bookingStatus'];
      int statusB = b['bookingStatus'];

      if (type == "Car Rental" || type == "Local Buddy") {
        // Check if status is 2 (Canceled) and whether the refund is processed
        bool isRefundA = a['isRefund'] == 1;
        bool isRefundB = b['isRefund'] == 1;

        // If both have bookingStatus = 2, compare by isRefund to push refunded ones to the end
        if (statusA == 2 && statusB == 2) {
          if (isRefundA && !isRefundB) return 1;  // a comes after b if a is refunded and b is not
          if (!isRefundA && isRefundB) return -1; // a comes before b if a is not refunded and b is
          return 0; // Both are canceled with the same refund status, no change in order
        }

        // Handle canceled but non-refunded bookings before others
        if (statusA == 2 && !isRefundA && statusB != 2) return -1; // a comes before b
        if (statusA != 2 && statusB == 2 && !isRefundB) return 1;  // b comes before a

        // Compare for other statuses
        if (statusA == 0 && statusB == 1) return -1; // Upcoming comes before Completed
        if (statusA == 1 && statusB == 0) return 1;  // Completed comes after Upcoming
      } else {
        // Fallback logic for other types (Upcoming = 0, Completed = 1, Canceled = 2)
        if (statusA == 0 && statusB != 0) return -1; // Upcoming comes before all others
        if (statusA != 0 && statusB == 0) return 1;  // Others come after Upcoming

        if (statusA == 1 && statusB != 1) return -1; // Completed comes before Canceled
        if (statusA != 1 && statusB == 1) return 1;  // Canceled comes after Completed

        if (statusA == 2 && statusB != 2) return 1;  // Canceled comes last
        if (statusA != 2 && statusB == 2) return -1; // All come before Canceled
      }

      return 0; // No change in order for the same statuses
    });

    return customerList;
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
      body: isFetchingTourDetails || isFetchingCarRentalDetails || isFetchingLocalBuddyDetails
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
                  ] else if (carData?['carImage'] != null)...[
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(carData!['carImage']),
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
                                  carData!['carModel'] ?? 'No Name',
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
                  ] else if (localBuddyData?['profileImage'] != null)...[
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(localBuddyData!['profileImage']),
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
                                  localBuddyData!['localBuddyName'] ?? 'No Name',
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
                        widget.tourID != null ? tourDetailsComponent(tourData) : widget.carRentalID != null ? carDetailsComponent(carData) : localBuddyDetailsComponent(localBuddyData),
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
                        Row(
                          children: [
                            Text(
                              "(Status: ",
                              style: TextStyle(
                                fontSize: 12, 
                                color: Colors.black, 
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            Icon(Icons.event, color: Colors.orange, size: 15),
                            Text(
                              " = upcoming, ",
                              style: TextStyle(
                                fontSize: 12, 
                                color: Colors.black, 
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            Icon(Icons.check_circle, color: Colors.green, size: 15),
                            Text(
                              " = completed, ",
                              style: TextStyle(
                                fontSize: 12, 
                                color: Colors.black, 
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            Icon(Icons.cancel, color: Colors.red, size: 15),
                            Text(
                              " = canceled)",
                              style: TextStyle(
                                fontSize: 12, 
                                color: Colors.black, 
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        widget.tourID != null
                        ? Container()
                        : Row(
                            children: [
                              Text(
                                "(Refund: ",
                                style: TextStyle(
                                  fontSize: 12, 
                                  color: Colors.black, 
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Icon(Icons.check_circle, color: Colors.green, size: 15),
                              Text(
                                " = refunded, empty = not refund yet/ no refund)",
                                style: TextStyle(
                                  fontSize: 12, 
                                  color: Colors.black, 
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 10),
                        isFetchingCustomerList
                        ? Center(child: CircularProgressIndicator(color: primaryColor))
                        : customerList.isNotEmpty
                          ? customerListComponent(data: sortedCustomerList(customerList, widget.tourID != null ? "Tour" : widget.carRentalID != null ? "Car Rental" : "Local Buddy"), type: widget.tourID != null ? "Tour" : widget.carRentalID != null ? "Car" : "Local Buddy")
                          : Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Image(
                                  image: AssetImage('images/manage_booking.png'),
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "No bookings exist in the system yet.",
                                  style: TextStyle(
                                    fontSize: defaultFontSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            )
                          )
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

  Widget carDetailsComponent(Map<String, dynamic>? data) {
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
                  _buildTextFieldCell(data?['carID']?.toString() ?? 'N/A'),
                ],
              ),
              TableRow(
                children: [
                  _buildTextFieldCell("Amount", isBold: true),
                  _buildTextFieldCell('RM${(data?['pricePerDay'] ?? 0).toStringAsFixed(0)}/day'),
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

  Widget localBuddyDetailsComponent(Map<String, dynamic>? data) {
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
                  _buildTextFieldCell(data?['localBuddyID']?.toString() ?? 'N/A'),
                ],
              ),
              TableRow(
                children: [
                  _buildTextFieldCell("Amount", isBold: true),
                  _buildTextFieldCell('RM${(data?['price'] ?? 0).toStringAsFixed(0)}/day'),
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

  Widget customerListComponent({required List<Map<String, dynamic>> data, required String type}) {
    // Determine if the refund column should be shown
    bool showRefundColumn = type == "Car" || type == "Local Buddy";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Table(
            columnWidths: showRefundColumn
                ? {
                    0: FixedColumnWidth(30),
                    1: FixedColumnWidth(130),
                    2: FixedColumnWidth(50),
                    3: FixedColumnWidth(55),
                    4: FixedColumnWidth(60),
                  }
                : {
                    0: FixedColumnWidth(40),
                    1: FixedColumnWidth(150),
                    2: FixedColumnWidth(60),
                    3: FixedColumnWidth(60),
                  },
            border: TableBorder.all(color: primaryColor, width: 1.5),
            children: [
              // Header Row
              TableRow(
                children: [
                  _buildTextFieldCell('No', isBold: true),
                  _buildTextFieldCell('Customer Name', isBold: true),
                  _buildTextFieldCell('Status', isBold: true),
                  if (showRefundColumn) _buildTextFieldCell('Refund', isBold: true),
                  _buildTextFieldCell('Actions', isBold: true),
                ],
              ),
              // Data Rows
              for (int index = 0; index < data.length; index++)
                TableRow(
                  children: [
                    _buildTextFieldCell('${index + 1}'),
                    _buildTextFieldCell(data[index]['customerInfo']['name'] ?? 'No Name', isRequestRefund: type == "Car" ? data[index]['isCheckCarCondition'] == 1 && data[index]['isRefund'] == 0 : false),
                    Container(
                      height: 40, // Set a specific height for centering
                      alignment: Alignment.center, // Center the row vertically
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
                        children: [
                          _buildStatusIcon(data[index]['bookingStatus']),
                        ],
                      ),
                    ),
                    if (showRefundColumn)
                      Container(
                        height: 40, // Set a specific height for centering
                        alignment: Alignment.center, // Center the row vertically
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
                          children: [
                            (data[index]['isRefund'] == 1 && data[index]['bookingStatus'] == 2) || (data[index]['isRefundDeposit'] == 1 && data[index]['bookingStatus'] == 1)
                                ? Icon(Icons.check_circle, color: Colors.green, size: 18)
                                : Container()
                          ],
                        ),
                      ),
                    Container(
                      height: 40, // Set a specific height for centering
                      alignment: Alignment.center, // Center the row vertically
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_red_eye, color: Colors.grey, size: 20),
                            onPressed: () {
                              // Handle view action
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminViewCustomerDetailsScreen(
                                    userId: widget.userId,
                                    customerId: data[index]['userID'],
                                    tourID: widget.tourID != null ? widget.tourID : null,
                                    tourBookingID: type == "Tour" ? data[index]['tourBookingID'] : null,
                                    carRentalID: widget.carRentalID != null ? widget.carRentalID : null,
                                    carRentalBookingID: type == "Car" ? data[index]['carRentalBookingID'] : null,
                                    localBuddyID: widget.localBuddyID != null ? widget.localBuddyID : null,
                                    localBuddyBookingID: type == "Local Buddy" ? data[index]['localBuddyBookingID'] : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }



  // Method to display the appropriate status icon based on bookingStatus
  Widget _buildStatusIcon(int status) {
    switch (status) {
      case 0: // Upcoming
        return Icon(Icons.event, color: Colors.orange, size: 18);
      case 1: // Completed
        return Icon(Icons.check_circle, color: Colors.green, size: 18);
      case 2: // Canceled
        return Icon(Icons.cancel, color: Colors.red, size: 18);
      default:
        return Icon(Icons.help_outline, color: Colors.grey, size: 18); // Fallback
    }
  }

  Widget _buildTextFieldCell(String text, {bool isBold = false, bool isRequestRefund = false}) {
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
            color: isRequestRefund ? Colors.orangeAccent : Colors.black,
            fontWeight: isBold || isRequestRefund ? FontWeight.bold : FontWeight.w500
          ),
          maxLines: null, // Allows multiline input
          textAlign: TextAlign.center,
        ),
      )
    );
  }
}
