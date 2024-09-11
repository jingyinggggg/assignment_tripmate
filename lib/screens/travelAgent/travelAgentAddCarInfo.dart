import 'dart:typed_data';

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
  List<String> _carBrand = [];
  List<String> _carType = ['SUV', 'Sedan'];
  List<String> _transmissionType = ['Auto', 'Manual'];
  List<String> _fuelType = ['Petrol', 'Electricity', 'Hybrid'];
  List<String> _availabilityStatus = ['Available', 'Maintenance', 'Reserved'];

  String? selectedBrand;
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
  TextEditingController _discountController = TextEditingController();
  TextEditingController _rentalPolicyController = TextEditingController();
  TextEditingController _insuransCoverageController = TextEditingController();
  TextEditingController _carConditionController = TextEditingController();
  TextEditingController _contactController = TextEditingController();

  Uint8List? _carImage;

  @override
  void initState() {
    super.initState();
    fetchCarBrands();
  }

  Future<void> fetchCarBrands() async {
    try {
      CollectionReference brandsRef = FirebaseFirestore.instance.collection('carBrand');
      QuerySnapshot querySnapshot = await brandsRef.get();
      
      setState(() {
        _carBrand = querySnapshot.docs.map((doc) => doc['carBrandName'] as String).toList();
      });
    } catch (e) {
      print('Error fetching car brands: $e');
    }
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
          fontSize: 24,
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
                  // carName(),
                  SizedBox(height: 20,),
                  buildDropDownList(_carType, 'Select category of car', 'Car Type', selectedCarType),
                  // carType(),
                  SizedBox(height: 20,),
                  buildDropDownList(_carBrand, 'Select brand of car', 'Car Brand', selectedBrand),
                  // brand(),
                  SizedBox(height: 20,),
                  buildDropDownList(_transmissionType, 'Select type of transmission', 'Transmission', selectedTransmission),
                  // transmission(),
                  SizedBox(height: 20,),
                  buildTextField(_seatController, 'Enter number of seats', 'Number of Seats', isIntField: true),
                  // seat(),
                  SizedBox(height: 20,),
                  buildDropDownList(_fuelType, 'Select type of fuel', 'Fuel Type', selectedFuel),
                  // fuel(),
                  SizedBox(height: 20,),
                  // price(),
                  // SizedBox(height: 20,),
                  // description(),
                  // SizedBox(height: 20,),
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
                  buildTextField(_pickUpLocationController, 'Enter pick up location of car', 'Pick Up Location'),
                  SizedBox(height: 20,),
                  buildTextField(_dropOffLocationController, 'Enter drop off location of car', 'Drop Off Location'),
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
                  SizedBox(height: 20,),
                  buildTextField(_discountController, 'Enter discount price', 'Discount Price (RM/per day)', isIntField: true),
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
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20,),
                  buildTextField(_carConditionController, "Describe the car's condition or any recent maintenance", 'Car Condition'),
                  SizedBox(height: 30,), 

                  const Text(
                    "Contact",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20,),
                  buildTextField(_contactController, "Enter company contact", 'Contact', isIntField: true),
                  SizedBox(height: 20,), 

                  Container(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: (){},
                      child: Text(
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
        fontSize: 17,
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
          fontSize: 20,
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

  Widget buildDropDownList(List<String> listname, String hintText, String label, String? selectedValue){
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
          fontSize: 20,
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
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue!;
        });
      },
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
        color: Colors.black,
      ),
    );
  }

  Widget carName() {
    return TextField(
      // controller: _nameController,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        hintText: 'Enter name of car',
        labelText: 'Car Name',
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
          fontSize: 20,
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

  Widget carType() {
    return DropdownButtonFormField<String>(
      value: selectedCarType,
      hint: const Text('Select Car Type'),
      decoration: InputDecoration(
        labelText: 'Car Type',
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
          fontSize: 20,
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
      items: _carType.map<DropdownMenuItem<String>>((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedCarType = newValue;
        });
      },
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
        color: Colors.black,
      ),
    );
  }

  Widget brand() {
    return DropdownButtonFormField<String>(
      value: selectedBrand,
      hint: const Text('Select Car Brand'),
      decoration: InputDecoration(
        labelText: 'Brand',
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
          fontSize: 20,
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
      items: _carBrand.map<DropdownMenuItem<String>>((String brand) {
        return DropdownMenuItem<String>(
          value: brand,
          child: Text(brand),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedBrand = newValue;
        });
      },
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
        color: Colors.black,
      ),
    );
  }

  Widget transmission() {
    return DropdownButtonFormField<String>(
      value: selectedTransmission,
      hint: const Text('Select type of transmission'),
      decoration: InputDecoration(
        labelText: 'Transmission',
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
          fontSize: 20,
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
      items: _transmissionType.map<DropdownMenuItem<String>>((String transmission) {
        return DropdownMenuItem<String>(
          value: transmission,
          child: Text(transmission),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedTransmission = newValue;
        });
      },
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
        color: Colors.black,
      ),
    );
  }

  Widget seat() {
    return TextField(
      // controller: _nameController,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 17,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter number of seats',
        labelText: 'Number of seats',
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
          fontSize: 20,
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

  Widget fuel() {
    return DropdownButtonFormField<String>(
      value: selectedFuel,
      hint: const Text('Select type of fuel'),
      decoration: InputDecoration(
        labelText: 'Fuel Type',
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
          fontSize: 20,
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
      items: _fuelType.map<DropdownMenuItem<String>>((String fuel) {
        return DropdownMenuItem<String>(
          value: fuel,
          child: Text(fuel),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedFuel = newValue;
        });
      },
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
        color: Colors.black,
      ),
    );
  }

  Widget price() {
    return TextField(
      // controller: _nameController,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 17,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter price',
        labelText: 'Price (RM/per day)',
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
          fontSize: 20,
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

  Widget description() {
    return TextField(
      // controller: _nameController,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 17,
      ),
      maxLines: null,
      textAlign: TextAlign.justify,
      decoration: InputDecoration(
        hintText: 'Enter description of car',
        labelText: 'Description',
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
          fontSize: 20,
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

  Widget carImage() {
    return TextField(
      controller: _carImageController,
      readOnly: true,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 17,
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
          fontSize: 20,
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
            size: 30,
          ),
          onPressed: () {
            selectImage();
          }
        ),
      ),
    );
  }

}

// import 'dart:io';
// import 'dart:typed_data';

// import 'package:assignment_tripmate/screens/travelAgent/travelAgentViewCarInfo.dart';
// import 'package:assignment_tripmate/utils.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class TravelAgentAddCarInfoScreen extends StatefulWidget {
//   final String userId;

//   const TravelAgentAddCarInfoScreen({super.key, required this.userId});

//   @override
//   State<StatefulWidget> createState() => _TravelAgentAddCarInfoScreenState();
// }

// class _TravelAgentAddCarInfoScreenState extends State<TravelAgentAddCarInfoScreen> {
//   List<String> _carBrand = [];
//   List<String> _carType = ['SUV', 'Sedan'];
//   List<String> _transmissionType = ['Auto', 'Manual'];
//   List<String> _fuelType = ['Petrol', 'Electricity', 'Hybrid'];
//   List<String> _availabilityStatus = ['Available', 'Under Maintenance', 'Reserved'];

//   String? selectedBrand;
//   String? selectedCarType;
//   String? selectedTransmission;
//   String? selectedFuel;
//   String? selectedAvailabilityStatus;

//   final TextEditingController _carNameController = TextEditingController();
//   final TextEditingController _seatController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _pickUpLocationController = TextEditingController();
//   final TextEditingController _dropOffLocationController = TextEditingController();
//   final TextEditingController _availabilityLocationController = TextEditingController();
//   final TextEditingController _conditionController = TextEditingController();
//   final TextEditingController _contactDetailsController = TextEditingController();
//   final TextEditingController _rentalRatesController = TextEditingController();
//   final TextEditingController _discountsController = TextEditingController();
//   final TextEditingController _insuranceCoverageController = TextEditingController();
//   final TextEditingController _rentalPoliciesController = TextEditingController();
//   final TextEditingController _availableDatesController = TextEditingController();
//   final TextEditingController _imageNameController = TextEditingController();

//   Uint8List? _carImage;

//   @override
//   void initState() {
//     super.initState();
//     fetchCarBrands();
//   }

//   Future<void> fetchCarBrands() async {
//     try {
//       CollectionReference brandsRef = FirebaseFirestore.instance.collection('carBrand');
//       QuerySnapshot querySnapshot = await brandsRef.get();
      
//       setState(() {
//         _carBrand = querySnapshot.docs.map((doc) => doc['carBrandName'] as String).toList();
//       });
//     } catch (e) {
//       print('Error fetching car brands: $e');
//     }
//   }

//   Future<void> selectImage() async {
//     Uint8List? img = await ImageUtils.selectImage(context);
//     if (img != null) {
//       setState(() {
//         _carImage = img;
//         _imageNameController.text = 'Image Selected'; 
//       });
//     }
//   }

//   // Future<void> addCarInfo() async {
//   //   if (_carNameController.text.isEmpty || selectedBrand == null || selectedCarType == null ||
//   //       selectedTransmission == null || _seatController.text.isEmpty || selectedFuel == null ||
//   //       _priceController.text.isEmpty || _descriptionController.text.isEmpty || _carImage == null ||
//   //       _pickUpLocationController.text.isEmpty || _dropOffLocationController.text.isEmpty ||
//   //       _availabilityLocationController.text.isEmpty || selectedAvailabilityStatus == null ||
//   //       _conditionController.text.isEmpty || _contactDetailsController.text.isEmpty ||
//   //       _rentalRatesController.text.isEmpty || _discountsController.text.isEmpty ||
//   //       _insuranceCoverageController.text.isEmpty || _rentalPoliciesController.text.isEmpty ||
//   //       _availableDatesController.text.isEmpty) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Please fill all fields and upload an image.')),
//   //     );
//   //     return;
//   //   }

//   //   try {
//   //     // Upload image to Firebase Storage and get the URL
//   //     // Assume a function uploadImage returns the URL
//   //     String imageUrl = await uploadImage(_carImage!);

//   //     // Save car info to Firestore
//   //     await FirebaseFirestore.instance.collection('cars').add({
//   //       'carName': _carNameController.text,
//   //       'brand': selectedBrand,
//   //       'type': selectedCarType,
//   //       'transmission': selectedTransmission,
//   //       'seats': int.parse(_seatController.text),
//   //       'fuel': selectedFuel,
//   //       'price': double.parse(_priceController.text),
//   //       'description': _descriptionController.text,
//   //       'image': imageUrl,
//   //       'pickUpLocation': _pickUpLocationController.text,
//   //       'dropOffLocation': _dropOffLocationController.text,
//   //       'availabilityLocation': _availabilityLocationController.text,
//   //       'availabilityStatus': selectedAvailabilityStatus,
//   //       'condition': _conditionController.text,
//   //       'contactDetails': _contactDetailsController.text,
//   //       'rentalRates': _rentalRatesController.text,
//   //       'discounts': _discountsController.text,
//   //       'insuranceCoverage': _insuranceCoverageController.text,
//   //       'rentalPolicies': _rentalPoliciesController.text,
//   //       'availableDates': _availableDatesController.text,
//   //     });

//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Car information added successfully.')),
//   //     );
//   //   } catch (e) {
//   //     print('Error adding car info: $e');
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Failed to add car information.')),
//   //     );
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Car Info"),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF749CB9),
//         titleTextStyle: const TextStyle(
//           color: Colors.white,
//           fontFamily: 'Inika',
//           fontWeight: FontWeight.bold,
//           fontSize: 24,
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => TravelAgentViewCarListingScreen(userId: widget.userId))
//             );
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             TextField(
//               controller: _carNameController,
//               decoration: InputDecoration(labelText: 'Car Name'),
//             ),
//             DropdownButtonFormField<String>(
//               value: selectedBrand,
//               onChanged: (value) => setState(() => selectedBrand = value),
//               items: _carBrand.map((brand) {
//                 return DropdownMenuItem<String>(
//                   value: brand,
//                   child: Text(brand),
//                 );
//               }).toList(),
//               decoration: InputDecoration(labelText: 'Car Brand'),
//             ),
//             DropdownButtonFormField<String>(
//               value: selectedCarType,
//               onChanged: (value) => setState(() => selectedCarType = value),
//               items: _carType.map((type) {
//                 return DropdownMenuItem<String>(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               decoration: InputDecoration(labelText: 'Car Type'),
//             ),
//             DropdownButtonFormField<String>(
//               value: selectedTransmission,
//               onChanged: (value) => setState(() => selectedTransmission = value),
//               items: _transmissionType.map((transmission) {
//                 return DropdownMenuItem<String>(
//                   value: transmission,
//                   child: Text(transmission),
//                 );
//               }).toList(),
//               decoration: InputDecoration(labelText: 'Transmission Type'),
//             ),
//             DropdownButtonFormField<String>(
//               value: selectedFuel,
//               onChanged: (value) => setState(() => selectedFuel = value),
//               items: _fuelType.map((fuel) {
//                 return DropdownMenuItem<String>(
//                   value: fuel,
//                   child: Text(fuel),
//                 );
//               }).toList(),
//               decoration: InputDecoration(labelText: 'Fuel Type'),
//             ),
//             TextField(
//               controller: _seatController,
//               decoration: InputDecoration(labelText: 'Number of Seats'),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: _priceController,
//               decoration: InputDecoration(labelText: 'Price'),
//               keyboardType: TextInputType.numberWithOptions(decimal: true),
//             ),
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: 'Description'),
//               maxLines: 3,
//             ),
//             TextField(
//               controller: _pickUpLocationController,
//               decoration: InputDecoration(labelText: 'Pick-up Location'),
//             ),
//             TextField(
//               controller: _dropOffLocationController,
//               decoration: InputDecoration(labelText: 'Drop-off Location'),
//             ),
//             TextField(
//               controller: _availabilityLocationController,
//               decoration: InputDecoration(labelText: 'Car Availability Location'),
//             ),
//             TextField(
//               controller: _availableDatesController,
//               decoration: InputDecoration(labelText: 'Available Dates'),
//             ),
//             DropdownButtonFormField<String>(
//               value: selectedAvailabilityStatus,
//               onChanged: (value) => setState(() => selectedAvailabilityStatus = value),
//               items: _availabilityStatus.map((status) {
//                 return DropdownMenuItem<String>(
//                   value: status,
//                   child: Text(status),
//                 );
//               }).toList(),
//               decoration: InputDecoration(labelText: 'Availability Status'),
//             ),
//             TextField(
//               controller: _conditionController,
//               decoration: InputDecoration(labelText: 'Condition Details'),
//             ),
//             TextField(
//               controller: _contactDetailsController,
//               decoration: InputDecoration(labelText: 'Contact Details'),
//             ),
//             TextField(
//               controller: _rentalRatesController,
//               decoration: InputDecoration(labelText: 'Rental Rates'),
//             ),
//             TextField(
//               controller: _discountsController,
//               decoration: InputDecoration(labelText: 'Discounts or Promotions'),
//             ),
//             TextField(
//               controller: _insuranceCoverageController,
//               decoration: InputDecoration(labelText: 'Insurance Coverage'),
//             ),
//             TextField(
//               controller: _rentalPoliciesController,
//               decoration: InputDecoration(labelText: 'Rental Policies'),
//             ),
//             SizedBox(height: 16.0),
//             // GestureDetector(
//             //   onTap: selectImage,
//             //   child: Container(
//             //     color: Colors.grey[200],
//             //     padding: EdgeInsets.all(16.0),
//             //     child: _carImage == null
//             //         ? Text('Tap to select car image')
//             //         : MemoryImage(_carImage!),
//             //   ),
//             // ),
//             TextField(
//               readOnly: true,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w800,
//                 fontSize: 17,
//                 color: Colors.black54
//               ),
//               decoration: InputDecoration(
//                 hintText: 'Please upload the image of car...',
//                 labelText: 'Car Image',
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(
//                     color: Color(0xFF467BA1),
//                     width: 2.5,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(
//                     color: Color(0xFF467BA1),
//                     width: 2.5,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(
//                     color: Color(0xFF467BA1),
//                     width: 2.5,
//                   ),
//                 ),
//                 floatingLabelBehavior: FloatingLabelBehavior.always,
//                 labelStyle: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                   shadows: [
//                     Shadow(
//                       offset: Offset(0.5, 0.5),
//                       color: Colors.black87,
//                     ),
//                   ],
//                 ),
//                 suffixIcon: IconButton(
//                   icon: const Icon(
//                     Icons.image,
//                     color: Color(0xFF467BA1),
//                     size: 30,
//                   ),
//                   onPressed: () {
//                     selectImage();
//                   }
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               // onPressed: addCarInfo,
//               onPressed: (){},
//               child: Text('Add Car Information'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
