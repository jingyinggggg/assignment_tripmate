import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/user/homepage.dart';
import 'package:assignment_tripmate/screens/user/localBuddyBottomNavigationBar.dart';
import 'package:assignment_tripmate/screens/user/localBuddyEditInfo.dart';
import 'package:assignment_tripmate/screens/user/localBuddyMeScreen.dart';
import 'package:assignment_tripmate/screens/user/localBuddyRegistration.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LocalBuddyHomepageScreen extends StatefulWidget {
  final String userId;

  const LocalBuddyHomepageScreen({
    super.key,
    required this.userId,
  });

  @override
  State<StatefulWidget> createState() => _LocalBuddyHomepageScreenState();
}

class _LocalBuddyHomepageScreenState extends State<LocalBuddyHomepageScreen> {
  bool isLoading = false;
  bool isVerifyLoading = false;
  int? registrationStatus;
  int _currentIndex = 0;
  List<LocalBuddy> _localBuddyList = [];
  List<LocalBuddy> _foundedLocalBuddy = [];

  @override
  void initState() {
    super.initState();
    fetchLocalBuddyData();
    _checkCurrentUserStatus();
  }

  Future<void> fetchLocalBuddyData() async {
    setState(() {
      isLoading = true;
    });
    try {
      CollectionReference localBuddyRef = FirebaseFirestore.instance.collection('localBuddy');
      QuerySnapshot querySnapshot = await localBuddyRef.where('userID', isEqualTo: widget.userId).where('registrationStatus', isEqualTo: 3).get();

      List<LocalBuddy> _localBuddyList = querySnapshot.docs.map((doc) {
        return LocalBuddy(
          localBuddyID: doc['localBuddyID'], 
          localBuddyName: doc[''], 
          localBuddyImage: doc[''], 
          occupation: doc['occupation'], 
          status: doc['registrationStatus']
        );
      }).toList();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot snapshot = querySnapshot.docs.first;

        setState(() {
          registrationStatus = snapshot['registrationStatus'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching local buddy data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Handling bottom navigation bar tap
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the current index
    });
  }

  Future<void> _checkCurrentUserStatus() async {
    setState(() {
      isVerifyLoading = true;
    });
    try {
      // Fetch the user document based on the userId using a where condition
      QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
          .collection('localBuddy')
          .where('userID', isEqualTo: widget.userId) // Filter by userID
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        // If the query returns documents
        var userSnapshot = userQuerySnapshot.docs.first; // Get the first document
        registrationStatus = userSnapshot['registrationStatus'];

      } else {
        registrationStatus = null;
      }
    } catch (e) {
      print('Error checking current user: $e');
    } finally {
      setState(() {
        isVerifyLoading = false; // Stop loading
      });
    }
  }

  // Widget buildActionIcon() {
  //   return IconButton(
  //     onPressed: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => LocalBuddyRegistrationScreen(userId: widget.userId)),
  //       );
  //     },
  //     icon: Image.asset(
  //       registrationStatus == null ? 'images/apply-icon.png' : 'images/request.png',
  //       width: 25,
  //       height: 25,
  //     ),
  //     tooltip: registrationStatus == null ? "Apply for local buddy" : "Local Buddy Account",
  //   );
  // }

  @override
  Widget build(BuildContext context) {
      final List<Widget> _screens = [
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
            child: Container(
              height: 60,
              child: TextField(
                // onChanged: (value) => onSearch(value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  // fillColor: Color.fromARGB(255, 218, 232, 243),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueGrey, width: 2), // Set the border color to black
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueGrey, width: 2), // Black border when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF467BA1), width: 2), // Black border when focused
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red, width: 2), // Red border for error state
                  ),
                  hintText: "Search local buddy with destination...",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Your screen 2
      registrationStatus == 2 ? LocalBuddyEditInfoScreen(userId: widget.userId) : LocalBuddyMeScreen(userId: widget.userId,),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Local Buddy"),
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
              MaterialPageRoute(builder: (context) => UserHomepageScreen(userId: widget.userId)),
            );
          },
        ),
        // actions: [
        //   isLoading ? CircularProgressIndicator() : buildActionIcon(),
        // ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: LocalBuddyCustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        // selectedItemColor: Colors.white,
        // unselectedItemColor: Colors.black,
        // backgroundColor: Color(0xFF749CB9),
      ),
    );
  }

  Widget buildInfoContainer({required AssetImage image, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: image, width: 18, height: 18),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: defaultCarRentalFontSize,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
