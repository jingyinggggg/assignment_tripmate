import 'package:assignment_tripmate/screens/travelAgent/travelAgentUpdateProfile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; 

class TravelAgentProfileScreen extends StatefulWidget {
  final String userId;

  const TravelAgentProfileScreen({super.key, required this.userId});

  @override
  State<TravelAgentProfileScreen> createState() => _TravelAgentProfileScreenState();
}

class _TravelAgentProfileScreenState extends State<TravelAgentProfileScreen> {

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
            .collection('travelAgent')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text("Travel agent not found"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          // Format the DateTime object to only show the date
          String formatDate(DateTime dateTime) {
            return DateFormat('dd/MM/yyy').format(dateTime);
          }

          // Get the DateTime from the userData
          DateTime? dob = userData['dob']?.toDate(); // Convert Timestamp to DateTime

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
                        userData['username'] ?? userData['name'],
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: 128,  // Width and height should match the CircleAvatar's diameter (2 * radius)
                        height: 128,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF467BA1),  // Border color
                            width: 3.0,  // Border width
                          ),
                        ),
                        child: userData['profileImage'] != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(userData['profileImage']),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage: AssetImage("images/profile.png"),
                                backgroundColor: Colors.white,
                              ),
                      )

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
                      // The top blue part
                      Container(
                        padding: EdgeInsets.all(10), // Add padding if needed
                        decoration: BoxDecoration(
                          color: Color(0xFF467BA1), // Same blue color
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "ACCOUNT INFO",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(width: 110),
                            Icon(
                              Icons.airplane_ticket_outlined,
                              color: Colors.white,
                              size: 25,
                            )
                          ],
                        ),
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
                                  Container(
                                    width: 260,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Color(0xFF467BA1),
                                          width: 2
                                        )
                                      )
                                    ),
                                    child: Column(
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
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Text(
                                              "DOB: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              dob != null ? formatDate(dob) : '',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
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
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Text(
                                              "Account Status: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                if (userData['accountApproved'] == 0)
                                                  Row(
                                                    children: const [
                                                      Text(
                                                        "Reviewing",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.orange, // You can change the color as needed
                                                          fontWeight: FontWeight.w900,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Icon(Icons.hourglass_empty, color: Colors.orange), // Icon for reviewing
                                                    ],
                                                  )
                                                else if (userData['accountApproved'] == 1)
                                                  Row(
                                                    children: const [
                                                      Text(
                                                        "Approved",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.green, // You can change the color as needed
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Icon(Icons.check_circle, color: Colors.green), // Icon for approved
                                                    ],
                                                  )
                                                else
                                                  const Text(
                                                    "", // Default case (empty text)
                                                  ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 10),

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
                                        userData['username']?? '-',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Gender: ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        userData['gender'] ?? 'Null',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),

                                    ],
                                  ),
                                ]
                              ),

                              const SizedBox(height: 10),

                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color(0xFF467BA1),
                                      width: 2,
                                    )
                                  )
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Company Name: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          userData['companyName'] ?? '',
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
                                          "Company Contact: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          userData['companyContact'] ?? '',
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
                                          "Company Address: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          userData['companyAddress'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ),
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
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsetsDirectional.only(top: 500),
                child: Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TravelAgentUpdateProfileScreen(userId: widget.userId,)),
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
