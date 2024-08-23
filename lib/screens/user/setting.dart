import 'package:assignment_tripmate/screens/user/updatePassword.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingScreen extends StatefulWidget {
  final String userId;

  const SettingScreen({super.key, required this.userId});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

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
                            builder: (context) => UpdatePasswordScreen(userId: widget.userId)
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

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        // Handle navigation or other actions here.
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
                            Icons.delete_forever,
                            color: Colors.black,
                            size: 25,
                          ),
                          SizedBox(width: 15),

                          SizedBox(
                            width: 270,
                            child: Text(
                              "Delete Account",
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

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        // Handle navigation or other actions here.
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
                          ImageIcon(
                            AssetImage("images/leave_feedback.png"),  // The path to your image asset
                            color: Colors.black,  // Set the color of the image icon
                            size: 25,  // Set the size of the image icon
                          ),

                          SizedBox(width: 15),

                          SizedBox(
                            width: 270,
                            child: Text(
                              "Leave a feedback",
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class SettingScreen extends StatefulWidget {
//   final String userId;

//   const SettingScreen({super.key, required this.userId});

//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         title: const Text("Setting"),
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
//             Navigator.pop(context);
//           },
//         ),
//       ),

//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(widget.userId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data?.data() == null) {
//             return const Center(child: Text("User not found"));
//           }

//           var userData = snapshot.data!.data() as Map<String, dynamic>;

//           return Stack(
//             children: [
//               Container(
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("images/account_background.png"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),

//               Container(
//                 height: double.infinity,
//                 width: double.infinity,
//                 color: const Color(0xFFEDF2F6).withOpacity(0.6),
//               ),

//               Padding(
//                 padding: const EdgeInsets.only(top: 30, left: 10), // Space before the container
//                 child: Container(
//                   width: 150,
//                   height: 150,
//                   alignment: Alignment.center,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Jing Ying",
//                         style: TextStyle(
//                           fontSize: 19,
//                           fontWeight: FontWeight.w900,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       Container(
//                         width: 128,  // Width and height should match the CircleAvatar's diameter (2 * radius)
//                         height: 128,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Color(0xFF467BA1),  // Border color
//                             width: 3.0,  // Border width
//                           ),
//                         ),
//                         child: userData['profileImage'] != null
//                             ? CircleAvatar(
//                                 radius: 64,
//                                 backgroundImage: NetworkImage(userData['profileImage']),
//                               )
//                             : const CircleAvatar(
//                                 radius: 64,
//                                 backgroundImage: AssetImage("images/profile.png"),
//                                 backgroundColor: Colors.white,
//                               ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),

//               Positioned(
//                 top: 55,
//                 left: 30,
//                 child: Image(
//                   image: const AssetImage("images/route line.png"),
//                   height: 200,
//                   width: 340,
//                 ),
//               ),

//               Positioned(
//                 top: 40,
//                 left: 320,
//                 child: Column(
//                   children: [
//                     const Text(
//                       "Setting",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w900,
//                         color: Colors.black,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Image.asset(
//                       'images/location-pin.png',
//                       width: 50,
//                       height: 50,
//                     ),
//                   ],
//                 ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.only(top: 260, left: 10, right: 10), // Space before the container
//                 child: Column(
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         // Handle navigation or other actions here.
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           side: const BorderSide(color: Color(0xFF467BA1), width: 3),
//                         ),
//                         minimumSize: const Size(120, 65),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: const [
//                           Icon(
//                             Icons.lock,
//                             color: Colors.black,
//                             size: 25,
//                           ),
//                           SizedBox(width: 15),

//                           SizedBox(
//                             width: 270,
//                             child: Text(
//                               "Change Password",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
                          
//                           Icon(
//                             Icons.arrow_forward_rounded,
//                             color: Colors.black,
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: 20),

//                     ElevatedButton(
//                       onPressed: () {
//                         // Handle navigation or other actions here.
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           side: const BorderSide(color: Color(0xFF467BA1), width: 3),
//                         ),
//                         minimumSize: const Size(120, 65),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: const [
//                           Icon(
//                             Icons.delete_forever,
//                             color: Colors.black,
//                             size: 25,
//                           ),
//                           SizedBox(width: 15),

//                           SizedBox(
//                             width: 270,
//                             child: Text(
//                               "Delete Account",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
                          
//                           Icon(
//                             Icons.arrow_forward_rounded,
//                             color: Colors.black,
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: 20),

//                     ElevatedButton(
//                       onPressed: () {
//                         // Handle navigation or other actions here.
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           side: const BorderSide(color: Color(0xFF467BA1), width: 3),
//                         ),
//                         minimumSize: const Size(120, 65),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: const [
//                           ImageIcon(
//                             AssetImage("images/leave_feedback.png"),  // The path to your image asset
//                             color: Colors.black,  // Set the color of the image icon
//                             size: 25,  // Set the size of the image icon
//                           ),

//                           SizedBox(width: 15),

//                           SizedBox(
//                             width: 270,
//                             child: Text(
//                               "Leave a feedback",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
                          
//                           Icon(
//                             Icons.arrow_forward_rounded,
//                             color: Colors.black,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )
//               ),
//             ],
//           );
//         }
//       )
//     );
//   }
// }
