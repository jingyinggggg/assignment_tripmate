import 'package:assignment_tripmate/screens/user/updateProfile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProfileScreen extends StatefulWidget {
  final String userId;

  const AdminProfileScreen({super.key, required this.userId});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Profile"),
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
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Container(
                  width: 150,
                  height: 170,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userData['username'],
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
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
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 55,
                left: 30,
                child: const Image(
                  image: AssetImage("images/route line.png"),
                  height: 200,
                  width: 340,
                ),
              ),
              Positioned(
                top: 40,
                left: 322,
                child: Column(
                  children: [
                    const Text(
                      "Profile",
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

              Positioned(
                top:270,
                left: 10,
                right: 10,
                child: Container(
                  width: 390, // Make the container take the full width of its parent
                  decoration: BoxDecoration(
                    color: Color(0xFF467BA1), // Blue color
                    borderRadius: BorderRadius.circular(20), // Adjust the border radius
                  ),
                  // padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Let the column size adjust based on its children
                    children: [
                      Row(
                        children: [
                          // First Container
                          Container(
                            height: 40, // Adjust height as needed
                            decoration: const BoxDecoration(
                              color: Color(0xFF467BA1), // Background color
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20), // Rounded corner on the top left
                              ),
                              border: Border(
                                right: BorderSide(color: Colors.white, width: 2.5), // White right border
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                                child: Text(
                                  "ACCOUNT INFO",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 100),
                                Icon(
                                  Icons.airplane_ticket_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // The middle white part, which will expand or shrink based on content
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                               Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Name: ",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            userData['name'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Text(
                                            "Email: ",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            userData['email'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  SizedBox(width: 70),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Username:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        userData['username']?? '',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ]
                               )
                            ],
                          ),
                        ),
                      ),

                      // The bottom blue part
                      Container(
                        height:25,
                        padding: EdgeInsets.all(10), // Add padding if needed
                        decoration: BoxDecoration(
                          color: Color(0xFF467BA1), // Same blue color
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),


                      // Vertical dotted line on the right
                      // Positioned(
                      //   top: 0,
                      //   bottom: 0,
                      //   right: 10, // Position the line 10 pixels from the right edge
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: List.generate(10, (index) {
                      //       return Container(
                      //         width: 2,
                      //         height: 10,
                      //         color: Colors.white,
                      //         margin: EdgeInsets.symmetric(vertical: 4),
                      //       );
                      //     }),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsetsDirectional.only(top: 250),
                child: Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateProfileScreen(userId: widget.userId,)),
                      );
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF467BA1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontFamily: 'Inika',
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
