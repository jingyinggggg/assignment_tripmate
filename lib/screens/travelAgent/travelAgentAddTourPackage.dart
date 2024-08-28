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
  bool isLoading = false;

  final List<Map<String, String>> _tourHighlights = [
    {'no': '', 'description': ''},
  ];

  final List<Map<String, String>> _itinerary = [
    {'day': '', 'title': '', 'description': '', 'remarks': ''},
  ];

  final List<Map<String, String>> _flight = [
    {'no': '', 'depart': '', 'return': '', 'flight': ''},
  ];

  final List<Map<String, String>> _avalability = [
    {'no': '', 'date': '', 'slot': '', 'price': ''},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tourNameController.dispose();
    _travelAgencyController.dispose();
    super.dispose();
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
                  avalabilitySection(),
                  const SizedBox(height: 10), 
                  Align(
                    alignment: Alignment.topRight,
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
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              for (int i = 0; i < _tourHighlights.length; i++)
                TableRow(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          right: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          (i + 1).toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: TextField(
                        controller: TextEditingController(
                          text: _tourHighlights[i]['description'],
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Description...',
                        ),
                        maxLines: null, // Allows multiline input
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.delete_rounded), 
                          color: Colors.black54,
                          iconSize: 22,
                          onPressed: (){},
                        )
                      ),
                    ), 
                    // if (i > 0)
                    //   Container(
                    //     decoration: const BoxDecoration(
                    //       color: Colors.white,
                    //       border: Border(
                    //         right: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                    //       ),
                    //     ),
                    //     child: Center(
                    //       child: IconButton(
                    //         icon: const Icon(Icons.delete_rounded),
                    //         color: Colors.black54,
                    //         iconSize: 22,
                    //         onPressed: () => _removeTourHighlightRow(i),
                    //       ),
                    //     ),
                    //   ),
                    // else
                    //   Container(
                    //     decoration: const BoxDecoration(
                    //       color: Colors.white,
                    //     ),
                    //     child: Center(
                    //       child: const SizedBox(width: 22),
                    //     ),
                    //   ),
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
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'Day',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'Remarks',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              for (int i = 0; i < _itinerary.length; i++)
                TableRow(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          right: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          (i + 1).toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: TextField(
                        controller: TextEditingController(
                          text: _itinerary[i]['title'],
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title...',
                        ),
                        maxLines: null, // Allows multiline input
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: TextField(
                        controller: TextEditingController(
                          text: _itinerary[i]['desciption'],
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Description...',
                        ),
                        maxLines: null, // Allows multiline input
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: TextField(
                        controller: TextEditingController(
                          text: _itinerary[i]['remarks'],
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Remarks...',
                        ),
                        maxLines: null, // Allows multiline input
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.delete_rounded), 
                          color: Colors.black54,
                          iconSize: 22,
                          onPressed: (){},
                        )
                      ),
                    ),                       
                    // if (i > 0)
                    //   Container(
                    //     decoration: const BoxDecoration(
                    //       color: Colors.white,
                    //       border: Border(
                    //         right: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                    //       ),
                    //     ),
                    //     child: Center(
                    //       child: IconButton(
                    //         icon: const Icon(Icons.delete_rounded),
                    //         color: Colors.black54,
                    //         iconSize: 22,
                    //         onPressed: () => _removeTourHighlightRow(i),
                    //       ),
                    //     ),
                    //   ),
                    // else
                    //   Container(
                    //     decoration: const BoxDecoration(
                    //       color: Colors.white,
                    //     ),
                    //     child: Center(
                    //       child: const SizedBox(width: 22),
                    //     ),
                    //   ),
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
              1: FlexColumnWidth(1.3),
              2: FlexColumnWidth(1.3),
              3: FlexColumnWidth(0.7),
              4: FlexColumnWidth(0.4),
            },
            border: TableBorder.all(color: const Color(0xFF467BA1), width: 1.5),
            children: [
              TableRow(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'Depart',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'Return',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'Flight',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              for (int i = 0; i < _flight.length; i++)
                TableRow(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          right: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          (i + 1).toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: TextField(
                        controller: TextEditingController(
                          text: _flight[i]['depart'],
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'date picker',
                        ),
                        maxLines: null, // Allows multiline input
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: TextField(
                        controller: TextEditingController(
                          text: _flight[i]['return'],
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'date picker',
                        ),
                        maxLines: null, // Allows multiline input
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: TextField(
                        controller: TextEditingController(
                          text: _flight[i]['flight'],
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Flight Name',
                        ),
                        maxLines: null, // Allows multiline input
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.delete_rounded), 
                          color: Colors.black54,
                          iconSize: 22,
                          onPressed: (){},
                        )
                      ),
                    ),                       
                    // if (i > 0)
                    //   Container(
                    //     decoration: const BoxDecoration(
                    //       color: Colors.white,
                    //       border: Border(
                    //         right: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                    //       ),
                    //     ),
                    //     child: Center(
                    //       child: IconButton(
                    //         icon: const Icon(Icons.delete_rounded),
                    //         color: Colors.black54,
                    //         iconSize: 22,
                    //         onPressed: () => _removeTourHighlightRow(i),
                    //       ),
                    //     ),
                    //   ),
                    // else
                    //   Container(
                    //     decoration: const BoxDecoration(
                    //       color: Colors.white,
                    //     ),
                    //     child: Center(
                    //       child: const SizedBox(width: 22),
                    //     ),
                    //   ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget avalabilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Avalability",
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
              2: FlexColumnWidth(0.5),
              3: FlexColumnWidth(1.0),
              4: FlexColumnWidth(0.4),
            },
            border: TableBorder.all(color: const Color(0xFF467BA1), width: 1.5),
            children: [
              TableRow(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'Slot',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        'Price(RM)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFF467BA1).withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              for (int i = 0; i < _avalability.length; i++)
                TableRow(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          right: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          (i + 1).toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: TextField(
                        controller: TextEditingController(
                          text: _avalability[i]['date'],
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'show flight date',
                        ),
                        maxLines: null, // Allows multiline input
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: TextField(
                        controller: TextEditingController(
                          text: _avalability[i]['slot'],
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'date picker',
                        ),
                        maxLines: null, // Allows multiline input
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: TextField(
                        controller: TextEditingController(
                          text: _avalability[i]['price'],
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '',
                          prefixText: "RM",
                        ),
                        maxLines: null, // Allows multiline input
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFF467BA1), width: 1.0),
                        ),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.delete_rounded), 
                          color: Colors.black54,
                          iconSize: 22,
                          onPressed: (){},
                        )
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

  void _addTourHighlightRow() {
    if (_tourHighlights.last['description']!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in the description before adding another row."),
        ),
      );
    } else {
      setState(() {
        _tourHighlights.add({'no': '', 'description': ''});
      });
    }
  }

  void _removeTourHighlightRow(int index) {
    setState(() {
      _tourHighlights.removeAt(index);
      for (int i = 0; i < _tourHighlights.length; i++) {
        _tourHighlights[i]['no'] = (i + 1).toString();
      }
    });
  }
}
