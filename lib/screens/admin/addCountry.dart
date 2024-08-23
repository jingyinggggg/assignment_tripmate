import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddCountryScreen extends StatefulWidget {
  final String userId;

  const AdminAddCountryScreen({super.key, required this.userId});

  @override
  State<AdminAddCountryScreen> createState() => _AdminAddCountryScreenState();
}

class _AdminAddCountryScreenState extends State<AdminAddCountryScreen> {
  bool _isLoading = false;
  final TextEditingController _countryNameController = TextEditingController();

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _selectedImage = File(pickedFile.path);
  //     });
  //   } else {
  //     print('No image selected.');
  //   }
  // }

  // Future<void> _uploadImageAndSaveData() async {
  //   if (_selectedImage == null || _countryNameController.text.isEmpty) return;

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     // Upload image to Firebase Storage
  //     final storageRef = FirebaseStorage.instance.ref();
  //     final countryName = _countryNameController.text.trim();
  //     final imageRef = storageRef.child('countries/$countryName/${DateTime.now().millisecondsSinceEpoch}.jpg');

  //     await imageRef.putFile(_selectedImage!);
  //     final downloadUrl = await imageRef.getDownloadURL();

  //     // Save country data to Firestore
  //     await FirebaseFirestore.instance.collection('countries').add({
  //       'name': countryName,
  //       'imageUrl': downloadUrl,
  //       // Add other fields if needed
  //     });

  //     setState(() {
  //       _isLoading = false;
  //     });

  //     // Show success message or navigate back
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Country added successfully!')),
  //     );
  //     Navigator.pop(context);

  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to add country: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Add Country"),
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                countryName(),
                const SizedBox(height: 20),

                // _selectedImage != null
                //     ? Image.file(
                //         _selectedImage!,
                //         width: 100,
                //         height: 100,
                //         fit: BoxFit.cover,
                //       )
                //     : GestureDetector(
                //         onTap: _pickImage,
                //         child: Container(
                //           width: 100,
                //           height: 100,
                //           decoration: BoxDecoration(
                //             border: Border.all(color: Colors.grey),
                //             borderRadius: BorderRadius.circular(10),
                //           ),
                //           child: const Icon(
                //             Icons.add_a_photo,
                //             color: Colors.grey,
                //           ),
                //         ),
                //       ),
                const SizedBox(height: 20),

                const Text(
                  "Preview:",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 10),

                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => UpdateProfileScreen(userId: widget.userId,)),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF467BA1),
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontFamily: 'Inika',
                        fontWeight: FontWeight.bold,
                      ),
                      minimumSize: const Size(380, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget countryName() {
    return TextField(
      controller: _countryNameController,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        hintText: 'Enter Country Name',
        labelText: 'Country Name',
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
}
