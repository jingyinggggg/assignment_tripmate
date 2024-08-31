import 'package:flutter/material.dart';

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
  }

  @override
  void dispose() {
    // Dispose tour name and travel agency controllers
    _tourNameController.dispose();
    _travelAgencyController.dispose();
    
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


  void _addTourHighlightRow() {
    setState(() {
      _tourHighlights.add({'no': '', 'description': ''});
      _tourHighlightControllers.add(TextEditingController());
    });
  }

  void _addItineraryRow() {
    setState(() {
      _itinerary.add({'day': '', 'title': '', 'description': '', 'remarks': ''});
      _itineraryTitleControllers.add(TextEditingController());
      _itineraryDescriptionControllers.add(TextEditingController());
      _itineraryRemarksControllers.add(TextEditingController());
    });
  }

  void _addFlightRow() {
    setState(() {
      _flight.add({'no': '', 'depart': '', 'return': '', 'flight': ''});
      _flightDepartDateControllers.add(TextEditingController());
      _flightReturnDateControllers.add(TextEditingController());
      _flightNameControllers.add(TextEditingController());
    });
  }

  void _addAvailabilityRow() {
    setState(() {
      _availability.add({'no': '', 'date': '', 'slot': '', 'price': ''});
      _availableDateRangeControllers.add(TextEditingController());
      _availableSlotControllers.add(TextEditingController());
      _priceControllers.add(TextEditingController());
    });
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
                  const SizedBox(height: 10),
                  travelAgency(),
                  const SizedBox(height: 10),
                  tourHighlightsSection(),
                  const SizedBox(height: 10),
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
                      onPressed: _addFlightRow,
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
                  const SizedBox(height: 10), 
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: _addAvailabilityRow,
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
                  tourImage(),
                  SizedBox(height: 10,),
                  brochure(),
                  SizedBox(height: 20,), 
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: (){},
                      // onPressed: _addTourHighlightRow,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Add',
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
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'Example: 9 DAYS SHANGHAI THEME PARK',
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
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
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
                    _buildTextFieldCell(_flightDepartDateControllers[i], 'Date picker'),
                    _buildTextFieldCell(_flightReturnDateControllers[i], 'Date picker'),
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
              1: FlexColumnWidth(1.1),
              2: FlexColumnWidth(0.6),
              3: FlexColumnWidth(0.8),
              4: FlexColumnWidth(0.4),
            },
            border: TableBorder.all(color: const Color(0xFF467BA1), width: 1.5),
            children: [
              TableRow(
                children: [
                  _buildTableHeaderCell("No"),
                  _buildTableHeaderCell("Date Range"),
                  _buildTableHeaderCell("Slot"),
                  _buildTableHeaderCell("Price"),
                  _buildTableHeaderCell(""),
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
                    _buildTextFieldCell(_availableDateRangeControllers[i], 'Date range'),
                    _buildTextFieldCell(_availableSlotControllers[i], 'Slot'),
                    _buildTextFieldCell(_priceControllers[i], 'price'),
                    _buildDeleteButton(i, "availability"),                                            
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
        const Text("Tour Profile",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        SizedBox(height: 5,),
        TextField(
          // controller: _imageNameController,
          readOnly: true,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Upload an image...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(10),
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
                // selectImage();
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
          // controller: _imageNameController,
          readOnly: true,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Upload a pdf file...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF467BA1),
                width: 2.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(10),
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
                // selectImage();
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

  Widget _buildTextFieldCell(TextEditingController controller, String hintText) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
        ),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
        maxLines: null, // Allows multiline input
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
            if (rowType == 'itinerary') {
              _removeItineraryRow(index);
            } else if (rowType == 'tourHighlight') {
              _removeTourHighlightRow(index);
            } else if (rowType == 'flight') {
              _removeFlightRow(index);
            } else if (rowType == 'availability'){
              _removeAvailabilityRow(index);
            }
          },
        ),
      ),
    );
  }


}
