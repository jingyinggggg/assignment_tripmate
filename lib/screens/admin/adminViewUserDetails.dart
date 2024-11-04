import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/admin/manageUserList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminManageUserDetailsScreen extends StatefulWidget {
  final String userId;
  final String userListID;
  final String type;
  final String? localBuddyId;
  final String? localBuddyname;

  const AdminManageUserDetailsScreen({
    super.key,
    required this.userId,
    required this.userListID,
    required this.type,
    this.localBuddyId,
    this.localBuddyname
  });

  @override
  State<StatefulWidget> createState() => _AdminManageUserDetailsScreenState();
}

class _AdminManageUserDetailsScreenState extends State<AdminManageUserDetailsScreen> {
  bool isFetching = false;
  Map<String, dynamic> userData = {};
  List<String> genderType = ['Male', 'Female'];

  // User
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController contactController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  DateTime? _selectedDate;
  String? _selectedGender;

  // TA
  late TextEditingController companyNameController;
  late TextEditingController companyAddressController;

  // LB
  late TextEditingController occupationController;
  late TextEditingController buddyLocationController;
  late TextEditingController languageSpokenController;
  late TextEditingController priceController;
  late TextEditingController bioController;
  List<String> selectedDays = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchUserDetails();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    usernameController = TextEditingController();
    contactController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    companyNameController = TextEditingController();
    companyAddressController = TextEditingController();
    occupationController = TextEditingController();
    buddyLocationController = TextEditingController();
    languageSpokenController = TextEditingController();
    priceController = TextEditingController();
    bioController = TextEditingController();
  }

  Future<void> _fetchUserDetails() async {
    setState(() {
      isFetching = true;
    });
    try {
      DocumentReference reference;
      if (widget.type == "user") {
        reference = FirebaseFirestore.instance.collection('users').doc(widget.userListID);
      } else if (widget.type == "ta") {
        reference = FirebaseFirestore.instance.collection('travelAgent').doc(widget.userListID);
      } else {
        reference = FirebaseFirestore.instance.collection('localBuddy').doc(widget.localBuddyId!);
      }

      DocumentSnapshot snapshot = await reference.get();
      if (snapshot.exists) {
        userData = snapshot.data() as Map<String, dynamic>;

        // Print the userData to inspect the fetched data
        if (widget.type == "lb") {
          print("Fetched Local Buddy Data: $userData");
        }

        setState(() {
          if (widget.type == "lb") {
            occupationController.text = userData['occupation'] ?? '';
            buddyLocationController.text = userData['location'] ?? '';
            languageSpokenController.text = userData['languageSpoken'] ?? '';
            priceController.text = (userData['price'] ?? '0').toString();
            bioController.text = userData['bio'] ?? '';

            if (userData['availability'] is List) {
              selectedDays = (userData['availability'] as List<dynamic>)
                  .map((item) => item['day']?.toString() ?? '') // Handle potential null values here
                  .toList();
            } else {
              selectedDays = []; // Default to an empty list if not available or not a List
            }
          } else {
            nameController.text = userData['name'] ?? '';
            usernameController.text = userData['username'] ?? '';
            contactController.text = userData['contact'] ?? '';
            emailController.text = userData['email'] ?? '';
            _selectedGender = userData['gender'] ?? '';

            // Check if 'dob' is non-null before calling .toDate()
            _selectedDate = userData['dob'] != null ? userData['dob'].toDate() : null;

            if (widget.type == "user") {
              addressController.text = userData['address'] ?? '';
            } else if (widget.type == "ta") {
              companyNameController.text = userData['companyName'] ?? '';
              companyAddressController.text = userData['companyAddress'] ?? '';
            }
          }
        });
      } else {
        print("No data found for the specified document.");
      }
    } catch (e) {
      print('Error fetching user details: $e');
    } finally {
      setState(() {
        isFetching = false;
      });
    }
  }



  void toggleDaySelection(String day) {
    setState(() {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day); // Unselect the day
      } else {
        selectedDays.add(day); // Select the day
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    contactController.dispose();
    emailController.dispose();
    addressController.dispose();
    companyNameController.dispose();
    companyAddressController.dispose();
    occupationController.dispose();
    buddyLocationController.dispose();
    languageSpokenController.dispose();
    priceController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2006, 12, 31),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime(2006, 12, 31),
      builder: (BuildContext context, Widget? child) {
        return ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("User"),
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
              MaterialPageRoute(builder: (context) => AdminManageUserListScreen(userId: widget.userId))
            );
          },
        ),
      ),
      body: isFetching
          ? Center(child: CircularProgressIndicator(color: primaryColor,))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User details:",
                      style: TextStyle(
                        fontSize: defaultLabelFontSize,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10),
                    if(widget.type == "user" || widget.type == "ta")...[
                      buildTextField(nameController, "Name", "Please enter name..."),
                      SizedBox(height: 10),
                      buildTextField(usernameController, "Username", "Please enter username..."),
                      SizedBox(height: 10),
                      buildTextField(emailController, "Email", "Please enter email..."),
                      SizedBox(height: 10),
                      buildDropDownList(
                        genderType, 
                        "Please select a gender", 
                        "Gender", 
                        _selectedGender, 
                        (newValue){
                          setState(() {
                            _selectedGender = newValue;
                          });
                        }
                      ),
                      SizedBox(height: 10),
                      dob(),
                      SizedBox(height: 10),
                      if(widget.type == "user")
                        buildTextField(addressController, "Address", "Please enter address...")
                      else if(widget.type == "ta")...[
                        buildTextField(companyNameController, "Company Name", "Please enter company name..."),
                        SizedBox(height: 10),
                        buildTextField(companyAddressController, "Address", "Please enter address...")
                      ],
                    ]
                    else...[
                      buildTextField(occupationController, "Occupation", "Please enter occupation..."),
                      SizedBox(height: 10),
                      buildTextField(buddyLocationController, "Buddy Location", "Please enter buddy location..."),
                      SizedBox(height: 10),
                      buildTextField(languageSpokenController, "Language Spoken", "Please enter language spoken..."),
                      SizedBox(height: 10),
                      // Availability Section
                      Text(
                        'Availability',
                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: double.infinity, // Set the width to take up all available space
                        child: Table(
                          border: TableBorder.all(color: primaryColor, width: 2.5, borderRadius: BorderRadius.circular(10)),
                          columnWidths: {
                            0: FlexColumnWidth(), // Make column take proportional width
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.6),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'Day',
                                    style: TextStyle(
                                      fontSize: defaultFontSize,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            // Iterate over all days of the week
                            for (var day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
                              TableRow(
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: selectedDays.contains(day), // Check if the day is selected
                                        onChanged: (value) {
                                          toggleDaySelection(day); // Handle checkbox toggle
                                        },
                                        activeColor: primaryColor, // Change checkbox color
                                      ),
                                      Text(
                                        day,
                                        style: TextStyle(
                                          fontSize: defaultFontSize,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),
                      buildTextField(priceController, "Price in RM (per day)", "Please enter price..."),
                      SizedBox(height: 10),
                      buildTextField(bioController, "Bio", "Please enter bio..."),
                    ],
                    SizedBox(height: 10),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity, // This makes the button take up the full width
                      child: ElevatedButton(
                        onPressed: (){},
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF467BA1),
                          padding: const EdgeInsets.symmetric(vertical: 15), // You can remove horizontal padding to avoid shrinking
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
                  ],
                ),
              )
              
            ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText, String hintText) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: defaultFontSize,
        color: Colors.black
      ),
      maxLines: null,
      textAlign: TextAlign.justify,
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
      ),
    );
  }

  Widget gender() {
    return TextFormField(
      readOnly: true,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 14,
        color: Colors.black54
      ),
      decoration: InputDecoration(
        labelText: 'Gender',
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
      ),
      controller: TextEditingController(
        text: _selectedGender ?? 'Not Specified',
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

  Widget dob() {
    return GestureDetector(
      onTap: () {}, // Prevents the TextField from being editable by touch.
      child: TextField(
        controller: TextEditingController(
          text: _selectedDate == null
              ? ''
              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
        ),
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 14,
          color: _selectedDate == null ? Colors.grey.shade600 : Colors.black,
        ),
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Select your date of birth',
          labelText: 'Date of Birth',
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
              Icons.calendar_today_outlined,
              color: Color(0xFF467BA1),
              size: 20,
            ),
            onPressed: () => _selectDate(context),
          ),
        ),
      ),
    );
  }
}
