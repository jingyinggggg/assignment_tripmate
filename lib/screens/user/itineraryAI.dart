import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/geminiAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AIItineraryScreen extends StatefulWidget {
  final String userId;
  const AIItineraryScreen({super.key, required this.userId});

  @override
  State<AIItineraryScreen> createState() => _AIItineraryScreenState();
}

class _AIItineraryScreenState extends State<AIItineraryScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form fields
  DateTime? _departureDate;
  DateTime? _returnDate;
  final TextEditingController _departureDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  String? _selectedTravelStyle;

  String? generatedItinerary;
  bool isGenerating = false;
  final geminiApi = GeminiApi();

  // Error message for date validation
  String _dateError = "";

  // Questions and input types
  final List<String> questions = [
    "Select your departure and return dates:",
    "Enter the country you want to visit:",
    "Enter your budget:",
    "Select your travel style:"
  ];

  // Travel styles for the dropdown
  final List<String> travelStyles = ["Adventure", "Relaxation", "Cultural", "Romantic", "Family", "Luxury"];

  Future<void>submitUserPreference() async{
    if(_departureDateController.text.isNotEmpty && _returnDateController.text.isNotEmpty && _countryController.text.isNotEmpty && _budgetController.text.isNotEmpty && _selectedTravelStyle != ''){
      setState(() {
        isGenerating = true;
      });

      try{
        final generatingResult = await geminiApi.generateItinerary(_departureDateController.text, _returnDateController.text, _countryController.text, _budgetController.text, _selectedTravelStyle!);

        setState(() {
          generatedItinerary = generatingResult;
          isGenerating = false;
        });
      }catch(e){
        setState(() {
          generatedItinerary = "Error: ${e.toString()}";
          isGenerating = false;
        });
      }
    }
  }

  Future<void> saveItinerary() async {
    String itineraryTitle = '';

    // Show a dialog to enter the itinerary title
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Itinerary Title"),
          content: TextField(
            onChanged: (value) {
              itineraryTitle = value;
            },
            decoration: const InputDecoration(hintText: "Title"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (itineraryTitle.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the dialog and proceed
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );

    // If the user provided a title, save the itinerary to Firebase
    if (itineraryTitle.isNotEmpty && generatedItinerary != null) {
      // Save to Firebase
      await FirebaseFirestore.instance.collection('itineraries').add({
        'title': itineraryTitle,
        'content': generatedItinerary!,
        'userId': widget.userId,
        'isDelete': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Itinerary '$itineraryTitle' saved successfully!")),
      );
    }
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: const Text("Please make sure you have save the itineray. It will be removed once exit."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context); // Exit the current screen
              },
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("AI Itinerary"),
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            _showExitConfirmationDialog(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              isGenerating
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: primaryColor,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Generating Itinerary ...',
                            style: TextStyle(
                              fontSize: defaultLabelFontSize,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : generatedItinerary != null
                      ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Generated Itinerary:",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.left,
                            ),
                            const Divider(),
                            const SizedBox(height: 10),
                            Text(
                              generatedItinerary!, 
                              style: const TextStyle(fontSize: defaultLabelFontSize),
                              textAlign: TextAlign.justify,
                            ),
                            const Divider(),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle saving the itinerary here
                                  saveItinerary();
                                },
                                child: const Text(
                                  "Save Itinerary",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            // This part handles the questions
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6, // Adjust the height as needed
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: questions.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          "Question ${index + 1} / ${questions.length}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        Text(
                                          questions[index],
                                          style: TextStyle(
                                            fontSize: defaultLabelFontSize,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                        const SizedBox(height: 15),
                                        getInputForQuestion(index),
                                        if (_dateError.isNotEmpty) ...[
                                          const SizedBox(height: 10),
                                          Text(_dateError, style: TextStyle(color: Colors.red)),
                                        ],
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Back Button
                                if (_currentPage > 0) ...[
                                  ElevatedButton(
                                    onPressed: () {
                                      _pageController.previousPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: const Text(
                                      "Back",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(90, 45),
                                      backgroundColor: const Color(0xFF467BA1),
                                      textStyle: const TextStyle(
                                        fontSize: defaultLabelFontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                                SizedBox(width: 20),
                                if (_currentPage < questions.length - 1) ...[
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_currentPage == 0) {
                                        if (_validateDates()) {
                                          _pageController.nextPage(
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      } else {
                                        _pageController.nextPage(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    },
                                    child: const Text(
                                      "Next",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(90, 45),
                                      backgroundColor: const Color(0xFF467BA1),
                                      textStyle: const TextStyle(
                                        fontSize: defaultLabelFontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ] 
                                else ...[ // Check if it's the last question
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle submission here
                                      submitUserPreference(); // Implement this method to process the answers
                                    },
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(90, 45),
                                      backgroundColor: const Color(0xFF467BA1),
                                      textStyle: const TextStyle(
                                        fontSize: defaultLabelFontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  )
                                ],
                              ],
                            )
                            
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to display input fields based on the current question
  Widget getInputForQuestion(int index) {
    switch (index) {
      case 0: // Departure and Return Dates
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDatePickerTextFieldCell(
              _departureDateController,
              'Departure Date',
              'Pick a departure date',
              onDateSelected: (DateTime selectedDate) {
                setState(() {
                  _departureDate = selectedDate;
                  _dateError = ""; // Reset error message
                });
                // Update the return date controller's first date
                DateTime firstReturnDate = selectedDate.add(const Duration(days: 1));
                _updateReturnDatePicker(firstReturnDate);
              },
            ),
            SizedBox(height: 20),
            _buildDatePickerTextFieldCell(
              _returnDateController,
              'Return Date',
              'Pick a return date',
              firstDate: _getFirstReturnDate(),
              isReturnDate: true,
              departDateSelected: _departureDateController.text.isNotEmpty,
              onDateSelected: (DateTime selectedDate) {
                setState(() {
                  _returnDate = selectedDate;
                  _dateError = ""; // Reset error message
                });
              },
            ),
          ],
        );
      case 1: // Country
        return country();
      case 2: // Budget
        return budget();
      case 3: // Travel Style
        return travel(
          travelStyles, 
          "Select a travel style", "Travel Style", 
          _selectedTravelStyle, 
          (newValue){
            setState(() {
              _selectedTravelStyle = newValue;
            });
        });
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDatePickerTextFieldCell(
    TextEditingController controller,
    String labeltext,
    String hintText, {
    DateTime? firstDate,
    void Function(DateTime)? onDateSelected,
    bool isReturnDate = false,
    bool departDateSelected = true,
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
            },
          ),
        ),
      ),

    );
  }

  void _updateReturnDatePicker(DateTime firstDate) {
    setState(() {
      // Reset the return date controller
      _returnDateController.clear();
      _returnDateController.text = ""; // Resetting the text field
    });
  }

  DateTime _getFirstReturnDate() {
    // Return the first available return date based on the selected depart date or a default date
    return _departureDate?.add(const Duration(days: 1)) ?? DateTime.now().add(const Duration(days: 1));
  }

  bool _validateDates() {
    if (_departureDate == null || _returnDate == null) {
      setState(() {
        _dateError = "Please select both departure and return dates.";
      });
      return false;
    }
    if (_departureDate!.isAfter(_returnDate!)) {
      setState(() {
        _dateError = "Departure date must be before return date.";
      });
      return false;
    }
    return true;
  }

  void _showSelectDepartDateFirstMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Departure Date First"),
        content: const Text("Please select the departure date before choosing the return date."),
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

  Widget country() {
    return TextField(
      controller: _countryController,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: defaultFontSize,
      ),
      decoration: InputDecoration(
        hintText: 'Enter Country',
        labelText: 'Country',
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
    );
  }

  Widget budget() {
    return TextField(
      controller: _budgetController,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: defaultFontSize,
      ),
      decoration: InputDecoration(
        hintText: 'Enter your budget with current unit',
        labelText: 'Budget',
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
    );
  }

  Widget travel(
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
