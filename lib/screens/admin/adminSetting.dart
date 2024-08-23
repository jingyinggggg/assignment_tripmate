import 'package:assignment_tripmate/screens/admin/adminUpdatePassword.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSettingScreen extends StatefulWidget {
  final String userId;

  const AdminSettingScreen({super.key, required this.userId});

  @override
  State<AdminSettingScreen> createState() => _AdminSettingScreenState();
}

class _AdminSettingScreenState extends State<AdminSettingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Setting"),
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
            .collection('admin')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text("Admin not found"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

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
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 20),
                child: Container(
                  width: 150,
                  height: 170,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userData['username'] ?? 'Please update your username',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white, // Set background color
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF467BA1), width: 4)
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0), // Adding padding
                            child: Image.asset(
                              'images/logo.png', // Your updated logo asset
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                    ]
                  ),
                ),
              ),
              Positioned(
                top: 75,
                left: 30,
                child: const Image(
                  image: AssetImage("images/route line.png"),
                  height: 200,
                  width: 340,
                ),
              ),
              Positioned(
                top: 60,
                left: 321,
                child: Column(
                  children: [
                    const Text(
                      "Setting",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Image.asset(
                      'images/location-pin.png',
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 260, left: 10, right: 10), // Space before the container
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => AdminUpdatePasswordScreen(userId: widget.userId)
                          )
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0xFF467BA1), width: 3),
                        ),
                        minimumSize: const Size(120, 65),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.lock,
                            color: Colors.black,
                            size: 25,
                          ),
                          SizedBox(width: 15),

                          SizedBox(
                            width: 270,
                            child: Text(
                              "Change Password",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ],
          );
        },
      ),
    );
  }
}
