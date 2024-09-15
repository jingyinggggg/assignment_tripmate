import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:assignment_tripmate/saveImageToFirebase.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String userId;

  const UpdateProfileScreen({super.key, required this.userId});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  DateTime? _selectedDate;
  String? _selectedGender;
  Uint8List? _image;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _contactController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List? img = await ImageUtils.selectImage(context);
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Update Profile"),
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text("User not found"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          if (_nameController.text.isEmpty) {
            _nameController.text = userData['name'] ?? '';
            _usernameController.text = userData['username'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _contactController.text = userData['contact'] ?? '';
            _addressController.text = userData['address'] ?? '';
            _selectedGender = userData['gender'];
            _selectedDate = userData['dob']?.toDate();
          }

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/account_background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                color: const Color(0xFFEDF2F6).withOpacity(0.6),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: screenWidth * 0.15,
                                backgroundImage: _image != null
                                    ? MemoryImage(_image!)
                                    : userData['profileImage'] != null
                                        ? NetworkImage(userData['profileImage'])
                                        : const AssetImage("images/profile.png"),
                                backgroundColor: Colors.white,
                              ),
                              Positioned(
                                bottom: -13,
                                left: 70,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  onPressed: selectImage,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          _buildTextField(_nameController, 'Name', 'Please update your name...'),
                          const SizedBox(height: 20),
                          _buildTextField(_usernameController, 'Username', 'Please update your username...', maxLength: 12),
                          const SizedBox(height: 20),
                          _buildTextField(_emailController, 'Email', 'Please update your email...'),
                          const SizedBox(height: 20),
                          _buildTextField(_contactController, 'Contact', 'Please update your contact...'),
                          const SizedBox(height: 20),
                          _buildReadOnlyTextField('Date of Birth', _selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : 'Select Date of Birth'),
                          const SizedBox(height: 20),
                          _buildReadOnlyTextField('Gender', _selectedGender ?? 'Not Specified'),
                          const SizedBox(height: 20),
                          _buildTextField(_addressController, 'Address', 'Please update your address...', maxLines: null),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isUpdating ? null : _updateProfile,
                              child: const Text('Update', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF467BA1),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isUpdating)
                Center(
                  child: Container(
                    child: const CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        }
      )
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hintText, {int? maxLength, int? maxLines}) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
      decoration: _inputDecoration(label, hintText),
    );
  }

  Widget _buildReadOnlyTextField(String label, String text) {
    return TextFormField(
      readOnly: true,
      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black54),
      decoration: _inputDecoration(label, text),
      controller: TextEditingController(text: text),
    );
  }

  InputDecoration _inputDecoration(String label, String hintText) {
    return InputDecoration(
      hintText: hintText,
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF467BA1), width: 2.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF467BA1), width: 2.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF467BA1), width: 2.5),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        shadows: [Shadow(offset: Offset(0.5, 0.5), color: Colors.black87)],
      ),
    );
  }

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

  Future<void> _updateProfile() async {
    if (_usernameController.text.isEmpty) {
      showSnackBar("Username cannot be empty", context);
      return;
    }
    if (_nameController.text.isEmpty) {
      showSnackBar("Name cannot be empty", context);
      return;
    }

    setState(() {
      isUpdating = true; // Start loading
    });

    try {
      // Fetch the current user's data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId) 
          .get();

      // Get the profile image URL from the fetched user data
      String? existingProfileURL = userDoc['profileImage'] ?? '';

      Uint8List? profileImageToUpload;

      // Check if a new image is selected (_image is not null)
      if (_image != null) {
        profileImageToUpload = _image!;
      } else if (existingProfileURL != null && existingProfileURL.isNotEmpty) {
        // If no new image is selected, use the existing profile image URL
        profileImageToUpload = await _getImageFromURL(existingProfileURL);
      } 

      if (_nameController.text.isNotEmpty && 
          _usernameController.text.isNotEmpty && 
          _emailController.text.isNotEmpty &&
          _contactController.text.isNotEmpty && 
          _addressController.text.isNotEmpty) {
        
        // Update the profile data in Firestore
        String resp = await StoreData().updateUserProfile(
          userId: widget.userId, 
          name: _nameController.text, 
          username: _usernameController.text, 
          email: _emailController.text, 
          contact: _contactController.text, 
          address: _addressController.text, 
          file: profileImageToUpload // Use the selected or existing image
        );

        // Show success dialog
        _showDialog(
          title: 'Update Successful',
          content: 'Your details have been updated successfully.',
          onPressed: () {
            Navigator.of(context).pop(); // Close the success dialog
            // Navigator.push(
            //   context, 
            //   MaterialPageRoute(builder: (context) => ProfileScreen(userId: widget.userId))
            // );
          },
        );
      }
    } catch (e) {
      // Handle errors
      _showDialog(
        title: 'Update Failed',
        content: 'An error occurred: $e',
        onPressed: () {
          Navigator.of(context).pop(); // Close the error dialog
        },
      );
    } finally {
      setState(() {
        isUpdating = false; // Stop loading
      });
    }
  }

  // Helper function to download the existing image from a URL and convert it to Uint8List
  Future<Uint8List> _getImageFromURL(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }


  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

}