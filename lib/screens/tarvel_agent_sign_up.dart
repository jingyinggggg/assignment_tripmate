import 'package:flutter/material.dart';
import 'package:assignment_tripmate/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:assignment_tripmate/firebase_auth_services.dart';

class TravelAgentSignUpScreen extends StatefulWidget {
  const TravelAgentSignUpScreen({super.key});

  @override
  State<TravelAgentSignUpScreen> createState() => _TravelAgentSignUpScreenState();
}

class _TravelAgentSignUpScreenState extends State<TravelAgentSignUpScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyContactController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? dropdownValue;
  
  DateTime? _selectedDate;
  bool passwordVisible = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyContactController.dispose();
    _companyNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Method to show date picker
  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2006, 12, 31),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime(2006, 12, 31),
      builder: (BuildContext context, Widget? child) {
        return ScrollConfiguration(
          behavior: const ScrollBehavior(),
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

  void _saveUserData() async {
    // Validate inputs
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _companyContactController.text.isEmpty ||
        _companyNameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _selectedDate == null ||
        dropdownValue == null) {
      // Show an error dialog if any field is empty
      _showDialog(
        title: 'Validation Error',
        content: 'Please fill all fields and select a date of birth.',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      return;
    }

    // // Validate password
    // String _errorMessage = ''; 

    // // Password length greater than 6 
    // if (_passwordController.text.length <6) { 
    //   _errorMessage += '• Password must be longer than 6 characters.\n'; 
    // } 

    // // Contains at least one uppercase letter 
    // if (!_passwordController.text.contains(RegExp(r'[A-Z]'))) { 
    //   _errorMessage += '• Uppercase letter is missing.\n'; 
    // } 

    // // Contains at least one lowercase letter 
    // if (!_passwordController.text.contains(RegExp(r'[a-z]'))) { 
    //   _errorMessage += '• Lowercase letter is missing.\n'; 
    // } 

    // // Contains at least one digit 
    // if (!_passwordController.text.contains(RegExp(r'[0-9]'))) { 
    //   _errorMessage += '• Digit is missing.\n'; 
    // } 

    // // Contains at least one special character 
    // if (!_passwordController.text.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) { 
    //   _errorMessage += '• Special character is missing.\n'; 
    // } 

    // if (_errorMessage != ""){
    //   _showDialog(
    //     title: 'Validation Error',
    //     content: _errorMessage,
    //     onPressed: () {
    //       Navigator.of(context).pop();
    //     },
    //   );
    // } else {
    //   return;
    // }

    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      // Show an error dialog if passwords do not match
      _showDialog(
        title: 'Validation Error',
        content: 'Passwords do not match.',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final FirebaseAuthService _auth = FirebaseAuthService();

    String name = _nameController.text;
    String email = _emailController.text;
    DateTime? dob = _selectedDate;
    String companyContact = _companyContactController.text;
    String companyName = _companyNameController.text;
    String password = _passwordController.text;
    String gender = dropdownValue!;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    try{
      if (user != null){
        await firestore.collection('travelAgent').add({
          'name': name,
          'email': email,
          'dob': dob,
          'companyContact': companyContact,
          'companyName': companyName,
          'gender': gender,
          'password': password
        });

        // Show success dialog
        _showDialog(
          title: 'Registration Successful',
          content: 'You have been registered successfully.',
          onPressed: () {
            Navigator.of(context).pop(); // Close the success dialog
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        );
      }
    } catch(e){
      // Show error dialog
      _showDialog(
        title: 'Registration Failed',
        content: 'Failed to save user data: $e',
        onPressed: () {
          Navigator.of(context).pop(); // Close the error dialog
        },
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/welcome_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // White container with opacity
          Container(
            height: double.infinity,
            color: const Color(0xFFEDF2F6).withOpacity(0.6),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:20, left:20),
                          child: Image.asset(
                            'images/logo.png',
                            height: 35,
                            width: 35,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          child: Text(
                            'Register as travel agent',
                            style: TextStyle(
                              fontFamily: 'inika',
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                      child: Column(
                        children: [
                          name(),
                          SizedBox(height: 20),
                          email(),
                          SizedBox(height: 20),
                          dobField(),
                          SizedBox(height: 20),
                          gender(),
                          SizedBox(height: 20),
                          companyContact(),
                          SizedBox(height: 20),
                          companyName(),
                          SizedBox(height: 20),
                          password(),
                          SizedBox(height: 20),
                          confirm_password(),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        _saveUserData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF467BA1),
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'Inika',
                          fontWeight: FontWeight.bold,
                        ),
                        minimumSize: Size(380, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF467BA1),
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'Inika',
                          fontWeight: FontWeight.bold,
                        ),
                        minimumSize: Size(380, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget name() {
    return TextField(
      controller: _nameController,
      style: const TextStyle(
        fontFamily: 'Inika',
        fontWeight: FontWeight.w800,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        hintText: 'Enter Name',
        labelText: 'Name',
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
          fontFamily: 'Inika',
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

  Widget email() {
    return TextField(
      controller: _emailController,
      style: const TextStyle(
        fontFamily: 'Inika',
        fontWeight: FontWeight.w800,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        hintText: 'Enter Email',
        labelText: 'Email',
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
          fontFamily: 'Inika',
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

  Widget dobField() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(
            text: _selectedDate == null
                ? 'Select Date of Birth'
                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
          ),
          style: TextStyle(
            fontFamily: 'Inika',
            fontWeight: FontWeight.w800,
            fontSize: 17,
            color: _selectedDate == null ? Colors.grey.shade600 : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Date of Birth',
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
              fontFamily: 'Inika',
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
        ),
      ),
    );
  }

  Widget gender() {
    return DropdownButtonFormField<String>(
      value: dropdownValue,
      hint: Text('Select Gender'),
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
          fontFamily: 'Inika',
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
      items: const [
        DropdownMenuItem<String>(
          value: 'Male',
          child: Text('Male'),
        ),
        DropdownMenuItem<String>(
          value: 'Female',
          child: Text('Female'),
        ),
      ],
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      style: const TextStyle(
        fontFamily: 'Inika',
        fontWeight: FontWeight.bold,
        fontSize: 17,
        color: Colors.black,
      ),
    );
  }

  Widget companyContact() {
    return TextField(
      controller: _companyContactController,
      style: const TextStyle(
        fontFamily: 'Inika',
        fontWeight: FontWeight.w800,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        hintText: 'Enter Company Contact Number',
        labelText: 'Company Contact Number',
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
          fontFamily: 'Inika',
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

  Widget companyName() {
    return TextField(
      controller: _companyNameController,
      style: const TextStyle(
        fontFamily: 'Inika',
        fontWeight: FontWeight.w800,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        hintText: 'Enter Company Name',
        labelText: 'Company Name',
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
          fontFamily: 'Inika',
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

  Widget password() {
    return TextField(
      controller: _passwordController,
      obscureText: passwordVisible,
      style: const TextStyle(
        fontFamily: 'Inika',
        fontWeight: FontWeight.w800,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        hintText: 'Enter Password',
        labelText: 'Password',
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
          fontFamily: 'Inika',
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
          icon: Icon(
            passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget confirm_password() {
    return TextField(
      controller: _confirmPasswordController,
      obscureText: passwordVisible,
      style: const TextStyle(
        fontFamily: 'Inika',
        fontWeight: FontWeight.w800,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        hintText: 'Confirm Password',
        labelText: 'Confirm Password',
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
          fontFamily: 'Inika',
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
          icon: Icon(
            passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ),
      ),
    );
  }

}