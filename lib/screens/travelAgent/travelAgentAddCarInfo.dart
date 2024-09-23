import 'dart:typed_data';

import 'package:assignment_tripmate/autocomplete_predictions.dart';
import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/network_utility.dart';
import 'package:assignment_tripmate/place_auto_complete_response.dart';
import 'package:assignment_tripmate/saveImageToFirebase.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentViewCarInfo.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TravelAgentAddCarInfoScreen extends StatefulWidget {
  final String userId;

  const TravelAgentAddCarInfoScreen({
    super.key,
    required this.userId,
  });

  @override
  State<StatefulWidget> createState() => _TravelAgentAddCarInfoScreenState();
}

class _TravelAgentAddCarInfoScreenState extends State<TravelAgentAddCarInfoScreen>{
  List<String> _carType = ['SUV', 'Sedan', 'MPV', 'Hatchback'];
  List<String> _transmissionType = ['Auto', 'Manual'];
  List<String> _fuelType = ['Petrol', 'Electricity', 'Hybrid'];

  String? selectedCarType;
  String? selectedTransmission;
  String? selectedFuel;
  String? selectedStatus;

  TextEditingController _carNameController = TextEditingController();
  TextEditingController _seatController = TextEditingController();
  TextEditingController _carImageController = TextEditingController();
  TextEditingController _pickUpLocationController = TextEditingController();
  TextEditingController _dropOffLocationController = TextEditingController();
  TextEditingController _pricingController = TextEditingController();
  TextEditingController _rentalPolicyController = TextEditingController();
  TextEditingController _insuransCoverageController = TextEditingController();
  TextEditingController _carConditionController = TextEditingController();

  Uint8List? _carImage;

  List<AutoCompletePredictions> placedPredictions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> selectImage() async {
    Uint8List? img = await ImageUtils.selectImage(context);
    if (img != null) {
      setState(() {
        _carImage = img;
        _carImageController.text = 'Image Selected'; 
      });
    }
  }

  void placeAutoComplete(String query) async{
    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/autocomplete/json", /// unencoder path
      {
        "input": query,
        "key": apiKey,
      }
    );

    // Make GET request
    String? response = await NetworkUtility.fetchUrl(uri);

    if(response != null){
      PlaceAutoCompleteResponse result = PlaceAutoCompleteResponse.parseAutoCompleteResult(response);

      if(result.predictions != null){
        setState(() {
          placedPredictions = result.predictions!;    
        });
        
      }
    } 
  }

  // Add car details to database
  Future<void> _addCar() async {
    setState(() {
      isLoading = true;
    });

    final firestore = FirebaseFirestore.instance;

    try {
      // Check for empty fields and provide feedback
      if (_carNameController.text.isEmpty || selectedCarType == null || selectedTransmission == null || 
          _seatController.text.isEmpty || selectedFuel == null || _carImage == null || 
          _pickUpLocationController.text.isEmpty || _dropOffLocationController.text.isEmpty || 
          _pricingController.text.isEmpty || _insuransCoverageController.text.isEmpty || 
          _carConditionController.text.isEmpty || _rentalPolicyController.text.isEmpty) {
        
        setState(() {
          isLoading = false;
        });

        print("Car Name: ${_carNameController.text}");
        print("Car Type: $selectedCarType");
        print("Transmission: $selectedTransmission");
        print("Seats: ${_seatController.text}");
        print("Fuel: $selectedFuel");
        print("Car Image: $_carImage");
        print("Pick Up Location: ${_pickUpLocationController.text}");
        print("Drop Off Location: ${_dropOffLocationController.text}");
        print("Pricing: ${_pricingController.text}");
        print("Insurance: ${_insuransCoverageController.text}");
        print("Car Condition: ${_carConditionController.text}");
        print("Rental Policy: ${_rentalPolicyController.text}");

        showCustomDialog(
          context: context, 
          title: 'Incomplete Information', 
          content: 'Please fill in all the fields before submitting.',
          onPressed: () {
            Navigator.of(context).pop();
          }
        );

        return; // Exit early
      }

      // Generate car ID and save data
      final snapshot = await firestore.collection('car_rental').get();
      final carID = 'CAR${(snapshot.docs.length + 1).toString().padLeft(4, '0')}';

      String resp = await StoreData().saveCarRentalData(
        carID: carID, 
        carModel: _carNameController.text, 
        carType: selectedCarType!, 
        transmission: selectedTransmission!, 
        seat: int.tryParse(_seatController.text) ?? 0, 
        fuel: selectedFuel!, 
        carImage: _carImage!, 
        pickUpLocation: _pickUpLocationController.text, 
        dropOffLocation: _dropOffLocationController.text, 
        price: double.tryParse(_pricingController.text) ?? 0.0, 
        insurance: _insuransCoverageController.text, 
        carCondition: _carConditionController.text, 
        rentalPolicy: _rentalPolicyController.text, 
        agencyID: widget.userId
      );

      // After successfully saving
      setState(() {
        isLoading = false;
      });

      showCustomDialog(
        context: context, 
        title: 'Successful', 
        content: 'You have added the car details successfully.', 
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => TravelAgentViewCarListingScreen(userId: widget.userId)
            )
          );
        }
      );

    } catch (e) {
      print('Error: $e'); // For debugging
      setState(() {
        isLoading = false;
      });

      showCustomDialog(
        context: context, 
        title: 'Failed', 
        content: 'Something went wrong: $e.', 
        onPressed: () {
          Navigator.of(context).pop();
        }
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Car Rental"),
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TravelAgentViewCarListingScreen(userId: widget.userId))
            );
          },
        ),
      ),
      body:Stack(
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
                    "Car Information",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20,),
                  buildTextField(_carNameController, 'Enter car model', 'Car Model'),
                  SizedBox(height: 20,),
                  buildDropDownList(
                    _carType, 
                    'Select category of car', 
                    'Car Type', 
                    selectedCarType, 
                    (newValue){
                      setState(() {
                        selectedCarType = newValue;
                      });
                    }
                  ),
                  // SizedBox(height: 20,),
                  // buildDropDownList(_carBrand, 'Select brand of car', 'Car Brand', selectedBrand),
                  SizedBox(height: 20,),
                  buildDropDownList(
                    _transmissionType, 
                    'Select type of transmission', 
                    'Transmission', 
                    selectedTransmission,
                    (newValue){
                      setState(() {
                        selectedTransmission = newValue;
                      });
                    }
                  ),
                  SizedBox(height: 20,),
                  buildTextField(_seatController, 'Enter number of seats', 'Number of Seats', isIntField: true),
                  SizedBox(height: 20,),
                  buildDropDownList(
                    _fuelType, 
                    'Select type of fuel', 
                    'Fuel Type', 
                    selectedFuel,
                    (newValue){
                      setState(() {
                        selectedFuel = newValue;
                      });
                    }
                  ),
                  SizedBox(height: 20,),
                  carImage(),
                  SizedBox(height: 30,), 

                  const Text(
                    "Location",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          placeAutoComplete(value);
                        },
                        controller: _pickUpLocationController,
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: defaultFontSize,
                          overflow: TextOverflow.visible,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search pick up location of car...",
                          labelText: "Pick Up Location",
                          prefixIcon: Icon(
                            Icons.location_on,
                            size: 25,
                            color: primaryColor,
                          ),
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
                        maxLines: null,
                      ),
                      SizedBox(height: 10,),
                      if (placedPredictions.isNotEmpty) 
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF467BA1), width: 2.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: List.generate(placedPredictions.length, (index) {
                              return ListTile(
                                title: Text(placedPredictions[index].description!),
                                onTap: () {
                                  // Handle selection
                                  _pickUpLocationController.text = placedPredictions[index].description!;
                                  setState(() {
                                    placedPredictions.clear(); // Clear predictions after selection
                                  });
                                },
                              );
                            }),
                          ),
                        ),
                    ]
                  ),
                  SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          placeAutoComplete(value);
                        },
                        controller: _dropOffLocationController,
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: defaultFontSize,
                          overflow: TextOverflow.visible,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search drop off location of car...",
                          labelText: "Drop Off Location",
                          prefixIcon: Icon(
                            Icons.location_on,
                            size: 25,
                            color: primaryColor,
                          ),
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
                        maxLines: null,
                      ),
                      SizedBox(height: 10,),
                      if (placedPredictions.isNotEmpty) 
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF467BA1), width: 2.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: List.generate(placedPredictions.length, (index) {
                              return ListTile(
                                title: Text(placedPredictions[index].description!),
                                onTap: () {
                                  // Handle selection
                                  _dropOffLocationController.text = placedPredictions[index].description!;
                                  setState(() {
                                    placedPredictions.clear(); // Clear predictions after selection
                                  });
                                },
                              );
                            }),
                          ),
                        ),
                    ]
                  ),
                  SizedBox(height: 30,), 

                  const Text(
                    "Pricing Information",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20,),
                  buildTextField(_pricingController, 'Enter price', 'Price (RM/per day)', isIntField: true),
                  // SizedBox(height: 20,),
                  // buildTextField(_discountController, 'Enter discount price', 'Discount Price (RM/per day)', isIntField: true),
                  SizedBox(height: 30,), 

                  const Text(
                    "Insurance",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20,),
                  buildTextField(_insuransCoverageController, 'Specify available insurance coverage or add-ons', 'Insurance Coverage'),
                  SizedBox(height: 30,), 

                  const Text(
                    "Car Condition",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: defaultLabelFontSize,
                    ),
                  ),
                  SizedBox(height: 20,),
                  buildTextField(_carConditionController, "Describe the car's condition or any recent maintenance", 'Car Condition'),
                  SizedBox(height: 30,), 

                  const Text(
                    "Rental Policy",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: defaultLabelFontSize,
                    ),
                  ),
                  SizedBox(height: 20,),
                  buildTextField(_rentalPolicyController, "State the rental policy clearly", 'Rental Policy'),
                  SizedBox(height: 30,), 

                  Container(
                    width: double.infinity,
                    height: getScreenHeight(context) * 0.08,
                    child: ElevatedButton(
                      onPressed: (){_addCar();},
                      child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF467BA1),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ) 
                ]
              )
            )
          )
        ],
      )
    );
  }

  Widget buildTextField(TextEditingController controller,String hintText, String label, {bool isIntField = false}){
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: defaultFontSize,
        overflow: TextOverflow.visible
      ),
      maxLines: null,
      textAlign: TextAlign.justify,
      keyboardType: isIntField ? TextInputType.number : TextInputType.multiline,
      decoration: InputDecoration(
        hintText: hintText,
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



  Widget carImage() {
    return TextField(
      controller: _carImageController,
      readOnly: true,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 15,
        color: Colors.black54
      ),
      decoration: InputDecoration(
        hintText: 'Please upload the image of car...',
        labelText: 'Car Image',
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
          fontSize: 16,
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
            Icons.image,
            color: Color(0xFF467BA1),
            size: 25,
          ),
          onPressed: () {
            selectImage();
          }
        ),
      ),
    );
  }

}