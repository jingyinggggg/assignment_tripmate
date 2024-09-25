import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentViewCarInfo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TravelAgentCarMaintenanceScreen extends StatefulWidget {
  final String userId;
  final String carId;

  const TravelAgentCarMaintenanceScreen({super.key, required this.userId, required this.carId});

  @override
  State<TravelAgentCarMaintenanceScreen> createState() => _TravelAgentCarMaintenanceScreenState();
}

class _TravelAgentCarMaintenanceScreenState extends State<TravelAgentCarMaintenanceScreen> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate; // Keep this as null initially
  String? _selectedCarStatus;
  String? carModel;
  bool isUpdating = false;
  bool _isDataInitialized = false;
  List<String> carStatus = ['Reserved', 'Maintenance'];

  @override
  void initState() {
    super.initState();
    _fetchCarData();
  }

  Future<void> _fetchCarData() async {
    setState(() {
      _isDataInitialized = true;
    });
    try {
      DocumentReference carRef = FirebaseFirestore.instance.collection('car_rental').doc(widget.carId);
      DocumentSnapshot carSnapshot = await carRef.get();

      if (carSnapshot.exists) {
        Map<String, dynamic>? data = carSnapshot.data() as Map<String, dynamic>?;

        setState(() {
          _isDataInitialized = false;
          carModel = data?['carModel'] ?? '';
        });
      } else {
        setState(() {
          _isDataInitialized = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Current car does not exist in the system')),
          );
        });
      }
    } catch (e) {
      setState(() {
        _isDataInitialized = false;
      });
      print("Error fetching car details: $e");
    }
  }

  // Method to show date picker
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime.now(), // Disable past dates
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedStartDate) {
      setState(() {
        _selectedStartDate = pickedDate;
        // Reset the end date if the new start date is after the current end date
        if (_selectedEndDate != null && _selectedEndDate!.isBefore(_selectedStartDate!)) {
          _selectedEndDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? _selectedStartDate ?? DateTime.now(),
      firstDate: _selectedStartDate ?? DateTime.now(), // Disable dates before the start date
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedEndDate) {
      setState(() {
        _selectedEndDate = pickedDate;
      });
    }
  }

  Future<void> _submitCarMaintenance() async {
    // Check if the required fields are not null
    if (_selectedStartDate == null || _selectedEndDate == null || _selectedCarStatus == null || _selectedCarStatus!.isEmpty) {
      // Show error dialog if any field is empty
      showCustomDialog(
        context: context,
        title: 'Error',
        content: 'Please ensure all fields are filled (Start Date, End Date, and Car Status).',
        onPressed: () {
          Navigator.pop(context); // Close the dialog
        },
      );
      return; // Exit the function to avoid proceeding with submission
    }

    setState(() {
      isUpdating = true;
    });

    try {
      // Get the count of existing car maintenance records
      final cmSnapshot = await FirebaseFirestore.instance.collection('car_maintenance').get();
      final cmCount = cmSnapshot.size;

      // Generate new car maintenance ID
      final carMaintenanceID = 'CM${(cmCount + 1).toString().padLeft(4, '0')}';

      // Save the car maintenance data to Firestore
      await FirebaseFirestore.instance.collection('car_maintenance').doc(carMaintenanceID).set({
        'carMaintenanceID': carMaintenanceID,
        'carMaintenanceStartDate': _selectedStartDate,
        'carMaintenanceEndDate': _selectedEndDate,
        'carStatus': _selectedCarStatus,
        'carID': widget.carId
      });

      setState(() {
        isUpdating = false;
      });

      // Show success dialog
      showCustomDialog(
        context: context,
        title: 'Success',
        content: 'You have submitted the maintenance form successfully.',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TravelAgentViewCarListingScreen(userId: widget.userId)),
          );
        },
      );
    } catch (e) {
      // Handle any errors during the submission process
      showCustomDialog(
        context: context,
        title: 'Error',
        content: 'An error occurred while submitting the maintenance form. Please try again.',
        onPressed: () {
          Navigator.pop(context); // Close the dialog
        },
      );
    } finally {
      setState(() {
        isUpdating = false; // Reset the loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Car Maintenance"),
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
              MaterialPageRoute(builder: (context) => TravelAgentViewCarListingScreen(userId: widget.userId)),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          if (!_isDataInitialized)
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 90,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(0, 4),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carModel ?? 'N/A',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: defaultLabelFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Car ID: ${widget.carId}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: defaultFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Please choose the maintenance date of selected car:',
                        style: TextStyle(
                          fontSize: defaultFontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      maintenanceDate('Select Maintenance Start Date', 'Start Date', _selectedStartDate, _selectStartDate),
                      SizedBox(height: 20),
                      maintenanceDate('Select Maintenance End Date', 'End Date', _selectedEndDate, _selectEndDate),
                      SizedBox(height: 20),
                      buildDropDownList(
                        carStatus, 
                        'Select status of car', 
                        'Car Status', 
                        _selectedCarStatus,
                        (newValue){
                          setState(() {
                            _selectedCarStatus = newValue;
                          });
                        }
                      ),
                      SizedBox(height: 10),
                      // Align the button to the right
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {_submitCarMaintenance();},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Button radius
                              ),
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: defaultFontSize,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (isUpdating)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (_isDataInitialized)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget maintenanceDate(String hintText, String labelText, DateTime? selectedDate, Function(BuildContext) onSelect) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: TextFormField(
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: defaultFontSize,
          color: Colors.black54,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
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
            onPressed: () => onSelect(context),
          ),
        ),
        controller: TextEditingController(
          text: selectedDate != null
              ? DateFormat('dd/MM/yyyy').format(selectedDate)
              : hintText,
        ),
        readOnly: true,
      ),
    );
  }

    Widget buildDropDownList(
      List<String> listname, String hintText, String label, String? selectedValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: Text(hintText),
      decoration: InputDecoration(
        labelText: label,
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
      items: listname.map<DropdownMenuItem<String>>((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: onChanged, // Use the passed in function
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: defaultFontSize,
        color: Colors.black,
      ),
    );
  }
}
