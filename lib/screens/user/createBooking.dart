import 'dart:convert';

import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class createBookingScreen extends StatefulWidget {
  final String userId;
  final String? tourID;
  final String? carRentalID;
  final String? localBuddyID;
  final bool tour;
  final bool carRental;
  final bool localBuddy;

  const createBookingScreen({
    super.key,
    required this.userId,
    this.tourID,
    this.carRentalID,
    this.localBuddyID,
    this.tour = false,
    this.carRental = false,
    this.localBuddy = false,
  });

  @override
  State<createBookingScreen> createState() => _createBookingScreenState();
}

class _createBookingScreenState extends State<createBookingScreen> {
  // Tour 
  UserViewTourList? _tour; 
  bool isLoadingTour = false;
  bool isBookTour = false;
  List<String> availableDateRanges = []; 
  List<Map<String, dynamic>> availabilityList = []; 
  String? selectedDateRange;
  int? selectedSlot;
  int? price;
  double? remainingPrice;
  String? _paxErrorMessage;
  final TextEditingController _paxController = TextEditingController();

  // Car Rental
  bool isLoadingCarRental = false;
  bool isBookCar = false;
  CarList? _carRental;
  final TextEditingController _rentStartDateController = TextEditingController();
  final TextEditingController _rentEndDateController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // Local Buddy
  bool isLoadingLocalBuddy = false;
  bool isBookLocalBuddy = false;
  LocalBuddy? _localBuddy;
  final TextEditingController _LbStartDateController = TextEditingController();
  final TextEditingController _LbEndDateController = TextEditingController();
  DateTime? _selectedLbStartDate;
  DateTime? _selectedLbEndDate;
  String? locationArea;

  @override
  void initState() {
    super.initState();
    if (widget.tour) {
      _fetchTourDetails();
    } else if (widget.carRental) {
      _fetchCarDetails();
    } else {
      _fetchLocalBuddyDetails();
    }
  }

  Future<void> _fetchTourDetails() async {
    setState(() {
      isLoadingTour = true;
    });

    try {
      DocumentReference tourRef = FirebaseFirestore.instance.collection('tourPackage').doc(widget.tourID);
      DocumentSnapshot tourSnapshot = await tourRef.get();

      if (tourSnapshot.exists) {
        Map<String, dynamic>? tourData = tourSnapshot.data() as Map<String, dynamic>?;

        if (tourData != null) {
          setState(() {
            _tour = UserViewTourList(
              tourData['tourName'],
              tourData['tourID'],
              tourData['tourCover'],
              tourData['agency'],
              tourData['tourHighlight'],
              tourData['availability'], 
            );

            if (tourData['availability'] != null) {
              availabilityList = List<Map<String, dynamic>>.from(tourData['availability']);
              availableDateRanges = availabilityList.map((item) => item['dateRange'] as String).toList();
            }
          });
        }
      }
    } catch (e) {
      print('Error fetching tour data: $e');
    } finally {
      setState(() {
        isLoadingTour = false;
      });
    }
  }

  Future<void> _fetchCarDetails() async {
    setState(() {
      isLoadingCarRental = true;
    });

    try {
      DocumentReference carRentalRef = FirebaseFirestore.instance.collection('car_rental').doc(widget.carRentalID);
      DocumentSnapshot carRentalSnapshot = await carRentalRef.get();

      if (carRentalSnapshot.exists) {
        Map<String, dynamic>? carData = carRentalSnapshot.data() as Map<String, dynamic>?;

        if (carData != null) {
          setState(() {
            _carRental = CarList(
              carData['carID'],
              carData['carModel'],
              carImage: carData['carImage'],
              agentID: carData['agencyID'],
              agencyName: carData['agencyName'],
              price: carData['pricePerDay'],
              carType: carData['carType'],
              fuel: carData['fuel'],
              transmission: carData['transmission'],
              seat: carData['seat'],
              pickUpLocation: carData['pickUpLocation'],
              dropOffLocation: carData['dropOffLocation']
            );
          });
        }
      }
    } catch (e) {
      print('Error fetching tour data: $e');
    } finally {
      setState(() {
        isLoadingCarRental = false;
      });
    }
  }

  Future<void> _fetchLocalBuddyDetails() async {
    setState(() {
      isLoadingLocalBuddy = true;
    });

    try {
      DocumentReference LBRef = FirebaseFirestore.instance.collection('localBuddy').doc(widget.localBuddyID);
      DocumentSnapshot LBSnapshot = await LBRef.get();

      if (LBSnapshot.exists) {
        Map<String, dynamic>? LBData = LBSnapshot.data() as Map<String, dynamic>?;

        if (LBData != null) {
          DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(LBData['userID']);
          DocumentSnapshot snapshot = await ref.get();

          Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

          if (LBData.containsKey('location')) {
            String fullAddress = LBData['location'] ?? '';

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
              _localBuddy = LocalBuddy(
                localBuddyID: LBData['localBuddyID'],
                localBuddyName: userData?['name'],
                localBuddyImage: userData?['profileImage'],
                locationArea: locationArea,
                pricePerHour: LBData['pricePerHour']
              );
            });
          } else{
            setState(() {
              isLoadingLocalBuddy = false;
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching local buddy data: $e');
    } finally {
      setState(() {
        isLoadingLocalBuddy = false;
      });
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
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
      body: widget.tour
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: _tour != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          tourComponent(tour: _tour!),
                          const SizedBox(height: 20),
                          const Text(
                            'Availability',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: defaultLabelFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 10),
                          if (selectedSlot != null)
                            Text(
                              'Available Slots: $selectedSlot',
                              style: const TextStyle(
                                fontSize: defaultFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          else
                            Row(
                              children: [
                                Text(
                                  'Available Slot: ',
                                  style: const TextStyle(
                                    fontSize: defaultFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'No Slot available',
                                  style: const TextStyle(
                                    fontSize: defaultFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            
                          SizedBox(height: 15),

                          DropdownButtonFormField<String>(
                            value: selectedDateRange,
                            hint: Text('Select date range'),
                            decoration: InputDecoration(
                              labelText: 'Date Range',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF467BA1),
                                  width: 2.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF467BA1),
                                  width: 2.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF467BA1),
                                  width: 2.5,
                                ),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelStyle: const TextStyle(
                                fontSize: defaultLabelFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0.5, 0.5),
                                    color: Colors.black87,
                                  ),
                                ],
                              ),
                            ),
                            items: availableDateRanges.map<DropdownMenuItem<String>>((String range) {
                              return DropdownMenuItem<String>(
                                value: range,
                                child: Text(range),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDateRange = newValue;

                                // Find the corresponding slot for the selected date range
                                var selectedAvailability = availabilityList.firstWhere((item) {
                                  return item['dateRange'] == selectedDateRange;
                                }, orElse: () => {},);

                                if (selectedAvailability.isNotEmpty) {
                                  // Update selectedSlot and price simultaneously
                                  selectedSlot = selectedAvailability['slot'] as int;
                                  price = selectedAvailability['price'] as int;
                                } else {
                                  selectedSlot = 0; // Default value if no availability found
                                  price = 0; // Default price
                                }
                              });
                            },
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: defaultFontSize,
                              color: Colors.black,
                            ),
                          ),

                          SizedBox(height: 15),

                          pax(),

                          SizedBox(height: 15),

                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 236, 250, 255),
                              border: Border.all(color: primaryColor, width: 2.5),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Term and Conditions',
                                  style: TextStyle(
                                    fontSize: defaultLabelFontSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: 10),
                                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '1. ',
                                          style: TextStyle(
                                            fontSize: defaultFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Expanded( // Allow the Text to expand and wrap text
                                          child: Text(
                                            'Deposit with RM 1000.00 is required to make a reservation for the selected tour.',
                                            style: TextStyle(
                                              fontSize: defaultFontSize,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '2. ',
                                          style: TextStyle(
                                            fontSize: defaultFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Expanded( // Allow the Text to expand and wrap text
                                          child: Text(
                                            'Deposit are not refundable when you cancel the bookings.',
                                            style: TextStyle(
                                              fontSize: defaultFontSize,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '3. ',
                                          style: TextStyle(
                                            fontSize: defaultFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Expanded( // Allow the Text to expand and wrap text
                                          child: Text(
                                            'The remaining balance must be paid at least one month prior to the tour date. If the payment is not received by this deadline, your booking will be automatically canceled.',
                                            style: TextStyle(
                                              fontSize: defaultFontSize,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '4. ',
                                          style: TextStyle(
                                            fontSize: defaultFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Expanded( // Allow the Text to expand and wrap text
                                          child: Text(
                                            'The balance can pay through online banking or QR pay.',
                                            style: TextStyle(
                                              fontSize: defaultFontSize,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          if(selectedDateRange != '' && _paxController.text.isNotEmpty)...[
                            Text(
                                'Summary',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: defaultLabelFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),

                              const SizedBox(height: 5),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Deposit',
                                    style: TextStyle(
                                      fontSize: defaultFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 35, // Set fixed width for "RM"
                                        child: Text(
                                          'RM',
                                          style: TextStyle(
                                            fontSize: defaultFontSize,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: Text(
                                          '${NumberFormat('#,##0.00').format(1000)}',
                                          style: TextStyle(
                                            fontSize: defaultFontSize,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 5),

                              // Remaining Price
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Remaining Price',
                                    style: TextStyle(
                                      fontSize: defaultFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 35, // Set fixed width for "RM"
                                        child: Text(
                                          'RM',
                                          style: TextStyle(
                                            fontSize: defaultFontSize,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: Text(
                                          '${NumberFormat('#,##0.00').format((price! * int.parse(_paxController.text)) - 1000)}',
                                          style: TextStyle(
                                            fontSize: defaultFontSize,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),


                              Divider(),

                              // Tour Price Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Price (RM ${NumberFormat('#,##0.00').format(price!)} x ${_paxController.text})',
                                    style: TextStyle(
                                      fontSize: defaultFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 35, // Set fixed width for "RM"
                                        child: Text(
                                          'RM',
                                          style: TextStyle(
                                            fontSize: defaultFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: Text(
                                          '${NumberFormat('#,##0.00').format(price! * int.parse(_paxController.text))}',
                                          style: TextStyle(
                                            fontSize: defaultFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirmation"),
                                          content: Text(
                                            "Please review your booking details and read the terms and conditions carefully before proceeding with payment. A deposit of RM 1,000.00 will be charged when you click the 'Pay' button. The remaining balance must be paid at least one month before the trip date.",
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
                                                Navigator.pop(context); // Exit the current screen
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor: primaryColor, // Set the background color
                                                foregroundColor: Colors.white, // Set the text color
                                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                                ),
                                              ),
                                              child: const Text("Pay"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Pay Deposit',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                          ]
                        ],
                      )
                    : const Center(child: CircularProgressIndicator(color: primaryColor)), // Show a loader while fetching
              ),
            )
          : widget.carRental
              ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: _carRental != null
                      ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CarComponent(carRental: _carRental!),
                            SizedBox(height: 20),
                            _buildLocationSection(),
                            SizedBox(height: 20),
                            Text(
                              'Availability',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: defaultLabelFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            _buildDatePickerTextFieldCell(
                              _rentStartDateController, 
                              'Start Date', 
                              'Select a date',
                              onDateSelected: (DateTime selectedDate){
                                setState(() {
                                  _selectedStartDate = selectedDate;
                                });

                                DateTime firstEndDate = selectedDate.add(Duration(days:1));
                                _updateReturnDatePicker(firstEndDate);
                              }
                            ),
                            SizedBox(height: 15),
                            _buildDatePickerTextFieldCell(
                              _rentEndDateController, 
                              'End Date', 
                              'Select a date',
                              firstDate: _getFirstReturnDate(),
                              isEndDate: true,
                              startDateSelected: _rentStartDateController.text.isNotEmpty,
                              onDateSelected: (DateTime selectedDate){
                                setState(() {
                                  _selectedEndDate = selectedDate;
                                });
                              }
                            ),
                            SizedBox(height: 15),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 236, 250, 255),
                                border: Border.all(color: primaryColor, width: 2.5),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Term and Conditions',
                                    style: TextStyle(
                                      fontSize: defaultLabelFontSize,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '1. ',
                                            style: TextStyle(
                                              fontSize: defaultFontSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Expanded( // Allow the Text to expand and wrap text
                                            child: Text(
                                              'Deposit with RM 500.00 is required at the time of booking. It will be returned after car is inspected and found to be in the same condition as when rented.',
                                              style: TextStyle(
                                                fontSize: defaultFontSize,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '2. ',
                                            style: TextStyle(
                                              fontSize: defaultFontSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Expanded( // Allow the Text to expand and wrap text
                                            child: Text(
                                              'The deposit will not be refunded if the car is found to be damaged or broken.',
                                              style: TextStyle(
                                                fontSize: defaultFontSize,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '3. ',
                                            style: TextStyle(
                                              fontSize: defaultFontSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Expanded( // Allow the Text to expand and wrap text
                                            child: Text(
                                              'The deposit will be refunded if the booking is canceled but a cancellation fee of RM 100.00 will be charged and deducted from the refund.',
                                              style: TextStyle(
                                                fontSize: defaultFontSize,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '4. ',
                                            style: TextStyle(
                                              fontSize: defaultFontSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Expanded( // Allow the Text to expand and wrap text
                                            child: Text(
                                              'The payment can pay through online banking or QR pay.',
                                              style: TextStyle(
                                                fontSize: defaultFontSize,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20),

                            if(_selectedEndDate != null && _selectedStartDate != null)...[
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirmation"),
                                          content: Text(
                                            "Please review your booking details and read the terms and conditions carefully before proceeding with payment.",
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
                                                Navigator.pop(context); // Exit the current screen
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor: primaryColor, // Set the background color
                                                foregroundColor: Colors.white, // Set the text color
                                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                                ),
                                              ),
                                              child: const Text("Pay"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                          'Book',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          ]
                        )
                      : Center(child: CircularProgressIndicator(color: primaryColor))
                )
              )
              : widget.localBuddy
                ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: _localBuddy != null
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LBComponent(localBuddy: _localBuddy!),
                              SizedBox(height: 20),
                              Text(
                                'Availability',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: defaultLabelFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 10),
                              _buildDatePickerTextFieldCell(
                                _LbStartDateController, 
                                'Start Date', 
                                'Select a date',
                                onDateSelected: (DateTime selectedDate){
                                  setState(() {
                                    _selectedLbStartDate = selectedDate;
                                  });

                                  DateTime firstEndDate = selectedDate.add(Duration(days:1));
                                  _updateReturnDatePicker(firstEndDate);
                                }
                              ),
                              SizedBox(height: 15),
                              _buildDatePickerTextFieldCell(
                                _LbEndDateController, 
                                'End Date', 
                                'Select a date',
                                firstDate: _getFirstReturnDate(),
                                isEndDate: true,
                                startDateSelected: _LbStartDateController.text.isNotEmpty,
                                onDateSelected: (DateTime selectedDate){
                                  setState(() {
                                    _selectedLbEndDate = selectedDate;
                                  });
                                }
                              ),
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 236, 250, 255),
                                  border: Border.all(color: primaryColor, width: 2.5),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Term and Conditions',
                                      style: TextStyle(
                                        fontSize: defaultLabelFontSize,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '1. ',
                                              style: TextStyle(
                                                fontSize: defaultFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Expanded( // Allow the Text to expand and wrap text
                                              child: Text(
                                                'Cancellations must be made at least 24 hours before the scheduled booking for a full refund.',
                                                style: TextStyle(
                                                  fontSize: defaultFontSize,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '2. ',
                                              style: TextStyle(
                                                fontSize: defaultFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Expanded( // Allow the Text to expand and wrap text
                                              child: Text(
                                                'Cancellations made less than 24 hours before the bookings may be subject to a RM 100.00 cancellation fee.',
                                                style: TextStyle(
                                                  fontSize: defaultFontSize,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '3. ',
                                              style: TextStyle(
                                                fontSize: defaultFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Expanded( // Allow the Text to expand and wrap text
                                              child: Text(
                                                'The payment can pay through online banking or QR pay.',
                                                style: TextStyle(
                                                  fontSize: defaultFontSize,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20),

                              if(_selectedLbStartDate != null && _selectedLbEndDate != null)...[
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Confirmation"),
                                            content: Text(
                                              "Please review your booking details and read the terms and conditions carefully before proceeding with payment.",
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
                                                  Navigator.pop(context); // Exit the current screen
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: primaryColor, // Set the background color
                                                  foregroundColor: Colors.white, // Set the text color
                                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                                  ),
                                                ),
                                                child: const Text("Pay"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Book',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ]
                          )
                        : Center(child: CircularProgressIndicator(color: primaryColor))
                  )
                )
                : Container(), // Fallback in case none is selected
    );
  }

  Widget tourComponent({
    required UserViewTourList tour,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1.5, color: const Color(0xFF467BA1)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 105,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(tour.image),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                border: const Border(
                  right: BorderSide(color: Color(0xFF467BA1), width: 1.5),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tour.tourName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          "Agency: ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          tour.agency,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Displaying tour highlights
                    ...tour.tourHighlight.map((highlight) {
                      final no = highlight["no"] ?? 'No Numbering';
                      final description = highlight["description"] ?? 'No Description';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$no. ",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Expanded(
                              child: Text(
                                description,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.justify,
                                maxLines: null,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pax() {
    return TextField(
      controller: _paxController,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: defaultFontSize,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter number of people',
        labelText: 'Number of people',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF467BA1),
            width: 2.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF467BA1),
            width: 2.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF467BA1),
            width: 2.5,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(
          fontSize: defaultLabelFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          shadows: [
            Shadow(
              offset: Offset(0.5, 0.5),
              color: Colors.black87,
            ),
          ],
        ),
        errorText: _paxErrorMessage,
      ),
      onChanged: (value) {
        // Validate the input
        int? paxValue = int.tryParse(value);
        if (paxValue == null || paxValue <= 0) {
          setState(() {
            _paxErrorMessage = 'Please enter a valid number of people';
          });
        } else if (paxValue > selectedSlot!) {
          setState(() {
            _paxErrorMessage = 'Number of people cannot exceed available slots ($selectedSlot)';
          });
        } else {
          setState(() {
            _paxErrorMessage = null; // Clear the error message if valid
          });
        }
      },
    );
  }

  Widget CarComponent({required CarList carRental}) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2.5),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Wrap this inner Row with Expanded to make sure it takes the available space
          Expanded(
            child: Row(
              children: [
                // Image container with fixed width and height
                Container(
                  width: getScreenWidth(context) * 0.25,
                  height: getScreenHeight(context) * 0.11,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(carRental.carImage!),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Text widget wrapped in Expanded to take remaining space
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carRental.carModel, 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.bold, 
                          fontSize: defaultLabelFontSize,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Provider: ${carRental.agencyName}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: defaultFontSize
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Car Type: ${carRental.carType}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: defaultFontSize
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Transmission: ${carRental.transmission}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: defaultFontSize
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Fuel: ${carRental.fuel}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: defaultFontSize
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Seat: ${carRental.seat}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: defaultFontSize
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'RM${(carRental.price ?? 0).toStringAsFixed(0)}/day',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: defaultFontSize
                          ),
                          textAlign: TextAlign.right,
                        )
                      )
                    ],
                  )
                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Location", style: TextStyle(fontSize: defaultLabelFontSize, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        _buildLocationContainer(),
      ],
    );
  }

  Widget _buildLocationContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding( // Adding some padding to avoid text touching the container's border
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
          children: [
            Text(
              'Pick Up Location',
              style: TextStyle(
                fontSize: defaultFontSize,
                fontWeight: FontWeight.w600,
                ),
            ),
            SizedBox(height: 5), // Adding some space between the title and the content
            Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                size: 20,
                color: primaryColor,
              ),
              SizedBox(width: 5),
              Flexible( // Wraps the text, allowing it to wrap properly within the row and container
                child: Text(
                  _carRental?.pickUpLocation ?? 'N/A',
                  style: TextStyle(
                    fontSize: defaultFontSize,
                  ),
                  maxLines: null,
                  overflow: TextOverflow.visible, 
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Drop Off Location',
            style: TextStyle(
            fontSize: defaultFontSize,
            fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5), // Adding some space between the title and the content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                size: 20,
                color: primaryColor,
              ),
              SizedBox(width: 5),
              Flexible( // Wraps the text, allowing it to wrap properly within the row and container
                child: Text(
                  _carRental?.dropOffLocation ?? 'N/A',
                  style: TextStyle(
                    fontSize: defaultFontSize,
                  ),
                  maxLines: null,
                  overflow: TextOverflow.visible, 
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ] ,
        ),
      ),
    );
  }

  Widget _buildDatePickerTextFieldCell(
    TextEditingController controller,
    String labeltext,
    String hintText, {
    DateTime? firstDate,
    void Function(DateTime)? onDateSelected,
    bool isEndDate = false,
    bool startDateSelected = true,
  }) {
    return GestureDetector(
      onTap: (){},
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: defaultFontSize,
          color: Colors.black,
        ),
        readOnly: true,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labeltext,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF467BA1),
              width: 2.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF467BA1),
              width: 2.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF467BA1),
              width: 2.5,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(
            fontSize: defaultLabelFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            shadows: [
              Shadow(
                offset: Offset(0.5, 0.5),
                color: Colors.black87,
              ),
            ],
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFF467BA1),
              size: 20,
            ),
            onPressed: () async {
              if (isEndDate && !startDateSelected) {
                // Show a message asking the user to select the departure date first
                _showSelectStartDateFirstMessage();
                return;
              }

              DateTime initialDate = firstDate ?? DateTime.now();
              DateTime firstAvailableDate = firstDate ?? DateTime.now();

              // Show date picker with a minimum date constraint
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: firstAvailableDate,
                lastDate: DateTime(2101),
              );

              if (pickedDate != null) {
                // Format the date
                String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                controller.text = formattedDate;
                if (onDateSelected != null) {
                  onDateSelected(pickedDate);
                }
              }
            },
          ),
        ),
      ),

    );
  }

  void _updateReturnDatePicker(DateTime firstDate) {
    setState(() {
      // Reset the return date controller
      _rentEndDateController.clear();
      _rentEndDateController.text = ""; // Resetting the text field
    });
  }

  DateTime _getFirstReturnDate() {
    // Return the first available return date based on the selected depart date or a default date
    return _selectedStartDate?.add(const Duration(days: 0)) ?? DateTime.now().add(const Duration(days: 0));
  }

  void _showSelectStartDateFirstMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Start Date First"),
        content: const Text("Please select the renatl start date before choosing the rental end date."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget LBComponent({required LocalBuddy localBuddy}) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2.5),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Wrap this inner Row with Expanded to make sure it takes the available space
          Expanded(
            child: Row(
              children: [
                // Image container with fixed width and height
                Container(
                  width: getScreenWidth(context) * 0.2,
                  height: getScreenHeight(context) * 0.15,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(localBuddy.localBuddyImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Text widget wrapped in Expanded to take remaining space
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localBuddy.localBuddyName, 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.bold, 
                          fontSize: defaultLabelFontSize,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Location: ${localBuddy.locationArea}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: defaultFontSize
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'RM${(localBuddy.pricePerHour ?? 0).toStringAsFixed(0)}/hour',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: defaultFontSize
                          ),
                          textAlign: TextAlign.right,
                        )
                      )
                    ],
                  )
                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

