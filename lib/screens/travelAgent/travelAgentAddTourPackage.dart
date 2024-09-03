import 'dart:io';
import 'dart:typed_data';
import 'package:assignment_tripmate/saveImageToFirebase.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentViewTourList.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TravelAgentAddTourPackageScreen extends StatefulWidget {
  final String userId;
  final String countryName;
  final String cityName;

  const TravelAgentAddTourPackageScreen({
    super.key,
    required this.userId,
    required this.countryName,
    required this.cityName,
  });

  @override
  State<StatefulWidget> createState() => _TravelAgentAddTourPackageScreenState();
}

class _TravelAgentAddTourPackageScreenState extends State<TravelAgentAddTourPackageScreen> {
  final TextEditingController _tourNameController = TextEditingController();
  final TextEditingController _travelAgencyController = TextEditingController();
  final TextEditingController _imageNameController = TextEditingController();
  final TextEditingController _brochureController = TextEditingController();
  final List<TextEditingController> _tourHighlightControllers = [];
  final List<TextEditingController> _itineraryTitleControllers = [];
  final List<TextEditingController> _itineraryDescriptionControllers = [];
  final List<TextEditingController> _itineraryRemarksControllers = [];
  final List<TextEditingController> _flightDepartDateControllers = [];
  final List<TextEditingController> _flightReturnDateControllers = [];
  final List<TextEditingController> _flightNameControllers = [];
  final List<TextEditingController> _availableDateRangeControllers = [];
  final List<TextEditingController> _availableSlotControllers = [];
  final List<TextEditingController> _priceControllers = [];
  bool isLoading = false;
  Uint8List? _image;
  File? _uploadedPdfFile;

  void _initControllers() {
    for (var i = 0; i < _tourHighlights.length; i++) {
      _tourHighlightControllers.add(TextEditingController(text: _tourHighlights[i]['description']));
    }

    for (var i = 0; i < _itinerary.length; i++) {
      _itineraryTitleControllers.add(TextEditingController(text: _itinerary[i]['title']));
      _itineraryDescriptionControllers.add(TextEditingController(text: _itinerary[i]['description']));
      _itineraryRemarksControllers.add(TextEditingController(text: _itinerary[i]['remarks']));
    }

    for (var i = 0; i < _flight.length; i++) {
      _flightDepartDateControllers.add(TextEditingController(text: _flight[i]['depart']));
      _flightReturnDateControllers.add(TextEditingController(text: _flight[i]['return']));
      _flightNameControllers.add(TextEditingController(text: _flight[i]['flight']));
    }

    for (var i = 0; i < _availability.length; i++) {
      _availableDateRangeControllers.add(TextEditingController(text: _availability[i]['date']));
      _availableSlotControllers.add(TextEditingController(text: _availability[i]['slot']));
      _priceControllers.add(TextEditingController(text: _availability[i]['price']));
    }
  }

  final List<Map<String, String>> _tourHighlights = [
    {'no': '', 'description': ''},
  ];

  final List<Map<String, String>> _itinerary = [
    {'day': '', 'title': '', 'description': '', 'remarks': ''},
  ];

  final List<Map<String, String>> _flight = [
    {'no': '', 'depart': '', 'return': '', 'flight': ''},
  ];

  final List<Map<String, String>> _availability = [
    {'no': '', 'date': '', 'slot': '', 'price': ''},
  ];

  @override
  void initState() {
    super.initState();
    _initControllers();
    fetchTravelAgencyName();
  }

  @override
  void dispose() {
    _tourNameController.dispose();
    _travelAgencyController.dispose();
    _imageNameController.dispose();
    _brochureController.dispose();
    
    // Dispose tour highlight controllers
    for (var controller in _tourHighlightControllers) {
      controller.dispose();
    }

    // Dispose itinerary controllers
    for (var controller in _itineraryTitleControllers) {
      controller.dispose();
    }
    for (var controller in _itineraryDescriptionControllers) {
      controller.dispose();
    }
    for (var controller in _itineraryRemarksControllers) {
      controller.dispose();
    }

    // Dispose flight controllers
    for (var controller in _flightDepartDateControllers) {
      controller.dispose();
    }
    for (var controller in _flightReturnDateControllers) {
      controller.dispose();
    }
    for (var controller in _flightNameControllers) {
      controller.dispose();
    }

    // Dispose availability controllers
    for (var controller in _availableDateRangeControllers) {
      controller.dispose();
    }
    for (var controller in _availableSlotControllers) {
      controller.dispose();
    }
    for (var controller in _priceControllers) {
      controller.dispose();
    }

    // Call super.dispose() last
    super.dispose();
  }

  Future<void> fetchTravelAgencyName() async {
    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection('travelAgent')
        .where('id', isEqualTo: widget.userId)
        .limit(1)
        .get();
      
      DocumentSnapshot userDoc = userQuery.docs.first;
      var agencyData = userDoc.data() as Map<String, dynamic>;

      setState(() {
        _travelAgencyController.text = agencyData['companyName'];
      });
    } catch (e) {
      print("Error fetching agency details: $e");
    }
  }

void _addTourHighlightRow() {
  // Check if the last row's content is not empty
  if (_tourHighlightControllers.isNotEmpty && _tourHighlightControllers.last.text.trim().isEmpty) {
    // Show a message to the user to fill in the previous row first
    showSnackBar("Please ensure you have fill in the previous row before adding a new one.", context);
  } else {
    setState(() {
      _tourHighlights.add({'no': '', 'description': ''});
      _tourHighlightControllers.add(TextEditingController());
    });
  }
}

  void _addItineraryRow() {
    if(_itineraryTitleControllers.isNotEmpty && _itineraryDescriptionControllers.isNotEmpty && _itineraryRemarksControllers.isNotEmpty && 
    (_itineraryTitleControllers.last.text.trim().isEmpty || _itineraryDescriptionControllers.last.text.trim().isEmpty || _itineraryRemarksControllers.last.text.trim().isEmpty)){
      showSnackBar("Please ensure you have fill in the previous row before adding a new one.", context);
    } else {
      setState(() {
        _itinerary.add({'day': '', 'title': '', 'description': '', 'remarks': ''});
        _itineraryTitleControllers.add(TextEditingController());
        _itineraryDescriptionControllers.add(TextEditingController());
        _itineraryRemarksControllers.add(TextEditingController());
      });
    }
  }

  void _addFlightRow() {
    if(_flightDepartDateControllers.isNotEmpty && _flightReturnDateControllers.isNotEmpty & _flightNameControllers.isNotEmpty &&
    (_flightDepartDateControllers.last.text.trim().isEmpty || _flightReturnDateControllers.last.text.trim().isEmpty || _flightNameControllers.last.text.trim().isEmpty)){
      showSnackBar("Please ensure you have fill in the previous row before adding a new one.", context);
    } else{
      setState(() {
        _flight.add({'no': '', 'depart': '', 'return': '', 'flight': ''});
        _flightDepartDateControllers.add(TextEditingController());
        _flightReturnDateControllers.add(TextEditingController());
        _flightNameControllers.add(TextEditingController());

      });
    }
  }

  void _addAvailabilityRow() {
    if(_availableDateRangeControllers.isNotEmpty &&
    (_availableDateRangeControllers.last.text.trim().isEmpty)){
      showSnackBar("Please ensure you have fill in the previous row before adding a new one.", context);
    } else{
      setState(() {
        _availability.add({'no': '', 'date': '', 'slot': '', 'price': ''});
        _availableDateRangeControllers.add(TextEditingController());
        _availableSlotControllers.add(TextEditingController());
        _priceControllers.add(TextEditingController());
      });
    }
  }

  void _removeTourHighlightRow(int index) {
    setState(() {
      if (_tourHighlights.length > 1) {
        _tourHighlights.removeAt(index);
        _tourHighlightControllers[index].dispose();
        _tourHighlightControllers.removeAt(index);
      }
    });
  }

  void _removeItineraryRow(int index) {
    setState(() {
      if (_itinerary.length > 1) {
        _itinerary.removeAt(index);
        
        _itineraryTitleControllers[index].dispose();
        _itineraryDescriptionControllers[index].dispose();
        _itineraryRemarksControllers[index].dispose();

        _itineraryTitleControllers.removeAt(index);
        _itineraryDescriptionControllers.removeAt(index);
        _itineraryRemarksControllers.removeAt(index);
      }
    });
  }

  void _removeFlightRow(int index) {
    setState(() {
      if (_flight.length > 1) {
        _flight.removeAt(index);
        
        _flightDepartDateControllers[index].dispose();
        _flightReturnDateControllers[index].dispose();
        _flightNameControllers[index].dispose();

        _flightDepartDateControllers.removeAt(index);
        _flightReturnDateControllers.removeAt(index);
        _flightNameControllers.removeAt(index);

        _removeAvailabilityRow(index);
      }
    });
  }

  void _removeAvailabilityRow(int index) {
    setState(() {
      if (_availability.length > 1) {
        _availability.removeAt(index);
        
        _availableDateRangeControllers[index].dispose();
        _availableSlotControllers[index].dispose();
        _priceControllers[index].dispose();

        _availableDateRangeControllers.removeAt(index);
        _availableSlotControllers.removeAt(index);
        _priceControllers.removeAt(index);
      }
    });
  }

  void _updateReturnDatePicker(int index, DateTime firstDate) {
    setState(() {
      // Update the return date picker's firstDate by storing it in a list or directly in the controller
      _flightReturnDateFirstDates[index] = firstDate;
    });
  }

  DateTime _getFirstReturnDate(int index) {
    // Return the first available return date based on the selected depart date or a default date
    return _flightReturnDateFirstDates[index] ?? DateTime.now().add(const Duration(days: 1));
  }

  void _showSelectDepartDateFirstMessage() {
    showSnackBar("Please select the departure date first.", context);
  }

  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateAvailabilityRanges() {
    print("Update availability ranges triggered");

    setState(() {
      for (int i = 0; i < _flightDepartDateControllers.length; i++) {
        print("Processing row $i");

        String? departDate = _flightDepartDateControllers[i].text;
        String? returnDate = _flightReturnDateControllers[i].text;

        print("Depart Date: $departDate");
        print("Return Date: $returnDate");

        if (departDate.isNotEmpty && returnDate.isNotEmpty) {
          print("Updating date range");

          String formattedDateRange = "$departDate - $returnDate";

          if (i < _availableDateRangeControllers.length) {
            _availableDateRangeControllers[i].text = formattedDateRange;
          } else {
            print("Index $i is out of bounds for _availableDateRangeControllers");
          }
        } else {
            print("Index $i is out of bounds for _availableDateRangeControllers");
        }
      }
    });
  }

  void selectImage() async {
    Uint8List? img = await ImageUtils.selectImage(context);
    if (img != null) {
      setState(() {
        _image = img;
        _imageNameController.text = 'Image Selected'; 
      });
    }
  }

  void selectPdfFile() async {
    File? pdfFile = await FileUtils.selectPdf();
    if (pdfFile != null) {
      // await uploadPdfToFirebase(pdfFile);
      setState(() {

        _brochureController.text = pdfFile.path.split('/').last;
      });
    }
  }

  Map<String, dynamic> convertToMap(String category, List<Map<String, String>> listName) {
    switch (category) {
      case "highlight":
        return {
          'tourHighlight': listName.map((entry) {
            return {
              'no': entry['no'],
              'description': entry['description'],
            };
          }).toList(),
        };

      case "itinerary":
        return {
          'itinerary': listName.map((entry) {
            return {
              'day': entry['day'],
              'title': entry['title'],
              'description': entry['description'],
              'remarks': entry['remarks'],
            };
          }).toList(),
        };

      case "flight":
        return {
          'flight_info': listName.map((entry) {
            return {
              'no': entry['no'],
              'departDate': entry['depart'],
              'returnDate': entry['return'],
              'flightName': entry['flight'],
            };
          }).toList(),
        };

      case "availability":
        return {
          'availability': listName.map((entry) {
            return {
              'no': entry['no'],
              'dateRange': entry['date'],
              'slot': entry['slot'],
              'price': entry['price'],
            };
          }).toList(),
        };

      default:
        throw ArgumentError("Unknown category: $category");
    }
  }

  Future<void> _addTour() async {
    setState(() {
      isLoading = true; // Start loading
    });

    final firestore = FirebaseFirestore.instance;

    // Convert list to map
    final tourHighlightData = convertToMap('highlight', _tourHighlights);
    final itineraryData = convertToMap('itinerary', _itinerary);
    final flightData = convertToMap('flight', _flight);
    final availabilityData = convertToMap('availability', _availability);

    try {
      if (_tourNameController.text.isNotEmpty && _travelAgencyController.text.isNotEmpty && _tourHighlights.isNotEmpty &&
      _itinerary.isNotEmpty && _flight.isNotEmpty && _availability.isNotEmpty){
        final usersSnapshot = await firestore.collection('tourPackage').get();
        final tourid = 'TP${(usersSnapshot.docs.length + 1).toString().padLeft(4, '0')}';

        String resp = await StoreData().saveTourPackageData(
          tourid: tourid, 
          tourName: _tourNameController.text, 
          countryName: widget.countryName, 
          cityName: widget.cityName, 
          agency: _travelAgencyController.text, 
          tourHighlightData: tourHighlightData, 
          itineraryData: itineraryData, 
          flightData: flightData, 
          availabilityData: availabilityData, 
          tourCover: _image!, 
          pdfFile: _uploadedPdfFile!
        );

      }

      // Show success dialog
      _showDialog(
        title: 'Successful',
        content: 'You have added the tour package successfully.',
        onPressed: () {
          Navigator.of(context).pop(); // Close the success dialog
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => TravelAgentViewTourListScreen(userId: widget.userId, countryName: widget.countryName, cityName: widget.cityName,))
          );
        },
      );
    } catch (e) {
      // Show error dialog
      _showDialog(
        title: 'Failed',
        content: 'Failed to add tour package: $e',
        onPressed: () {
          Navigator.of(context).pop(); // Close the error dialog
        },
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  // Method to show a dialog with a title and content
  void _showDialog({
    required String title,
    required String content,
    required VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: onPressed,
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // A list to store the first available dates for return date pickers
  List<DateTime?> _flightReturnDateFirstDates = List.filled(10, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Add Tour"),
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
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
                left: 15, right: 15, top: 10, bottom: 30),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tour Information",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  tourName(),
                  const SizedBox(height: 20),
                  travelAgency(),
                  const SizedBox(height: 20),
                  tourHighlightsSection(),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: _addTourHighlightRow,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(20,35),
                        backgroundColor: const Color(0xFF467BA1),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  itinerarySection(),
                  const SizedBox(height: 10), 
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: _addItineraryRow,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(20,35),
                        backgroundColor: const Color(0xFF467BA1),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  flightSection(),
                  const SizedBox(height: 10), 
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: (){
                        _addFlightRow();
                        _addAvailabilityRow();
                      },
                      // _addFlightRow,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(20,35),
                        backgroundColor: const Color(0xFF467BA1),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),   
                  availabilitySection(),
                  const SizedBox(height: 20),   
                  tourImage(),
                  SizedBox(height: 20,),
                  brochure(),
                  SizedBox(height: 20,), 
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: (){_addTour();},
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Add Tour',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF467BA1),
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ) 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tourName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tour Name",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        SizedBox(height: 5,),
        TextField(
          controller: _tourNameController,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: 'Example: 9 DAYS SHANGHAI THEME PARK',
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF467BA1), width: 2.5),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        )
      ],
    );
  }

  Widget travelAgency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Travel Agency",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        SizedBox(height: 5,),
        TextField(
          controller: _travelAgencyController,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF467BA1), width: 2.5),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        )
      ],
    );
  }

  Widget tourHighlightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tour Highlights",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF467BA1), width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(0.4),
              1: FlexColumnWidth(2.7),
              2: FlexColumnWidth(0.4),
            },
            border: TableBorder.all(color: const Color(0xFF467BA1), width: 1.5),
            children: [
              TableRow(
                children: [
                  _buildTableHeaderCell('No'),
                  _buildTableHeaderCell('Description'),
                  _buildTableHeaderCell(''),
                ],
              ),
              for (int i = 0; i < _tourHighlights.length; i++)
                TableRow(
                  children: [
                    _buildTableCell(
                      content: Text(
                        (i + 1).toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      alignment: Alignment.center,
                    ),
                    _buildTextFieldCell(
                      _tourHighlightControllers[i],
                      'Description...',
                    ),
                    _buildDeleteButton(i, "tourHighlight"),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget itinerarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Itinerary",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF467BA1), width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(0.55),
              1: FlexColumnWidth(0.95),
              2: FlexColumnWidth(1.3),
              3: FlexColumnWidth(0.9),
              4: FlexColumnWidth(0.4),
            },
            border: TableBorder.all(color: const Color(0xFF467BA1), width: 1.5),
            children: [
              TableRow(
                children: [
                  _buildTableHeaderCell('Day'),
                  _buildTableHeaderCell('Title'),
                  _buildTableHeaderCell('Description'),
                  _buildTableHeaderCell('Remarks'),
                  _buildTableHeaderCell(''),
                ],
              ),
              for (int i = 0; i < _itinerary.length; i++)
                TableRow(
                  children: [
                    _buildTableCell(
                      content: Text(
                        (i + 1).toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      alignment: Alignment.center,
                    ),
                    _buildTextFieldCell(_itineraryTitleControllers[i], 'Title...'),
                    _buildTextFieldCell(_itineraryDescriptionControllers[i], 'Description...'),
                    _buildTextFieldCell(_itineraryRemarksControllers[i], 'Remarks...'),
                    _buildDeleteButton(i, "itinerary"),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget flightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Flight Info",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF467BA1), width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(0.4),
              1: FlexColumnWidth(1.0),
              2: FlexColumnWidth(1.0),
              3: FlexColumnWidth(1.25),
              4: FlexColumnWidth(0.4),
            },
            border: TableBorder.all(color: const Color(0xFF467BA1), width: 1.5),
            children: [
              TableRow(
                children: [
                  _buildTableHeaderCell("No"),
                  _buildTableHeaderCell("Depart"),
                  _buildTableHeaderCell("Return"),
                  _buildTableHeaderCell("Flight"),
                  _buildTableHeaderCell(""),
                ],
              ),
              for (int i = 0; i < _flight.length; i++)
                TableRow(
                  children: [
                    _buildTableCell(
                      content: Text(
                        (i + 1).toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      alignment: Alignment.center,
                    ),
                    _buildDatePickerTextFieldCell(
                      _flightDepartDateControllers[i],
                      'Pick a date',
                      onDateSelected: (DateTime selectedDate) {
                        // Update the return date controller's first date
                        DateTime firstReturnDate = selectedDate.add(const Duration(days: 1));
                        _updateReturnDatePicker(i, firstReturnDate);
                      },
                    ),
                    _buildDatePickerTextFieldCell(
                      _flightReturnDateControllers[i],
                      'Pick a date',
                      firstDate: _getFirstReturnDate(i),
                      isReturnDate: true,
                      departDateSelected: _flightDepartDateControllers[i].text.isNotEmpty,
                    ),
                    _buildTextFieldCell(_flightNameControllers[i], 'Flight name...'),
                    _buildDeleteButton(i, "flight"),                
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget availabilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Availability",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF467BA1), width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(0.4),
              1: FlexColumnWidth(1.3),
              2: FlexColumnWidth(0.5),
              3: FlexColumnWidth(1.0),
              // 4: FlexColumnWidth(0.4),
            },
            border: TableBorder.all(color: const Color(0xFF467BA1), width: 1.5),
            children: [
              TableRow(
                children: [
                  _buildTableHeaderCell("No"),
                  _buildTableHeaderCell("Date Range"),
                  _buildTableHeaderCell("Slot"),
                  _buildTableHeaderCell("Price"),
                  // _buildTableHeaderCell(""),
                ],
              ),
              for (int i = 0; i < _availability.length; i++)
                TableRow(
                  children: [
                    _buildTableCell(
                      content: Text(
                        (i + 1).toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      alignment: Alignment.center,
                    ),
                    _buildDateRangeTextFieldCell(_availableDateRangeControllers[i], 'Date range'),
                    _buildTextFieldCell(_availableSlotControllers[i], 'Slot'),
                    _buildTextFieldCell(_priceControllers[i], '', isPriceField: true),
                    // _buildDeleteButton(i, "availability"),                                            
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tourImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tour Package Cover",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        SizedBox(height: 5,),
        TextField(
          controller: _imageNameController,
          readOnly: true,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Upload an image...',
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.image,
                color: Color(0xFF467BA1),
                size: 30,
              ),
              onPressed: () {
                selectImage();
              }
            ),
          ),
        )
      ],
    );
  }

  Widget brochure() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Brochure",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        SizedBox(height: 5,),
        TextField(
          controller: _brochureController,
          readOnly: true,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Upload a PDF file...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.picture_as_pdf,
                color: Color(0xFF467BA1),
                size: 30,
              ),
              onPressed: () {
                selectPdfFile();
              }
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTableHeaderCell(String label) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: const Color(0xFF467BA1).withOpacity(0.6),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell({required Widget content, Alignment alignment = Alignment.centerLeft}) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Color(0xFF467BA1), width: 1.0),
        ),
      ),
      alignment: alignment,
      child: content,
    );
  }

  Widget _buildTextFieldCell(TextEditingController controller, String hintText, {bool isPriceField = false}) {

    if (isPriceField == true){
      return Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
          ),
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            prefixText: "RM",
            prefixStyle: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w900
            ),
            suffixText: ".00",
            suffixStyle: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w900
            )
          ),
          maxLines: 1, 
          textAlign: TextAlign.end,
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
          ),
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800
            )
          ),
          maxLines: null, // Allows multiline input
        ),
      );
    }
  }

  Widget _buildDateRangeTextFieldCell(TextEditingController controller, String hintText) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
        ),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800
          )
        ),
        maxLines: null, // Allows multiline input
        readOnly: true,
      ),
    );
  }

  Widget _buildDatePickerTextFieldCell(
      TextEditingController controller, 
      String hintText, 
      {DateTime? firstDate, 
      void Function(DateTime)? onDateSelected, 
      bool isReturnDate = false, 
      bool departDateSelected = true}) {

    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
        ),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800
          )
        ),
        readOnly: true, // Prevents keyboard from appearing
        textAlign: TextAlign.center,
        onTap: () async {
          if (isReturnDate && !departDateSelected) {
            // Show a message asking the user to select the departure date first
            _showSelectDepartDateFirstMessage();
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

          if (isReturnDate && departDateSelected) {
            setState(() {
              _updateAvailabilityRanges();
            });
          }
        },
      ),
    );
  }


  Widget _buildDeleteButton(int index, String rowType) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
        ),
      ),
      child: Center(
        child: IconButton(
          icon: const Icon(Icons.delete_rounded),
          color: Colors.black54,
          iconSize: 22,
          onPressed: () {
            if (index == 0 && _getRowCount(rowType) == 1){
              _clearFirstRow(rowType);
            } else{
              if (rowType == 'itinerary') {
                _removeItineraryRow(index);
              } else if (rowType == 'tourHighlight') {
                _removeTourHighlightRow(index);
              } else if (rowType == 'flight') {
                _removeFlightRow(index);
              } else if (rowType == 'availability') {
                _removeAvailabilityRow(index);
              }
            }
          },
        ),
      ),
    );
  }

  // Method to get the row count for the given row type
  int _getRowCount(String rowType) {
    if (rowType == 'itinerary') {
      return _itinerary.length;
    } else if (rowType == 'tourHighlight') {
      return _tourHighlights.length;
    } else if (rowType == 'flight') {
      return _flight.length;
    } else if (rowType == 'availability') {
      return _availability.length;
    }
    return 0;
  }

  // Method to clear the text in the first row
  void _clearFirstRow(String rowType) {
    if (rowType == 'itinerary') {
      _itineraryTitleControllers[0].clear();
      _itineraryDescriptionControllers[0].clear();
      _itineraryRemarksControllers[0].clear();
    } else if (rowType == 'tourHighlight') {
      _tourHighlightControllers[0].clear();
    } else if (rowType == 'flight') {
      _flightDepartDateControllers[0].clear();
      _flightReturnDateControllers[0].clear();
      _flightNameControllers[0].clear();
      _updateAvailabilityRanges();
    } else if (rowType == 'availability') {
      _availableDateRangeControllers[0].clear();
      _availableSlotControllers[0].clear();
      _priceControllers[0].clear();
    }
  }

}
