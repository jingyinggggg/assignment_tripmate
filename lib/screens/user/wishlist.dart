import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/user/viewTourDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  final String userID;

  const WishlistScreen({super.key, required this.userID});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> with SingleTickerProviderStateMixin{

  int currentPageIndex = 0;
  List<TourPackage> _tourPackage = [];
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    fetchTPList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchTPList() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Step 1: Fetch wishlist documents for the current user
      CollectionReference wishlistRef = FirebaseFirestore.instance.collection('wishlist');
      QuerySnapshot wishlistSnapshot = await wishlistRef.where('userID', isEqualTo: widget.userID).get();

      List<String> tourPackageIDs = [];

      // Step 2: Loop through each wishlist document and fetch tourPackageId from the subcollection
      for (var wishlistDoc in wishlistSnapshot.docs) {
        CollectionReference tourPackageSubcollection = wishlistRef.doc(wishlistDoc.id).collection('tourPackage');
        QuerySnapshot tourPackageSnapshot = await tourPackageSubcollection.get();
        
        // Extract the tourPackageId from each document in the subcollection
        for (var tourDoc in tourPackageSnapshot.docs) {
          String tourPackageId = tourDoc['tourPackageId'] as String;
          tourPackageIDs.add(tourPackageId);
        }
      }

      // Step 3: Fetch tour packages from 'tourPackage' collection using the retrieved IDs
      if (tourPackageIDs.isNotEmpty) {
        CollectionReference tourPackagesRef = FirebaseFirestore.instance.collection('tourPackage');
        QuerySnapshot tourPackageSnapshot = await tourPackagesRef.where(FieldPath.documentId, whereIn: tourPackageIDs).get();

        // Step 4: Map the fetched documents to TourPackage objects and update the state
        setState(() {
          _tourPackage = tourPackageSnapshot.docs.map((doc) => TourPackage.fromFirestore(doc)).toList();
          isLoading = false;
        });
      } else {
        // Handle case where no tour packages are found in wishlist
        setState(() {
          _tourPackage = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching wishlist: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext content) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Wishlist"),
          centerTitle: true,
          backgroundColor: const Color(0xFF749CB9),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Inika',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ),
        body: Column(
          children: [

            const TabBar(
              labelColor: Color(0xFF467BA1),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF467BA1),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
              tabs: [
                Tab(text: "Tour Package"),
                Tab(text: "Car Rental"),
                Tab(text: "Local Buddy"),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _tourPackage.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              child: ListView.builder(
                                itemCount: _tourPackage.length,
                                itemBuilder: (context, index) {
                                  return TPComponent(tourPackage: _tourPackage[index]);
                                }
                              ),
                            )
                          : Center(child: Text('No tour packages found in your wishlist')),
                  Center(child: Icon(Icons.car_rental)),
                  Center(child: Icon(Icons.person)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget TPComponent({required TourPackage tourPackage}) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => ViewTourDetailsScreen(userId: widget.userID, countryName: tourPackage.countryName, cityName: tourPackage.cityName, tourID: tourPackage.tourID))
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 20, bottom: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1.5))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Wrap this inner Row with Expanded to make sure it takes the available space
            Expanded(
              child: Row(
                children: [
                  // Image container with fixed width and height
                  Container(
                    width: getScreenWidth(context) * 0.18,
                    height: getScreenHeight(context) * 0.13,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(tourPackage.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Text widget wrapped in Expanded to take remaining space
                  Expanded(
                    child: Text(
                      tourPackage.tourName, 
                      style: TextStyle(
                        color: Colors.black, 
                        fontWeight: FontWeight.bold, 
                        fontSize: defaultLabelFontSize,
                      ),
                      overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

}

class TourPackage {
  final String tourName;
  final String tourID;
  final String image;
  final String countryName;
  final String cityName;

  // Named parameters constructor
  TourPackage({
    required this.tourName,
    required this.tourID,
    required this.image,
    required this.countryName,
    required this.cityName
  });

  // Add a factory constructor to convert Firestore document to TourPackage object
  factory TourPackage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return TourPackage(
      tourID: doc.id, // Firestore document ID
      tourName: data['tourName'] ?? '',
      image: data['tourCover'] ?? '',
      countryName: data['countryName'] ?? '',
      cityName: data['cityName'] ?? ''
    );
  }
}

