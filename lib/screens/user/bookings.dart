import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
// import 'package:assignment_tripmate/customerModel.dart';
import 'package:assignment_tripmate/invoiceModel.dart';
import 'package:assignment_tripmate/pdf_invoice_api.dart';
import 'package:assignment_tripmate/screens/user/bookingDetails.dart';
import 'package:assignment_tripmate/screens/user/homepage.dart';
// import 'package:assignment_tripmate/supplierModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:http/http.dart' as http;
import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingsScreen extends StatefulWidget {
  final String userID;

  const BookingsScreen({super.key, required this.userID});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin{
  List<tourBooking> _tourBookingCompleted = [];
  List<tourBooking> _tourBookingUpcoming = [];
  List<tourBooking> _tourBookingCanceled = [];
  List<carRentalBooking> _carRentalBookingCompleted = [];
  List<carRentalBooking> _carRentalBookingUpcoming = [];
  List<carRentalBooking> _carRentalBookingCanceled = [];
  List<localBuddyBooking> _localBuddyBookingCompleted = [];
  List<localBuddyBooking> _localBuddyBookingUpcoming = [];
  List<localBuddyBooking> _localBuddyBookingCanceled = [];
  Map<String, dynamic>? userData;
  bool isFetchingTourPackage = false;
  bool isFetchingCarRental = false;
  bool isFetchingLocalBuddy = false;
  bool isCancelTourBooking = false;
  bool isCancelCarRentalBooking = false;
  bool isCancelLocalBuddyBooking = false;
  bool isPayingBalance = false;
  int _outerTabIndex = 0;  // For the outer Upcoming, Completed, Canceled
  int _innerTabIndex = 0;  // For the inner Tour Package, Car Rental, Local Buddy
  TextEditingController _cancelTourBookingController = TextEditingController();
  TextEditingController _cancelCarRentalBookingController = TextEditingController();
  TextEditingController _cancelLocalBookingController = TextEditingController();
  bool isSelectingImage = false;
  Uint8List? _transferProof;
  String? uploadedProof;
  final TextEditingController _proofNameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();


  @override
  void initState(){
    super.initState();
    _fetchUserData();
    _fetchTourBooking();
    _fetchCarRentalBooking();
    _fetchLocalBuddyBooking();
  }

  @override
  void dispose() {
    super.dispose();
  }

    // Encryption helper function
  String encryptText(String text) {
    final key = encrypt.Key.fromUtf8('16CharactersLong');
    final iv = encrypt.IV.fromSecureRandom(16); // Generate a random IV for each encryption
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(text, iv: iv);
    // Combine IV and encrypted text with a delimiter
    return "${iv.base64}:${encrypted.base64}";
  }


  Future<void>_fetchUserData() async{
    try{
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(widget.userID);
      DocumentSnapshot userSnap = await userRef.get();

      if(userSnap.exists){
        Map<String, dynamic>? data = userSnap.data() as Map<String, dynamic>?;

        setState(() {
          userData = data;
        });
      }
    } catch(e){
      print("Error fetching user data: $e");
    }
  }

  // Fetch tour bookings
  Future<void> _fetchTourBooking() async {
    setState(() {
      isFetchingTourPackage = true;
    });

    try {
      CollectionReference upTourBookingRef = FirebaseFirestore.instance.collection('tourBooking');
      QuerySnapshot upTourBookingSnapshot = await upTourBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 0)
          .orderBy('bookingCreateTime', descending: true)
          .get();

      // Initialize an empty list for upcoming tour bookings
      List<tourBooking> tourBookings = [];

      if (upTourBookingSnapshot.docs.isNotEmpty) {
        for (var tourDoc in upTourBookingSnapshot.docs) {
          String tourID = tourDoc['tourID'] as String;

          // Fetch tour details
          DocumentSnapshot tourSnapshot = await FirebaseFirestore.instance.collection('tourPackage').doc(tourID).get();

          if (tourSnapshot.exists) {
            String tourName = tourSnapshot['tourName'] as String;
            String tourImage = tourSnapshot['tourCover'] as String;
            String agentID = tourSnapshot['agentID'] as String;  // Get the agentID

            // Fetch travel agent details using agentID
            DocumentSnapshot agentSnapshot = await FirebaseFirestore.instance.collection('travelAgent').doc(agentID).get();

            if (agentSnapshot.exists) {
              String agencyName = agentSnapshot['companyName'] as String;
              String agencyAddress = agentSnapshot['companyAddress'] as String;

              // Create a tourBooking object and add tour and agent details
              tourBooking tourBook = tourBooking.fromFirestore(tourDoc);
              tourBook.tourName = tourName;
              tourBook.tourImage = tourImage;
              tourBook.agencyName = agencyName;    // Add agency name
              tourBook.agencyAddress = agencyAddress;  // Add agency address

              tourBookings.add(tourBook);
            }
          }
        }
        setState(() {
          _tourBookingUpcoming = tourBookings;
        });
      } else {
        setState(() {
          _tourBookingCompleted = [];
        });
      }

      CollectionReference comTourBookingRef = FirebaseFirestore.instance.collection('tourBooking');
      QuerySnapshot comTourBookingSnapshot = await comTourBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 1)
          // .orderBy('bookingCreateTime', descending: true)
          .get();

      // Initialize an empty list for completed tour bookings
      List<tourBooking> comTourBookings = [];

      if (comTourBookingSnapshot.docs.isNotEmpty) {
        for (var comTourDoc in comTourBookingSnapshot.docs) {
          String comTourID = comTourDoc['tourID'] as String;

          // Fetch tour details
          DocumentSnapshot tourSnapshot = await FirebaseFirestore.instance.collection('tourPackage').doc(comTourID).get();

          if (tourSnapshot.exists) {
            String tourName = tourSnapshot['tourName'] as String;
            String tourImage = tourSnapshot['tourCover'] as String;
            String agentID = tourSnapshot['agentID'] as String;  // Get the agentID

            // Fetch travel agent details using agentID
            DocumentSnapshot agentSnapshot = await FirebaseFirestore.instance.collection('travelAgent').doc(agentID).get();

            if (agentSnapshot.exists) {
              String agencyName = agentSnapshot['companyName'] as String;
              String agencyAddress = agentSnapshot['companyAddress'] as String;

              // Create a tourBooking object and add tour and agent details
              tourBooking tourBook = tourBooking.fromFirestore(comTourDoc);
              tourBook.tourName = tourName;
              tourBook.tourImage = tourImage;
              tourBook.agencyName = agencyName;    // Add agency name
              tourBook.agencyAddress = agencyAddress;  // Add agency address

              comTourBookings.add(tourBook);
            }
          }
        }

        setState(() {
          _tourBookingCompleted = comTourBookings;
        });
      } else {
        setState(() {
          _tourBookingCompleted = [];
        });
      }

      CollectionReference canTourBookingRef = FirebaseFirestore.instance.collection('tourBooking');
      QuerySnapshot canTourBookingSnapshot = await canTourBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 2)
          // .orderBy('bookingCreateTime', descending: true)
          .get();

      // Initialize an empty list for completed tour bookings
      List<tourBooking> canTourBookings = [];

      if (canTourBookingSnapshot.docs.isNotEmpty) {
        for (var canTourDoc in canTourBookingSnapshot.docs) {
          String canTourID = canTourDoc['tourID'] as String;

          // Fetch tour details
          DocumentSnapshot tourSnapshot = await FirebaseFirestore.instance.collection('tourPackage').doc(canTourID).get();

          if (tourSnapshot.exists) {
            String tourName = tourSnapshot['tourName'] as String;
            String tourImage = tourSnapshot['tourCover'] as String;
            String agentID = tourSnapshot['agentID'] as String;  // Get the agentID

            // Fetch travel agent details using agentID
            DocumentSnapshot agentSnapshot = await FirebaseFirestore.instance.collection('travelAgent').doc(agentID).get();

            if (agentSnapshot.exists) {
              String agencyName = agentSnapshot['companyName'] as String;
              String agencyAddress = agentSnapshot['companyAddress'] as String;

              // Create a tourBooking object and add tour and agent details
              tourBooking tourBook = tourBooking.fromFirestore(canTourDoc);
              tourBook.tourName = tourName;
              tourBook.tourImage = tourImage;
              tourBook.agencyName = agencyName;    // Add agency name
              tourBook.agencyAddress = agencyAddress;  // Add agency address

              canTourBookings.add(tourBook);
            }
          }
        }

        setState(() {
          _tourBookingCanceled = canTourBookings;
        });
      } else {
        setState(() {
          _tourBookingCanceled = [];
        });
      }

      setState(() {
        isFetchingTourPackage = false;
      });
    } catch (e) {
      print('Error fetching booking: $e');
      setState(() {
        isFetchingTourPackage = false;
      });
    }
  }

  // Fetch car rental bookings
  Future<void> _fetchCarRentalBooking() async {
    setState(() {
      isFetchingCarRental = true;
    });

    try {
      CollectionReference upCarRentalBookingRef = FirebaseFirestore.instance.collection('carRentalBooking');
      QuerySnapshot upCarRentalBookingSnapshot = await upCarRentalBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 0)
          .orderBy('bookingCreateTime', descending: true)
          .get();

      // Initialize an empty list for upcoming car rental bookings
      List<carRentalBooking> upCarRentalBookings = [];

      if (upCarRentalBookingSnapshot.docs.isNotEmpty) {
        for (var upCarDoc in upCarRentalBookingSnapshot.docs) {
          String upCarID = upCarDoc['carID'] as String;

          // Fetch car details
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('car_rental').doc(upCarID).get();

          if (documentSnapshot.exists) {
            String carName = documentSnapshot['carModel'] as String;
            String carImage = documentSnapshot['carImage'] as String;

            // Create a carRentalBooking object and add car rental details
            carRentalBooking carRentalBook = carRentalBooking.fromFirestore(upCarDoc);
            carRentalBook.carName = carName;
            carRentalBook.carImage = carImage;

            upCarRentalBookings.add(carRentalBook);
          }
        }

        // Update state with the list of upcoming bookings
        setState(() {
          _carRentalBookingUpcoming = upCarRentalBookings;
        });
      } else {
        // If no results found, set _tourBookingUpcoming to an empty list
        setState(() {
          _carRentalBookingUpcoming = [];
        });
      }

      CollectionReference comCarRentalBookingRef = FirebaseFirestore.instance.collection('carRentalBooking');
      QuerySnapshot comCarRentalBookingSnapshot = await comCarRentalBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 1)
          // .orderBy('bookingCreateTime', descending: true)
          .get();

      List<carRentalBooking> comCarRentalBookings = [];

      if (comCarRentalBookingSnapshot.docs.isNotEmpty) {
        for (var comCarDoc in comCarRentalBookingSnapshot.docs) {
          String comCarID = comCarDoc['carID'] as String;

          // Fetch car details
          DocumentSnapshot comDocumentSnapshot = await FirebaseFirestore.instance.collection('car_rental').doc(comCarID).get();

          if (comDocumentSnapshot.exists) {
            String comCarName = comDocumentSnapshot['carModel'] as String;
            String comCarImage = comDocumentSnapshot['carImage'] as String;

            // Create a carRentalBooking object and add car rental details
            carRentalBooking comCarRentalBook = carRentalBooking.fromFirestore(comCarDoc);
            comCarRentalBook.carName = comCarName;
            comCarRentalBook.carImage = comCarImage;

            comCarRentalBookings.add(comCarRentalBook);
          }
        }

        setState(() {
          _carRentalBookingCompleted = comCarRentalBookings;
        });
      } else {
        setState(() {
          _carRentalBookingCompleted = [];
        });
      }

      CollectionReference canCarRentalBookingRef = FirebaseFirestore.instance.collection('carRentalBooking');
      QuerySnapshot canCarRentalBookingSnapshot = await canCarRentalBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 2)
          // .orderBy('bookingCreateTime', descending: true)
          .get();

      List<carRentalBooking> canCarRentalBookings = [];

      if (canCarRentalBookingSnapshot.docs.isNotEmpty) {
        for (var canCarDoc in canCarRentalBookingSnapshot.docs) {
          String canCarID = canCarDoc['carID'] as String;

          // Fetch car details
          DocumentSnapshot canDocumentSnapshot = await FirebaseFirestore.instance.collection('car_rental').doc(canCarID).get();

          if (canDocumentSnapshot.exists) {
            String canCarName = canDocumentSnapshot['carModel'] as String;
            String canCarImage = canDocumentSnapshot['carImage'] as String;

            // Create a carRentalBooking object and add car rental details
            carRentalBooking canCarRentalBook = carRentalBooking.fromFirestore(canCarDoc);
            canCarRentalBook.carName = canCarName;
            canCarRentalBook.carImage = canCarImage;

            canCarRentalBookings.add(canCarRentalBook);
          }
        }

        setState(() {
          _carRentalBookingCanceled = canCarRentalBookings;
        });
      } else {
        // If no results found, set _tourBookingUpcoming to an empty list
        setState(() {
          _carRentalBookingCanceled = [];
        });
      }

      setState(() {
        isFetchingCarRental = false;
      });
    } catch (e) {
      print('Error fetching booking: $e');
      setState(() {
        isFetchingCarRental = false;
      });
    }
  }

  // Fetch local buddy bookings
  Future<void> _fetchLocalBuddyBooking() async {
    setState(() {
      isFetchingLocalBuddy = true;
    });

    try {
      CollectionReference upLocalBuddyBookingRef = FirebaseFirestore.instance.collection('localBuddyBooking');
      QuerySnapshot upLocalBuddyBookingSnapshot = await upLocalBuddyBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 0)
          .orderBy('bookingCreateTime', descending: true)
          .get();

      List<String> localBuddyIDs = [];
      List<localBuddyBooking> upLocalBuddyBookings = [];

      if (upLocalBuddyBookingSnapshot.docs.isNotEmpty) {
        // Inside the loop for the localBuddyBooking collection
        for (var upLBDoc in upLocalBuddyBookingSnapshot.docs) {
          localBuddyBooking localBuddyBooks = localBuddyBooking.fromFirestore(upLBDoc); // Use the booking doc here
          
          String localBuddyID = upLBDoc['localBuddyID'] as String;

          // Fetch the local buddy details
          DocumentSnapshot localBuddyDoc = await FirebaseFirestore.instance.collection('localBuddy').doc(localBuddyID).get();
          String userId = localBuddyDoc['userID'] as String;
          String locationArea = localBuddyDoc['locationArea'] as String;

          // Fetch user details including profile image from 'users' collection
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
          String profileImage = userDoc['profileImage'] as String;
          String localBuddyName = userDoc['name'] as String;

          // Assign the user details to the localBuddyBooking object
          localBuddyBooks.localBuddyName = localBuddyName;
          localBuddyBooks.localBuddyImage = profileImage;
          localBuddyBooks.locationArea = locationArea;

          upLocalBuddyBookings.add(localBuddyBooks);
        }
        setState(() {
          _localBuddyBookingUpcoming = upLocalBuddyBookings;
        });
      } else {
        setState(() {
          _localBuddyBookingUpcoming = [];
        });
      }

      CollectionReference comLocalBuddyBookingRef = FirebaseFirestore.instance.collection('localBuddyBooking');
      QuerySnapshot comLocalBuddyBookingSnapshot = await upLocalBuddyBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 1)
          // .orderBy('bookingCreateTime', descending: true)
          .get();

      List<String> comlocalBuddyIDs = [];
      List<localBuddyBooking> comLocalBuddyBookings = [];

      if (comLocalBuddyBookingSnapshot.docs.isNotEmpty) {
        // Inside the loop for the localBuddyBooking collection
        for (var comLBDoc in comLocalBuddyBookingSnapshot.docs) {
          localBuddyBooking comlocalBuddyBooks = localBuddyBooking.fromFirestore(comLBDoc); // Use the booking doc here
          
          String comlocalBuddyID = comLBDoc['localBuddyID'] as String;

          // Fetch the local buddy details
          DocumentSnapshot comlocalBuddyDoc = await FirebaseFirestore.instance.collection('localBuddy').doc(comlocalBuddyID).get();
          String userId = comlocalBuddyDoc['userID'] as String;
          String locationArea = comlocalBuddyDoc['locationArea'] as String;

          // Fetch user details including profile image from 'users' collection
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
          String profileImage = userDoc['profileImage'] as String;
          String localBuddyName = userDoc['name'] as String;

          // Assign the user details to the localBuddyBooking object
          comlocalBuddyBooks.localBuddyName = localBuddyName;
          comlocalBuddyBooks.localBuddyImage = profileImage;
          comlocalBuddyBooks.locationArea = locationArea;

          comLocalBuddyBookings.add(comlocalBuddyBooks);
        }
        setState(() {
          _localBuddyBookingCompleted = comLocalBuddyBookings;
        });
      } else {
        setState(() {
          _localBuddyBookingCompleted = [];
        });
      }

      CollectionReference canLocalBuddyBookingRef = FirebaseFirestore.instance.collection('localBuddyBooking');
      QuerySnapshot canLocalBuddyBookingSnapshot = await upLocalBuddyBookingRef
          .where('userID', isEqualTo: widget.userID)
          .where('bookingStatus', isEqualTo: 2)
          // .orderBy('bookingCreateTime', descending: true)
          .get();

      List<String> canlocalBuddyIDs = [];
      List<localBuddyBooking> canLocalBuddyBookings = [];

      if (canLocalBuddyBookingSnapshot.docs.isNotEmpty) {
        // Inside the loop for the localBuddyBooking collection
        for (var canLBDoc in canLocalBuddyBookingSnapshot.docs) {
          localBuddyBooking canlocalBuddyBooks = localBuddyBooking.fromFirestore(canLBDoc); // Use the booking doc here
          
          String canlocalBuddyID = canLBDoc['localBuddyID'] as String;

          // Fetch the local buddy details
          DocumentSnapshot canlocalBuddyDoc = await FirebaseFirestore.instance.collection('localBuddy').doc(canlocalBuddyID).get();
          String userId = canlocalBuddyDoc['userID'] as String;
          String locationArea = canlocalBuddyDoc['locationArea'] as String;

          // Fetch user details including profile image from 'users' collection
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
          String profileImage = userDoc['profileImage'] as String;
          String localBuddyName = userDoc['name'] as String;

          // Assign the user details to the localBuddyBooking object
          canlocalBuddyBooks.localBuddyName = localBuddyName;
          canlocalBuddyBooks.localBuddyImage = profileImage;
          canlocalBuddyBooks.locationArea = locationArea;

          canLocalBuddyBookings.add(canlocalBuddyBooks);
        }
        setState(() {
          _localBuddyBookingCanceled = canLocalBuddyBookings;
        });
      } else {
        setState(() {
          _localBuddyBookingCanceled = [];
        });
      }

      setState(() {
        isFetchingLocalBuddy = false;
      });
    } catch (e) {
      print('Error fetching local buddy booking: $e');
      setState(() {
        isFetchingLocalBuddy = false;
      });
    }
  }

  Future<void>cancelTourBooking(String tourBookingID, String tourID, int slot, String dateRange, String cancelReason) async{
    setState(() {
      isCancelTourBooking = true;
    });
    try{
      await FirebaseFirestore.instance
        .collection('tourBooking')
        .doc(tourBookingID)
        .update({
          'bookingStatus': 2,
          'cancelReason': cancelReason
        });
      
      await FirebaseFirestore.instance.collection('notification').doc().set({
        'content': "Customer(${widget.userID}) has cancel the booking with booking id(${tourBookingID}). Please issue refund to the customer.",
        'isRead': 0,
        'type': "cancellation",
        'timestamp': DateTime.now(),
        'receiverID': "A1001"
      });

      final tpDoc = await FirebaseFirestore.instance.collection('tourPackage').doc(tourID).get();

      if (tpDoc.exists) {
        String agentID = tpDoc.data()?['agentID'] ?? "";

        await FirebaseFirestore.instance.collection('notification').doc().set({
          'content': "Customer(${widget.userID}) has cancel the booking with booking id(${tourBookingID}).",
          'isRead': 0,
          'type': "cancellation",
          'timestamp': DateTime.now(),
          'receiverID': agentID
        });
      }
      
      final tourPackageDoc = await FirebaseFirestore.instance.collection('tourPackage').doc(tourID).get();

      if (tourPackageDoc.exists) {
        List availability = tourPackageDoc.data()?['availability'] ?? [];

        // Find the availability entry for the selected date range
        for (int i = 0; i < availability.length; i++) {
          if (availability[i]['dateRange'] == dateRange) {
            int updatedSlots = availability[i]['slot'] + slot;

            // Update the slots for the specific date range
            availability[i]['slot'] = updatedSlots;

            // Save the updated availability back to Firestore
            await FirebaseFirestore.instance.collection('tourPackage').doc(tourID).update({
              'availability': availability,
            });

            break;
          }
        }
      }

      showCustomDialog(
        context: context, 
        title: "Successful", 
        content: "You have cancel the tour booking successfully.", 
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserHomepageScreen(userId: widget.userID, currentPageIndex: 3,))
          );
        }
      );

    }catch(e){
      showCustomDialog(
        context: context, 
        title: "Failed", 
        content: "Something went wrong! Please try again...", 
        onPressed: (){
          Navigator.pop(context);
        }
      );
    }finally{
      setState(() {
        isCancelTourBooking = false;
      });
    }
  }

  Future<void> cancelCarBooking(String carBookingID, String cancelReason) async {
    setState(() {
      isCancelCarRentalBooking = true;
    });
    
    try {
      // Step 1: Update the booking status and add cancellation reason
      await FirebaseFirestore.instance
          .collection('carRentalBooking')
          .doc(carBookingID)
          .update({
            'bookingStatus': 2,
            'cancelReason': cancelReason,
          });

      // Step 2: Retrieve carID from carRentalBooking
      final carBookingDoc = await FirebaseFirestore.instance
          .collection('carRentalBooking')
          .doc(carBookingID)
          .get();

      if (carBookingDoc.exists) {
        String carID = carBookingDoc.data()?['carID'] ?? "";

        // Step 3: Retrieve agentID from car_rental collection using carID
        final carDoc = await FirebaseFirestore.instance.collection('car_rental').doc(carID).get();

        if (carDoc.exists) {
          String agentID = carDoc.data()?['agencyID'] ?? "";

          await FirebaseFirestore.instance.collection('notification').doc().set({
            'content': "Customer(${widget.userID}) has cancelled the car rental booking with booking id(${carBookingID}).",
            'isRead': 0,
            'type': "cancellation",
            'timestamp': DateTime.now(),
            'receiverID': agentID,
          });
        }
      }

      await FirebaseFirestore.instance.collection('notification').doc().set({
        'content': "Customer(${widget.userID}) has cancelled the booking with booking id(${carBookingID}). Please issue a refund to the customer.",
        'isRead': 0,
        'type': "cancellation",
        'timestamp': DateTime.now(),
        'receiverID': "A1001",  
      });

      // Step 6: Show success dialog
      showCustomDialog(
        context: context, 
        title: "Successful", 
        content: "You have cancelled the car rental booking successfully. Please wait for admin to proceed with your refund.", 
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserHomepageScreen(userId: widget.userID, currentPageIndex: 3))
          );
        },
      );

    } catch (e) {
      // Show failure dialog
      showCustomDialog(
        context: context, 
        title: "Failed", 
        content: "Something went wrong! Please try again...", 
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } finally {
      setState(() {
        isCancelCarRentalBooking = false;
      });
    }
  }


  Future<void>cancelLocalBuddyBooking(String localBuddyBookingID, String cancelReason, String bankName, String accountName, String accountNumber) async{
    setState(() {
      isCancelLocalBuddyBooking = true;
    });
    try{
      // Encrypt bank details
      final encryptedBankName = encryptText(_bankNameController.text);
      final encryptedAccountName = encryptText(_accountNameController.text);
      final encryptedAccountNumber = encryptText(_accountNumberController.text);

      await FirebaseFirestore.instance
        .collection('localBuddyBooking')
        .doc(localBuddyBookingID)
        .update({
          'bookingStatus': 2,
          'cancelReason': cancelReason,
          'bankName': encryptedBankName,
          'accountName': encryptedAccountName,
          'accountNumber': encryptedAccountNumber,
        });
      
      final localBuddyBookingDoc = await FirebaseFirestore.instance
          .collection('localBuddyBooking')
          .doc(localBuddyBookingID)
          .get();

      if (localBuddyBookingDoc.exists) {
        String localBuddyID = localBuddyBookingDoc.data()?['localBuddyID'] ?? "";

        // Step 3: Retrieve agentID from car_rental collection using carID
        final lbDoc = await FirebaseFirestore.instance.collection('localBuddy').doc(localBuddyID).get();

        if (lbDoc.exists) {
          String userID = lbDoc.data()?['userID'] ?? "";

          await FirebaseFirestore.instance.collection('notification').doc().set({
            'content': "Customer(${widget.userID}) has cancelled the your local buddy slot with booking id(${localBuddyBookingID}).",
            'isRead': 0,
            'type': "cancellation",
            'timestamp': DateTime.now(),
            'receiverID': userID,
          });
        }
      }

      await FirebaseFirestore.instance.collection('notification').doc().set({
        'content': "Customer(${widget.userID}) has cancelled the booking with booking id(${localBuddyBookingID}). Please issue a refund to the customer.",
        'isRead': 0,
        'type': "cancellation",
        'timestamp': DateTime.now(),
        'receiverID': "A1001",  
      });

      showCustomDialog(
        context: context, 
        title: "Successful", 
        content: "You have cancel the local buddy booking successfully. Please wait for admin to proceed your refund.", 
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserHomepageScreen(userId: widget.userID, currentPageIndex: 3,))
          );
        }
      );

    }catch(e){
      showCustomDialog(
        context: context, 
        title: "Failed", 
        content: "Something went wrong! Please try again...", 
        onPressed: (){
          Navigator.pop(context);
        }
      );
    }finally{
      setState(() {
        isCancelCarRentalBooking = false;
      });
    }
  }



  Future<void> payBalanceTour(String tourBookingID, String companyName, String companyAddress, double totalPrice) async{
    setState(() {
      isPayingBalance = true;
    });
    try{
      String fileName = "balanceTransferProof.jpg";

      if(_transferProof != null){
        uploadedProof = await uploadImageToStorage("invoice/Tour Package/${widget.userID}/${tourBookingID}/$fileName", _transferProof!);

        await FirebaseFirestore.instance
        .collection('tourBooking')
        .doc(tourBookingID)
        .update({
          'fullyPaid' : 1,
          'balanceTransferProof': uploadedProof!
        });

        await FirebaseFirestore.instance.collection('notification').doc().set({
          'content': "Customer(${widget.userID}) has make full payment for the car rental package with booking id (${tourBookingID}). Please generate invoice for the customer.",
          'isRead': 0,
          'type': "invoice",
          'timestamp': DateTime.now(),
          'receiverID': "A1001"
        });

      }

      showCustomDialog(
        context: context, 
        title: "Payment Successful", 
        content: "You have pay the balance for this booking successfully. Please wait for the admin to process your booking and generate the invoice.", 
        onPressed: () async {
          // Close the payment successful dialog
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserHomepageScreen(
                userId: widget.userID,
                currentPageIndex: 3,
              ),
            ),
          );


          // Use Future.microtask to show the loading dialog after the previous dialog is closed
          // Future.microtask(() {
          //   showLoadingDialog(context, "Generating Invoice...");
          // });

          // final date = DateTime.now();
          // // final date = DateTime(2024, 10, 19);

          // final invoice = Invoice(
          //   supplier: Supplier(
          //     name: companyName,
          //     address: companyAddress,
          //   ),
          //   customer: Customer(
          //     name: userData!['name'],
          //     address: userData!['address'],
          //   ),
          //   info: InvoiceInfo(
          //     date: date,
          //     description: "You have paid the balance tour fee. Below is the invoice summary:",
          //     number: '${DateTime.now().year}-${tourBookingID}B',
          //   ),
          //   // Wrap the single InvoiceItem in a list
          //   items: [
          //     InvoiceItem(
          //       description: "Balance Tour Fee (Booking ID: ${tourBookingID})",
          //       quantity: 1,
          //       unitPrice: totalPrice.toInt(),
          //       total: totalPrice,
          //     ),
          //   ],
          // );

          // // Perform some async operation
          // await generateInvoice(tourBookingID, invoice, "Tour Package", "tourBooking", "balance_payment", false, false, false);

          // // After the operation is done, hide the loading dialog
          // Navigator.of(context).pop(); // This will close the loading dialog

          // // Navigate to the homepage after PDF viewer
          // Future.delayed(Duration(milliseconds: 500), () {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => UserHomepageScreen(
          //         userId: widget.userID,
          //         currentPageIndex: 3,
          //       ),
          //     ),
          //   );
          // });
        },
        textButton: "Done",
      );
    } catch(e){
      showCustomDialog(
        context: context, 
        title: "Failed", 
        content: "Something went wrong! Please try again...", 
        onPressed: () {
          Navigator.pop(context);
        }
      );
    } finally{
      isPayingBalance = false;
    }
  }

  void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please Wait'),
          content: Row(
            children: [
              CircularProgressIndicator(color: primaryColor,), // Loading indicator
              SizedBox(width: 20),
              Expanded(child: Text(message)),
            ],
          ),
        );
      },
    );
  }

  Future<String> uploadImageToStorage(String childName, Uint8List file) async{
  
    Reference ref = FirebaseStorage.instance.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> selectImage() async {
    setState(() {
      isSelectingImage = true;
    });

    Uint8List? img = await ImageUtils.selectImage(context);

    setState(() {
      _transferProof = img;
      _proofNameController.text = img != null ? 'Proof Uploaded' : 'No proof uploaded';
      isSelectingImage = false;
    });
  }

  void showPaymentOption(BuildContext context, String amount, Function onSubmit) {
    bool isProofUploaded = _proofNameController.text.isNotEmpty;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text("Bank Details"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max, // Change this to max
                  children: [
                    Text("Please transfer $amount to the following account:", textAlign: TextAlign.justify),
                    const SizedBox(height: 8),
                    const Text(
                      "Bank: Hong Leong Bank\nAccount Name: TripMate\nAccount Number: 1234567890",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        setDialogState(() {
                          isSelectingImage = true; // Start showing the loading indicator in the dialog
                        });

                        await selectImage();

                        // Check if proof is uploaded
                        setDialogState(() {
                          isSelectingImage = false; // Stop showing the loading indicator in the dialog
                          isProofUploaded = _proofNameController.text.isNotEmpty; // Update proof upload status
                        });
                      },
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Upload Transfer Proof"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: primaryColor, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "Proof: ${_proofNameController.text.isNotEmpty ? _proofNameController.text : "No proof uploaded"}",
                            style: const TextStyle(fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (isSelectingImage)
                          const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Close"),
                  style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (isProofUploaded) ? () {
                    Navigator.of(context).pop(); // Close the dialog
                    onSubmit(); // Call the provided function
                  } : null,
                  child: const Text("Submit"),
                  style: TextButton.styleFrom(
                    backgroundColor: (isProofUploaded) 
                      ? primaryColor 
                      : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Future<void> showPaymentOption(BuildContext context, String deposit, Function onOptionSelected) async {
  //   String? selectedPaymentOption; // To store the selected payment option

  //   await showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Select Payment Option', 
  //           style: TextStyle(
  //             fontSize: defaultLabelFontSize,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.black,
  //           ),
  //         ),
  //         content: StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return Container(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min, // To adjust based on content
  //                 children: <Widget>[
  //                   ListTile(
  //                     contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Remove default padding
  //                     leading: Transform.scale(
  //                       scale: 0.6, // Scale the radio size
  //                       child: Radio<String>(
  //                         value: "Touch'n Go",
  //                         groupValue: selectedPaymentOption,
  //                         activeColor: primaryColor, // Set the selected radio color to blue
  //                         onChanged: (String? value) {
  //                           setState(() {
  //                             selectedPaymentOption = value; // Update selected payment option
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                     title: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and icon
  //                       children: [
  //                         Text(
  //                           "Touch'n Go",
  //                           style: TextStyle(
  //                             fontSize: defaultFontSize,
  //                             fontWeight: FontWeight.w500,
  //                             color: Colors.black
  //                           ),
  //                         ),
  //                         Image(
  //                           image: AssetImage('images/TNG-eWallet.png'),
  //                           width: 40,
  //                           alignment: Alignment.centerRight,
  //                         ), 
  //                       ],
  //                     ),
  //                   ),

  //                   ListTile(
  //                     contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Remove default padding
  //                     leading: Transform.scale(
  //                       scale: 0.6, // Scale the radio size
  //                       child: Radio<String>(
  //                         value: 'Credit Card',
  //                         groupValue: selectedPaymentOption,
  //                         activeColor: primaryColor, // Set the selected radio color to blue
  //                         onChanged: (String? value) {
  //                           setState(() {
  //                             selectedPaymentOption = value; // Update selected payment option
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                     title: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and icon
  //                       children: [
  //                         Text(
  //                           'Credit Card',
  //                           style: TextStyle(
  //                             fontSize: defaultFontSize,
  //                             fontWeight: FontWeight.w500,
  //                             color: Colors.black
  //                           ),
  //                         ),
  //                         Image(
  //                           image: AssetImage('images/credit_card.png'),
  //                           width: 40,
  //                         ), 
  //                       ],
  //                     ),
  //                   ),

  //                   ListTile(
  //                     contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Remove default padding
  //                     leading: Transform.scale(
  //                       scale: 0.6, // Scale the radio size
  //                       child: Radio<String>(
  //                         value: 'PayPal',
  //                         groupValue: selectedPaymentOption,
  //                         activeColor: primaryColor, // Set the selected radio color to blue
  //                         onChanged: (String? value) {
  //                           setState(() {
  //                             selectedPaymentOption = value; // Update selected payment option
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                     title: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and icon
  //                       children: [
  //                         Text(
  //                           'PayPal',
  //                           style: TextStyle(
  //                             fontSize: defaultFontSize,
  //                             fontWeight: FontWeight.w500,
  //                             color: Colors.black
  //                           ),
  //                         ),
  //                         Image(
  //                           image: AssetImage('images/paypal.png'),
  //                           width: 50,
  //                           height: 40,
  //                         ), 
  //                       ],
  //                     ),
  //                   ),

  //                   ListTile(
  //                     contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Remove default padding
  //                     leading: Transform.scale(
  //                       scale: 0.6, // Scale the radio size
  //                       child: Radio<String>(
  //                         value: 'Online Banking',
  //                         groupValue: selectedPaymentOption,
  //                         activeColor: primaryColor, // Set the selected radio color to blue
  //                         onChanged: (String? value) {
  //                           setState(() {
  //                             selectedPaymentOption = value; // Update selected payment option
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                     title: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and icon
  //                       children: [
  //                         Text(
  //                           'Online Banking',
  //                           style: TextStyle(
  //                             fontSize: defaultFontSize,
  //                             fontWeight: FontWeight.w500,
  //                             color: Colors.black
  //                           ),
  //                         ),
  //                         Icon(Icons.account_balance, color: primaryColor, size: 20), // Icon for Bank Transfer
  //                       ],
  //                     ),
  //                   ),

  //                   SizedBox(height: 20),
  //                   Text(
  //                     'Total Price: $deposit',
  //                     style: TextStyle(
  //                       fontSize: defaultLabelFontSize,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),

  //                   SizedBox(height: 10),

  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     children: [
  //                       TextButton(
  //                         child: Text('Cancel'),
  //                         onPressed: () {
  //                           Navigator.of(context).pop(); // Close the dialog
  //                         },
  //                         style: TextButton.styleFrom(
  //                           backgroundColor: primaryColor, // Set the background color
  //                           foregroundColor: Colors.white, // Set the text color
  //                           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(8), // Optional: rounded corners
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(width: 10),

  //                       TextButton(
  //                         child: Text('Pay'),
  //                         style: TextButton.styleFrom(
  //                           backgroundColor: selectedPaymentOption != null ? primaryColor : Colors.grey.shade300, // Set the background color
  //                           foregroundColor: Colors.white, // Set the text color
  //                           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(8), // Optional: rounded corners
  //                           ),
  //                         ),
  //                         onPressed: selectedPaymentOption != null
  //                           ? () {
  //                               onOptionSelected(selectedPaymentOption!); // Pass the selected payment option to the callback
  //                               Navigator.of(context).pop(); // Close the dialog
  //                             }
  //                           : null,
  //                       ),
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> generateInvoice(String id, Invoice invoices, String servicesType, String collectionName, String pdfFileName, bool isDeposit, bool isRefund, bool isDepositRefund) async {
    setState(() {
      bool isGeneratingInvoice = true; // Correctly set the loading state variable
    });

    try {
      // Small delay to allow the UI to update
      await Future.delayed(Duration(milliseconds: 100));

      // Generate the PDF file
      final pdfFile = await PdfInvoiceApi.generate(
        invoices, 
        widget.userID, 
        id, 
        servicesType, 
        collectionName, 
        pdfFileName, 
        isDeposit,
        isRefund,
        isDepositRefund
      );

      // Open the generated PDF file
      await PdfInvoiceApi.openFile(pdfFile);

    } catch (e) {
      // Handle errors during invoice generation
      showCustomDialog(
        context: context,
        title: "Invoice Generation Failed",
        content: "Could not generate invoice. Please try again.",
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } finally {
      setState(() {
        bool isGeneratingInvoice = false; // Reset loading state correctly
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,  // Outer tab count
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 241, 246, 249),
        body: Column(
          children: [
            // Outer TabBar (Upcoming, Completed, Canceled)
            TabBar(
              onTap: (index) {
                setState(() {
                  _outerTabIndex = index;
                  _innerTabIndex = 0;  // Reset inner tab index on outer tab change
                });
              },
              labelColor: Color(0xFF467BA1),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF467BA1),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: "Upcoming"),
                Tab(text: "Completed"),
                Tab(text: "Canceled"),
              ],
            ),

            // Inner Tabs (Tour Package, Car Rental, Local Buddy) using buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInnerTabButton(0, "Tour Package"),
                  _buildInnerTabButton(1, "Car Rental"),
                  _buildInnerTabButton(2, "Local Buddy"),
                ],
              ),
            ),

            // TabBarView for the outer tabs
            Expanded(
              child: isFetchingTourPackage || isFetchingCarRental || isFetchingLocalBuddy 
                ? Center(
                    child: CircularProgressIndicator(color: primaryColor,),  // Show loading indicator when isFetching is true
                  )
                : TabBarView(
                    physics: NeverScrollableScrollPhysics(), // Prevents swipe gesture
                    children: [
                      _buildContentForTab(),  // For Upcoming
                      _buildContentForTab(),  // For Completed
                      _buildContentForTab(),  // For Canceled
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create inner tab buttons
  Widget _buildInnerTabButton(int index, String title) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _innerTabIndex = index; // Update inner tab index on button press
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _innerTabIndex == index ? Color(0xFF749CB9) : Colors.white,  // Active color
        foregroundColor: _innerTabIndex == index ? Colors.white : Color(0xFF749CB9),  // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: primaryColor)
        ),
      ),
      child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
    );
  }

  // Method to build content for the selected outer and inner tabs
  Widget _buildContentForTab() {
    if (_outerTabIndex == 0) {
      // Handle Upcoming
      if (_innerTabIndex == 0) {
        return _buildTourPackageContent(_tourBookingUpcoming, 0);
      } else if (_innerTabIndex == 1) {
        return _buildCarRentalContent(_carRentalBookingUpcoming, 0);
      } else {
        return _buildLocalBuddyContent(_localBuddyBookingUpcoming, 0);
      }
    } else if (_outerTabIndex == 1) {
      // Handle Completed
      if (_innerTabIndex == 0) {
        return _buildTourPackageContent(_tourBookingCompleted, 1);
      } else if (_innerTabIndex == 1) {
        return _buildCarRentalContent(_carRentalBookingCompleted, 1);
      } else {
        return _buildLocalBuddyContent(_localBuddyBookingCompleted, 1);
      }
    } else {
      // Handle Canceled
      if (_innerTabIndex == 0) {
        return _buildTourPackageContent(_tourBookingCanceled, 2);
      } else if (_innerTabIndex == 1) {
        return _buildCarRentalContent(_carRentalBookingCanceled, 2);
      } else {
        return _buildLocalBuddyContent(_localBuddyBookingCanceled, 2);
      }
    }
  }

  // Mock content for different inner tabs
  Widget _buildTourPackageContent(List<tourBooking> bookings,int status) {
    if(bookings.isNotEmpty){
      // If data exists, show the list of bookings
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                itemCount: bookings.length,
                shrinkWrap: true, // Allows ListView to be nested
                physics: NeverScrollableScrollPhysics(), // Prevents ListView from scrolling independently
                itemBuilder: (context, index) {
                  return tourComponent(tourbookings: bookings[index], status: status);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(child: Text(status == 0 ? 'You have no upcoming tour bookings.' : status == 1 ? 'You have no completed tour bookings' : status == 2 ? 'You have no canceled tour bookings.' : 'Error'));
    }
  }

  Widget _buildCarRentalContent(List<carRentalBooking> bookings, int status) {
      if(bookings.isNotEmpty){
      // If data exists, show the list of bookings
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                itemCount: bookings.length,
                shrinkWrap: true, // Allows ListView to be nested
                physics: NeverScrollableScrollPhysics(), // Prevents ListView from scrolling independently
                itemBuilder: (context, index) {
                  return carComponent(carRentalbookings: bookings[index], status: status);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(child: Text(status == 0 ? 'You have no upcoming car rental bookings.' : status == 1 ? 'You have no completed car rental bookings' : status == 2 ? 'You have no canceled car rental bookings.' : 'Error'));
    }
  }

  Widget _buildLocalBuddyContent(List<localBuddyBooking> bookings, int status) {
      if(bookings.isNotEmpty){
      // If data exists, show the list of bookings
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                itemCount: bookings.length,
                shrinkWrap: true, // Allows ListView to be nested
                physics: NeverScrollableScrollPhysics(), // Prevents ListView from scrolling independently
                itemBuilder: (context, index) {
                  return localBuddyComponent(localBuddyBookings: bookings[index], status: status);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(child: Text(status == 0 ? 'You have no upcoming local buddy bookings.' : status == 1 ? 'You have no completed local buddy bookings' : status == 2 ? 'You have no canceled local buddy bookings.' : 'Error'));
    }
  }

  Widget tourComponent({required tourBooking tourbookings, required int status}){
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => BookingDetailsScreen(userID: widget.userID, tourBookingID: tourbookings.tourBookingID, tourID: tourbookings.tourID,))
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border.all(color: Colors.grey.shade200, width: 1.5),
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ID: ${tourbookings.tourBookingID}",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: status == 0 ? Colors.orange.shade100 : status == 1 ? Colors.green.shade100 : status == 2 ? Colors.red.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(
                      status == 0 ? "Upcoming" : status == 1 ? "Completed" : status == 2 ? "Canceled" : "Unknown",
                      style: TextStyle(
                        color: status == 0 ? Colors.orange : status == 1 ? Colors.green : status == 2 ? Colors.red : Colors.grey.shade900,
                        fontSize: 10,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  )
                ],
              )
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: getScreenWidth(context) * 0.15,
                    height: getScreenHeight(context) * 0.1,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(tourbookings.tourImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 250, // Set a desired width
                        child: Text(
                          tourbookings.tourName,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                          maxLines: 1, // Optional: Limits to a single line
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Booking Date: ${tourbookings.travelDate}", 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.w500, 
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "Payment: ", 
                            style: TextStyle(
                              color: Colors.black, 
                              fontWeight: FontWeight.w500, 
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "${tourbookings.fullyPaid == 0 ? 'Half Payment' : 'Completed'}", 
                            style: TextStyle(
                              color: tourbookings.fullyPaid == 0 ? Colors.red : const Color.fromARGB(255, 103, 178, 105), 
                              fontWeight: FontWeight.bold, 
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Total Price: RM ${NumberFormat('#,##0.00').format(tourbookings.totalPrice)}", 
                    style: TextStyle(
                      color: Colors.black, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (status == 0) ...[
                          if (tourbookings.fullyPaid == 0) ...[
                            SizedBox(
                              height: 30, // Set the button height
                              child: TextButton(
                                onPressed: (){
                                  showDialog(
                                    context: context, 
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text(
                                          "Please note that payments are non-refundable once the booking is canceled after full payment is made. Kindly ensure that all details are thoroughly checked before proceeding.",
                                          textAlign: TextAlign.justify,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: primaryColor, // Set the background color
                                              foregroundColor: Colors.white, // Set the text color
                                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                              ),
                                            ),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                              showPaymentOption(context, 'RM${NumberFormat('#,##0.00').format(tourbookings.totalPrice - 1000)}', () {
                                                payBalanceTour(tourbookings.tourBookingID, tourbookings.agencyName, tourbookings.agencyAddress, tourbookings.totalPrice - 1000); // Call bookTour when payment option is selected
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: primaryColor, // Set the background color
                                              foregroundColor: Colors.white, // Set the text color
                                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                              ),
                                            ),
                                            child: const Text("Pay"),
                                          ),
                                        ],
                                      );
                                    }
                                  );
                                }, 
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Color(0xFF749CB9),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text(
                                  "Pay", 
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(width: 5), // Space between buttons
                            SizedBox(
                              height: 30, // Set the button height
                              child: TextButton(
                                onPressed: (){
                                  showDialog(
                                    context: context, 
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text(
                                          "Please noted that the deposit of RM1000.00 will not be refunded once you can this booking. Are you sure you still want to cancel this booking?",
                                          textAlign: TextAlign.justify,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: primaryColor, // Set the background color
                                              foregroundColor: Colors.white, // Set the text color
                                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                              ),
                                            ),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Cancel Booking'),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text('Please provide a reason for booking cancellation:'),
                                                        TextField(
                                                          controller: _cancelTourBookingController,
                                                          maxLines: 3,
                                                          decoration: InputDecoration(
                                                            hintText: 'Enter cancellation reason...',
                                                            border: OutlineInputBorder(
                                                              borderSide: BorderSide(color: primaryColor)
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(); // Close the dialog
                                                        },
                                                        child: Text('Cancel'),
                                                        style: TextButton.styleFrom(
                                                          backgroundColor: primaryColor,
                                                          foregroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          if (_cancelTourBookingController.text.trim().isEmpty) {
                                                            // Show error dialog if reason is empty
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text('Error'),
                                                                  content: Text('Cancellation reason cannot be empty.'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop(); // Close the error dialog
                                                                      },
                                                                      child: Text('OK'),
                                                                      style: TextButton.styleFrom(
                                                                        backgroundColor: primaryColor,
                                                                        foregroundColor: Colors.white,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          } else {
                                                            // Proceed with cancelation if reason is provided
                                                            // Navigator.of(context).pop(); // Close the main dialog
                                                            setState(() {
                                                              isCancelTourBooking = true;
                                                            });
                                                            cancelTourBooking(
                                                              tourbookings.tourBookingID,
                                                              tourbookings.tourID,
                                                              tourbookings.pax,
                                                              tourbookings.travelDate,
                                                              _cancelTourBookingController.text,
                                                            );
                                                            setState(() {
                                                              isCancelTourBooking = false;
                                                            });
                                                            // Navigator.pop(context);
                                                          }
                                                        },
                                                        child: isCancelTourBooking
                                                        ? SizedBox(
                                                          width: 10,
                                                          height: 10,
                                                          child: CircularProgressIndicator(color: Colors.white,),
                                                        )
                                                        : Text('Submit'),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: primaryColor,
                                                          foregroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: primaryColor, // Set the background color
                                              foregroundColor: Colors.white, // Set the text color
                                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                              ),
                                            ),
                                            child: isCancelTourBooking
                                            ? SizedBox(
                                                width: 20, 
                                                height: 20, 
                                                child: CircularProgressIndicator(
                                                  color: primaryColor,
                                                ),
                                              )
                                            : Text("Confirm"),
                                          ),
                                        ],
                                      );
                                    }
                                  );
                                }, 
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Color(0xFF749CB9),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text(
                                  "Cancel Booking", 
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                          
                        ] else if (status == 1) 
                          SizedBox(
                            height: 30, // Set the button height
                            child: TextButton(
                              onPressed: (){}, 
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                backgroundColor: Colors.white,
                                foregroundColor: Color(0xFF749CB9),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                "Write a Review", 
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        else
                          SizedBox.shrink(),  // Return an empty widget when no buttons are required
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      )
    );
  }

  Widget carComponent({required carRentalBooking carRentalbookings, required int status}){
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => BookingDetailsScreen(userID: widget.userID, carRentalBookingID: carRentalbookings.carRentalBookingID, carRentalID: carRentalbookings.carID,))
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border.all(color: Colors.grey.shade200, width: 1.5),
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ID: ${carRentalbookings.carRentalBookingID}",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: status == 0 ? Colors.orange.shade100 : status == 1 ? Colors.green.shade100 : status == 2 ? Colors.red.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(
                      status == 0 ? "Upcoming" : status == 1 ? "Completed" : status == 2 ? "Canceled" : "Unknown",
                      style: TextStyle(
                        color: status == 0 ? Colors.orange : status == 1 ? Colors.green : status == 2 ? Colors.red : Colors.grey.shade900,
                        fontSize: 10,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  )
                ],
              )
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: getScreenWidth(context) * 0.2,
                    height: getScreenHeight(context) * 0.12,
                    margin: EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(carRentalbookings.carImage),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carRentalbookings.carName, 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 240, // Set a desired width
                        child: Text(
                          "Booking Date: ${carRentalbookings.bookingDate.map((date) => DateFormat('dd/MM/yyyy').format(date)).join(', ')}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                          maxLines: 1, // Optional: Limits to a single line
                        ),
                      ),
                      // Text(
                      //   "Dates: ${carRentalbookings.bookingDate.map((date) => DateFormat('dd/MM/yyyy').format(date)).join(', ')}",
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.w500,
                      //     fontSize: 10,
                      //   ),
                      //   overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      // ),
                      status == 1
                      ? Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  "Deposit Refund: ", 
                                  style: TextStyle(
                                    color: Colors.black, 
                                    fontWeight: FontWeight.w500, 
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                                ),
                                Text(
                                  "${(carRentalbookings.isDepositRefund == 0) ? "Progressing..." : "Done"}", 
                                  style: TextStyle(
                                    color: carRentalbookings.isDepositRefund == 0 ? Colors.orange : Colors.green, 
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                                ),
                              ],
                            )
                            
                          ],
                        )
                      : status == 2
                        ? Column(
                            children: [
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    "Refund: ", 
                                    style: TextStyle(
                                      color: Colors.black, 
                                      fontWeight: FontWeight.w500, 
                                      fontSize: 10,
                                    ),
                                    overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                                  ),
                                  Text(
                                    "${(carRentalbookings.isRefund == 0) ? "Progressing..." : "Done"}", 
                                    style: TextStyle(
                                      color: carRentalbookings.isRefund == 0 ? Colors.orange : Colors.green, 
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 10,
                                    ),
                                    overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                                  ),
                                ],
                              )
                              
                            ],
                          )
                        : Container()
                    ],
                  )
                ],
              )
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Total Price: RM ${NumberFormat('#,##0.00').format(carRentalbookings.totalPrice)}", 
                    style: TextStyle(
                      color: Colors.black, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: status == 0
                      ? SizedBox(
                          height: 30, // Set the button height
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context, 
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('Confirmation'),
                                    content: Text(
                                      "Are you sure you want to cancel this booking?",
                                      textAlign: TextAlign.justify,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryColor, // Set the background color
                                          foregroundColor: Colors.white, // Set the text color
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                          ),
                                        ),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Cancel Booking'),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text('Please provide a reason for booking cancellation:'),
                                                    TextField(
                                                      controller: _cancelCarRentalBookingController,
                                                      maxLines: 3,
                                                      decoration: InputDecoration(
                                                        hintText: 'Enter cancellation reason...',
                                                        border: OutlineInputBorder(
                                                          borderSide: BorderSide(color: primaryColor)
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Close the dialog
                                                    },
                                                    child: Text('Cancel'),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: primaryColor,
                                                      foregroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      if (_cancelCarRentalBookingController.text.trim().isEmpty) {
                                                        // Show error dialog if reason is empty
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text('Error'),
                                                              content: Text('Cancellation reason cannot be empty.'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop(); // Close the error dialog
                                                                  },
                                                                  child: Text('OK'),
                                                                  style: TextButton.styleFrom(
                                                                    backgroundColor: primaryColor,
                                                                    foregroundColor: Colors.white,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      } else {
                                                        // Proceed with cancelation if reason is provided
                                                        // Navigator.of(context).pop(); // Close the main dialog
                                                        setState(() {
                                                          isCancelCarRentalBooking = true;
                                                        });
                                                        cancelCarBooking(carRentalbookings.carRentalBookingID, _cancelCarRentalBookingController.text);
                                                        setState(() {
                                                          isCancelCarRentalBooking = false;
                                                        });
                                                        // Navigator.pop(context);
                                                      }
                                                    },
                                                    child: isCancelCarRentalBooking
                                                    ? SizedBox(
                                                      width: 10,
                                                      height: 10,
                                                      child: CircularProgressIndicator(color: Colors.white,),
                                                    )
                                                    : Text('Submit'),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: primaryColor,
                                                      foregroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryColor, // Set the background color
                                          foregroundColor: Colors.white, // Set the text color
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                          ),
                                        ),
                                        child: isCancelTourBooking
                                        ? SizedBox(
                                            width: 20, 
                                            height: 20, 
                                            child: CircularProgressIndicator(
                                              color: primaryColor,
                                            ),
                                          )
                                        : Text("Confirm"),
                                      ),
                                    ],
                                  );
                                }
                              );
                            }, 
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF749CB9),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: isCancelCarRentalBooking
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: primaryColor,),
                            )
                            :Text(
                              "Cancel Booking", 
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : status == 1
                        ? SizedBox(
                          height: 30, // Set the button height
                          child: TextButton(
                            onPressed: () {}, 
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF749CB9),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Write a Review", 
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : SizedBox.shrink(), // Return an empty widget when no buttons are required
                  )
                ],
              ),
            )
          ],
        )
      )
    );
  }

  Widget localBuddyComponent({required localBuddyBooking localBuddyBookings, required int status}){
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => BookingDetailsScreen(userID: widget.userID, localBuddyBookingID: localBuddyBookings.localBuddyBookingID, localBuddyID: localBuddyBookings.localBuddyID,))
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border.all(color: Colors.grey.shade200, width: 1.5),
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ID: ${localBuddyBookings.localBuddyBookingID}",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: status == 0 ? Colors.orange.shade100 : status == 1 ? Colors.green.shade100 : status == 2 ? Colors.red.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(
                      status == 0 ? "Upcoming" : status == 1 ? "Completed" : status == 2 ? "Canceled" : "Unknown",
                      style: TextStyle(
                        color: status == 0 ? Colors.orange : status == 1 ? Colors.green : status == 2 ? Colors.red : Colors.grey.shade900,
                        fontSize: 10,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  )
                ],
              )
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: getScreenWidth(context) * 0.16,
                    height: getScreenHeight(context) * 0.12,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(localBuddyBookings.localBuddyImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localBuddyBookings.localBuddyName, 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 240, // Set a desired width
                        child: Text(
                          "Booking Date: ${localBuddyBookings.bookingDate.map((date) => DateFormat('dd/MM/yyyy').format(date)).join(', ')}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                          maxLines: 1, // Optional: Limits to a single line
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Location: ${localBuddyBookings.locationArea}", 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.w500, 
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                      ),
                      status == 2
                      ? Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  "Refund: ", 
                                  style: TextStyle(
                                    color: Colors.black, 
                                    fontWeight: FontWeight.w500, 
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                                ),
                                Text(
                                  "${(localBuddyBookings.isRefund == 0) ? "Progressing..." : "Done"}", 
                                  style: TextStyle(
                                    color: localBuddyBookings.isRefund == 0 ? Colors.orange : Colors.green, 
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                                ),
                              ],
                            )
                            
                          ],
                        )
                      : Container()
                    ],
                  )
                ],
              )
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Total Price: RM ${NumberFormat('#,##0.00').format(localBuddyBookings.totalPrice)}", 
                    style: TextStyle(
                      color: Colors.black, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: status == 0
                      ? SizedBox(
                          height: 30, // Set the button height
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context, 
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('Confirmation'),
                                    content: Text(
                                      "Are you sure you want to cancel this booking?",
                                      textAlign: TextAlign.justify,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryColor, // Set the background color
                                          foregroundColor: Colors.white, // Set the text color
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                          ),
                                        ),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                builder: (BuildContext context, StateSetter setDialogState) {
                                                  return AlertDialog(
                                                    title: Text('Cancel Booking'),
                                                    content: SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text('Please provide a reason for booking cancellation:',style: TextStyle(fontWeight: FontWeight.bold, fontSize: defaultFontSize),),
                                                          SizedBox(height: 10),
                                                          TextField(
                                                            controller: _cancelLocalBookingController,
                                                            maxLines: 3,
                                                            decoration: InputDecoration(
                                                              labelText: "Cancellation Reason",
                                                              hintText: "Enter cancellation reason...",
                                                              labelStyle: TextStyle(color: Colors.black, fontSize: defaultLabelFontSize),
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              border: OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                  color: Color(0xFF467BA1),
                                                                  width: 2.5,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                  color: Color(0xFF467BA1),
                                                                  width: 2.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: const BorderSide(color: Color(0xFF467BA1), width: 2.5),
                                                              ),
                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                            ),
                                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: defaultFontSize),
                                                          ),
                                                          const SizedBox(height: 20),
                                                            const Text(
                                                              "Please enter your bank details for booking fee refund:",
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: defaultFontSize),
                                                            ),
                                                            SizedBox(height: 10),
                                                            TextField(
                                                              controller: _bankNameController,
                                                              decoration: InputDecoration(
                                                                labelText: "Bank Name",
                                                                hintText: "Bank Name",
                                                                labelStyle: TextStyle(color: Colors.black, fontSize: defaultLabelFontSize),
                                                                filled: true,
                                                                fillColor: Colors.white,
                                                                border: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                    color: Color(0xFF467BA1),
                                                                    width: 2.5,
                                                                  ),
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                    color: Color(0xFF467BA1),
                                                                    width: 2.5,
                                                                  ),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(color: Color(0xFF467BA1), width: 2.5),
                                                                ),
                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                              ),
                                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: defaultFontSize),
                                                              // onChanged: (value) {
                                                              //   setDialogState(() {
                                                              //     updateAccountDetailsFill();
                                                              //   });
                                                              // },
                                                            ),
                                                            SizedBox(height: 10),
                                                            TextField(
                                                              controller: _accountNameController,
                                                              decoration: InputDecoration(
                                                                labelText: "Account Name",
                                                                hintText: "Account Name",
                                                                labelStyle: TextStyle(color: Colors.black, fontSize: defaultLabelFontSize),
                                                                filled: true,
                                                                fillColor: Colors.white,
                                                                border: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                    color: Color(0xFF467BA1),
                                                                    width: 2.5,
                                                                  ),
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                    color: Color(0xFF467BA1),
                                                                    width: 2.5,
                                                                  ),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(color: Color(0xFF467BA1), width: 2.5),
                                                                ),
                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                              ),
                                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: defaultFontSize),
                                                              // onChanged: (value) {
                                                              //   setDialogState(() {
                                                              //     updateAccountDetailsFill();
                                                              //   });
                                                              // },
                                                            ),
                                                            SizedBox(height: 10),
                                                            TextField(
                                                              controller: _accountNumberController,
                                                              decoration: InputDecoration(
                                                                labelText: "Account Number",
                                                                hintText: "Account Number",
                                                                labelStyle: TextStyle(color: Colors.black, fontSize: defaultLabelFontSize),
                                                                filled: true,
                                                                fillColor: Colors.white,
                                                                border: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                    color: Color(0xFF467BA1),
                                                                    width: 2.5,
                                                                  ),
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                    color: Color(0xFF467BA1),
                                                                    width: 2.5,
                                                                  ),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(color: Color(0xFF467BA1), width: 2.5),
                                                                ),
                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                              ),
                                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: defaultFontSize),
                                                              keyboardType: TextInputType.number,
                                                              // onChanged: (value) {
                                                              //   setDialogState(() {
                                                              //     updateAccountDetailsFill();
                                                              //   });
                                                              // },
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                    
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(); // Close the dialog
                                                        },
                                                        child: Text('Cancel'),
                                                        style: TextButton.styleFrom(
                                                          backgroundColor: primaryColor,
                                                          foregroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          if (_cancelLocalBookingController.text.trim().isEmpty && _bankNameController.text.trim().isEmpty && _accountNameController.text.trim().isEmpty && _accountNumberController.text.trim().isEmpty) {
                                                            // Show error dialog if reason is empty
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text('Error'),
                                                                  content: Text('Please make sure you have filled in all required field.'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop(); // Close the error dialog
                                                                      },
                                                                      child: Text('OK'),
                                                                      style: TextButton.styleFrom(
                                                                        backgroundColor: primaryColor,
                                                                        foregroundColor: Colors.white,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          } else {
                                                            // Proceed with cancelation if reason is provided
                                                            // Navigator.of(context).pop(); // Close the main dialog
                                                            setState(() {
                                                              isCancelLocalBuddyBooking = true;
                                                            });
                                                            cancelLocalBuddyBooking(localBuddyBookings.localBuddyBookingID, _cancelLocalBookingController.text, _bankNameController.text, _accountNameController.text, _accountNumberController.text);
                                                            setState(() {
                                                              isCancelLocalBuddyBooking = false;
                                                            });
                                                            // Navigator.pop(context);
                                                          }
                                                        },
                                                        child: isCancelLocalBuddyBooking
                                                        ? SizedBox(
                                                          width: 10,
                                                          height: 10,
                                                          child: CircularProgressIndicator(color: Colors.white,),
                                                        )
                                                        : Text('Submit'),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: primaryColor,
                                                          foregroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              )
                                              ;
                                            },
                                          );

                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryColor, // Set the background color
                                          foregroundColor: Colors.white, // Set the text color
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional padding
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                                          ),
                                        ),
                                        child: isCancelLocalBuddyBooking
                                        ? SizedBox(
                                            width: 20, 
                                            height: 20, 
                                            child: CircularProgressIndicator(
                                              color: primaryColor,
                                            ),
                                          )
                                        : Text("Confirm"),
                                      ),
                                    ],
                                  );
                                }
                              );
                            }, 
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF749CB9),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Cancel Booking", 
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : status == 1
                        ? SizedBox(
                          height: 30, // Set the button height
                          child: TextButton(
                            onPressed: () {}, 
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF749CB9),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color(0xFF749CB9), width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Write a Review", 
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : SizedBox.shrink(), // Return an empty widget when no buttons are required
                  )
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}

