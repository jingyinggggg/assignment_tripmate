// import 'package:assignment_tripmate/constants.dart';
// import 'package:assignment_tripmate/screens/user/localBuddyHomepage.dart';
// import 'package:assignment_tripmate/utils.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class LocalBuddyRegistrationScreen extends StatefulWidget {
//   final String userId;

//   const LocalBuddyRegistrationScreen({
//     super.key,
//     required this.userId,
//   });

//   @override
//   State<StatefulWidget> createState() => _LocalBuddyHomepageScreenState();
// }

// class _LocalBuddyHomepageScreenState extends State<LocalBuddyRegistrationScreen>{
//   TextEditingController _occupationController = TextEditingController();
//   TextEditingController _languageSpokenController = TextEditingController();
//   TextEditingController _locationController = TextEditingController();
//   TextEditingController _pricingController = TextEditingController();
//   TextEditingController _previousExperienceController = TextEditingController();
//   TextEditingController _bioController = TextEditingController();

//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserLocation();
//   }

//   Future<void> fetchUserLocation() async {
//     try {
//       QuerySnapshot userQuery = await FirebaseFirestore.instance
//         .collection('users')
//         .where('id', isEqualTo: widget.userId)
//         .limit(1)
//         .get();
      
//       DocumentSnapshot userDoc = userQuery.docs.first;
//       var userData = userDoc.data() as Map<String, dynamic>;

//       setState(() {
//         _locationController.text = userData['address'];
//       });
//     } catch (e) {
//       print("Error fetching user details: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Local Buddy Registration"),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF749CB9),
//         titleTextStyle: const TextStyle(
//           color: Colors.white,
//           fontFamily: 'Inika',
//           fontWeight: FontWeight.bold,
//           fontSize: defaultAppBarTitleFontSize,
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => LocalBuddyHomepageScreen(userId: widget.userId)),
//             );
//           },
//         ),
//       ),
//       body: ListView( // Use ListView instead of Column
//         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         children: [
//           Text(
//             'Background Information',
//             style: TextStyle(
//               fontWeight: FontWeight.w900,
//               color: Colors.black,
//               fontSize: defaultLabelFontSize,
//             ),
//           ),
//           SizedBox(height: 20),
//           buildTextField(_occupationController, 'Enter your occupation', 'Occupation'),
//           SizedBox(height: 20),
//           buildTextField(_locationController, 'Enter your location', 'Location', readOnly: true),
//           SizedBox(height: 20),
//           buildTextField(_languageSpokenController, 'E.g. English, Mandarin, Hokkien', 'Languages Spoken'),
//           SizedBox(height: 30),
//           Text(
//             'Availability',
//             style: TextStyle(
//               fontWeight: FontWeight.w900,
//               color: Colors.black,
//               fontSize: defaultLabelFontSize,
//             ),
//           ),
//           SizedBox(height: 20),
//           buildTextField(_pricingController, 'Enter price', 'Price (RM/per day)', isIntField: true),
//           SizedBox(height: 30),
//           Text(
//             'Safety and Security',
//             style: TextStyle(
//               fontWeight: FontWeight.w900,
//               color: Colors.black,
//               fontSize: defaultLabelFontSize,
//             ),
//           ),
//           SizedBox(height: 30),
//           Text(
//             'Additional Information',
//             style: TextStyle(
//               fontWeight: FontWeight.w900,
//               color: Colors.black,
//               fontSize: defaultLabelFontSize,
//             ),
//           ),
//           SizedBox(height: 20),
//           buildTextField(_previousExperienceController, 'Enter your previous experience (if any)', 'Previous Experience as a Local Friend/Local Guide (if any)'),
//           SizedBox(height: 20),
//           buildTextField(_bioController, 'Enter your personal bio', 'Personal Bio/ Introduction'),
//           SizedBox(height: 30),
//           Container(
//             width: double.infinity,
//             height: getScreenHeight(context) * 0.08,
//             child: ElevatedButton(
//               onPressed: () {},
//               child: isLoading
//                 ? CircularProgressIndicator()
//                 : Text(
//                     'Submit',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF467BA1),
//                 textStyle: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }


//     Widget buildTextField(TextEditingController controller,String hintText, String label, {bool isIntField = false, readOnly = false}){
//     return TextField(
//       controller: controller,
//       style: const TextStyle(
//         fontWeight: FontWeight.w800,
//         fontSize: defaultFontSize,
//         overflow: TextOverflow.visible
//       ),
//       readOnly: readOnly,
//       maxLines: null,
//       textAlign: TextAlign.justify,
//       keyboardType: isIntField ? TextInputType.number : TextInputType.multiline,
//       decoration: InputDecoration(
//         hintText: hintText,
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             color: Color(0xFF467BA1),
//             width: 2.5,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             color: Color(0xFF467BA1),
//             width: 2.5,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             color: Color(0xFF467BA1),
//             width: 2.5,
//           ),
//         ),
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         labelStyle: const TextStyle(
//           fontSize: defaultLabelFontSize,
//           fontWeight: FontWeight.bold,
//           color: Colors.black87,
//           shadows: [
//             Shadow(
//               offset: Offset(0.5, 0.5),
//               color: Colors.black87,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }

import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/user/localBuddyHomepage.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LocalBuddyRegistrationScreen extends StatefulWidget {
  final String userId;

  const LocalBuddyRegistrationScreen({
    super.key,
    required this.userId,
  });

  @override
  State<StatefulWidget> createState() => _LocalBuddyHomepageScreenState();
}

class _LocalBuddyHomepageScreenState extends State<LocalBuddyRegistrationScreen> {
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _languageSpokenController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _pricingController = TextEditingController();
  TextEditingController _previousExperienceController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  bool isLoading = false;

  List<String> selectedDays = [];
  Map<String, TimeOfDay?> startTimes = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
    'Sunday': null,
  };

  Map<String, TimeOfDay?> endTimes = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
    'Sunday': null,
  };

  @override
  void initState() {
    super.initState();
    fetchUserLocation();
  }

  Future<void> fetchUserLocation() async {
    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: widget.userId)
          .limit(1)
          .get();

      DocumentSnapshot userDoc = userQuery.docs.first;
      var userData = userDoc.data() as Map<String, dynamic>;

      setState(() {
        _locationController.text = userData['address'];
      });
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  void toggleDaySelection(String day) {
    setState(() {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
        startTimes[day] = null;  // Reset start time when day is unselected
        endTimes[day] = null;    // Reset end time when day is unselected
      } else {
        selectedDays.add(day);
      }
    });
  }

  Future<void> selectStartTime(String day) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        startTimes[day] = selectedTime;
      });
    }
  }

  Future<void> selectEndTime(String day) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        endTimes[day] = selectedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Local Buddy Registration"),
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
              MaterialPageRoute(
                  builder: (context) =>
                      LocalBuddyHomepageScreen(userId: widget.userId)),
            );
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          Text(
            'Background Information',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontSize: defaultLabelFontSize,
            ),
          ),
          SizedBox(height: 20),
          buildTextField(_occupationController, 'Enter your occupation', 'Occupation'),
          SizedBox(height: 20),
          buildTextField(_locationController, 'Enter your location', 'Location', readOnly: true),
          SizedBox(height: 20),
          buildTextField(_languageSpokenController, 'E.g. English, Mandarin, Hokkien', 'Languages Spoken'),
          SizedBox(height: 30),

          // Availability Section
          Text(
            'Availability',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontSize: defaultLabelFontSize,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Select available days and set start and end times by clicking on the time fields.',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 10),
          Table(
            border: TableBorder.all(),
            columnWidths: {
              0: FixedColumnWidth(100), // Fixed width for days
            },
            children: [
              TableRow(
                children: [
                  Padding(padding: const EdgeInsets.all(8.0), child: Text('Day', style: TextStyle(fontSize: defaultFontSize, fontWeight: FontWeight.w800,),textAlign: TextAlign.center,)),
                  Padding(padding: const EdgeInsets.all(8.0), child: Text('Start Time', style: TextStyle(fontSize: defaultFontSize, fontWeight: FontWeight.w800,), textAlign: TextAlign.center,)),
                  Padding(padding: const EdgeInsets.all(8.0), child: Text('End Time', style: TextStyle(fontSize: defaultFontSize, fontWeight: FontWeight.w800,), textAlign: TextAlign.center,)),
                ],
              ),
              for (var day in startTimes.keys)
                TableRow(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: selectedDays.contains(day),
                          onChanged: (value) {
                            toggleDaySelection(day);
                          },
                        ),
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: defaultFontSize,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        if (selectedDays.contains(day)) {
                          selectStartTime(day); // Allow time selection when the day is selected
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.white,
                        child: Text(
                          startTimes[day] != null
                              ? '${startTimes[day]?.hour}:${startTimes[day]?.minute.toString().padLeft(2, '0')}'
                              : 'Start Time',
                          style: TextStyle(
                            color: startTimes[day] != null ? Colors.black : Colors.grey,
                            fontSize: defaultFontSize,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (selectedDays.contains(day)) {
                          selectEndTime(day); // Allow time selection when the day is selected
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.white,
                        child: Text(
                          endTimes[day] != null
                              ? '${endTimes[day]?.hour}:${endTimes[day]?.minute.toString().padLeft(2, '0')}'
                              : 'End Time',
                          style: TextStyle(
                            color: endTimes[day] != null ? Colors.black : Colors.grey,
                            fontSize: defaultFontSize,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 30),

          Text(
            'Safety and Security',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontSize: defaultLabelFontSize,
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Additional Information',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontSize: defaultLabelFontSize,
            ),
          ),
          SizedBox(height: 20),
          buildTextField(_previousExperienceController, 'Enter your previous experience (if any)', 'Previous Experience as a Local Friend/Local Guide (if any)'),
          SizedBox(height: 20),
          buildTextField(_bioController, 'Enter your personal bio', 'Personal Bio/ Introduction'),
          SizedBox(height: 30),
          Container(
            width: double.infinity,
            height: getScreenHeight(context) * 0.08,
            child: ElevatedButton(
              onPressed: () {},
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      'Submit',
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
          ),
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller,String hintText, String label, {bool isIntField = false, readOnly = false}){
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
}
