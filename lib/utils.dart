import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';

// class ImageUtils {
//   // // Request permission to access photos
//   // static Future<void> requestPermissions(BuildContext context) async {
//   //   final permissionStatus = await Permission.photos.request();
//   //   if(permissionStatus.isGranted){
//   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permission is granted.")));
//   //   }
//   //   else if (permissionStatus.isDenied) {
//   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permission is not granted. Please go to setting to allow TripMate access to your gallery.")));
//   //     print('Permission denied');
//   //   } else if (permissionStatus.isPermanentlyDenied) {
//   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permission is not granted. Please go to setting to allow TripMate access to your gallery.")));
//   //     await openAppSettings();
//   //   }
//   // }

//   static Future<void> requestPermissions(BuildContext context) async {
//     Permission permission;

//     if (Platform.isAndroid) {
//       // Use READ_MEDIA_IMAGES for Android 13+, otherwise use READ_EXTERNAL_STORAGE
//       permission = await Permission.photos.isGranted ? Permission.photos : Permission.storage;
//     } else if (Platform.isIOS) {
//       permission = Permission.photos;
//     } else {
//       return;
//     }

//     final permissionStatus = await permission.request();

//     if (permissionStatus.isGranted) {
//       // Uint8List? img = await pickImage(ImageSource.gallery);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Permission is granted."))
//       );
//     } else if (permissionStatus.isDenied) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Permission is denied. Please allow access to your gallery in settings."))
//       );
//     } else if (permissionStatus.isPermanentlyDenied) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Permission is permanently denied. Please allow access to your gallery in settings."))
//       );
//       await openAppSettings(); // Open app settings if permission is permanently denied
//     }
//   }

//   // Select image from gallery
//   static Future<Uint8List?> selectImage(BuildContext context) async {
//     try {
//       await requestPermissions(context);

//       final permissionStatus = await Permission.photos.status;
//       print(permissionStatus);
//       // if (permissionStatus.isGranted) {
//       //   Uint8List? img = await pickImage(ImageSource.gallery);
//       //   return img;
//       // } else {
//       //   print('Permission to access photos was not granted.');
//       //   // await openAppSettings();
//       //   return null;
//       // }
//     } catch (e) {
//       print('Error selecting image: $e');
//       return null;
//     }
//   }

//   // Function to pick an image using ImagePicker
//   static Future<Uint8List?> pickImage(ImageSource source) async {
//     final ImagePicker _imagePicker = ImagePicker();
//     try {
//       XFile? _file = await _imagePicker.pickImage(source: source);
//       if (_file != null) {
//         return await _file.readAsBytes();
//       } else {
//         print('No image selected');
//         return null;
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//       return null;
//     }
//   }
// }

class ImageUtils {
  // Request permission to access photos and then pick an image
  static Future<Uint8List?> selectImage(BuildContext context) async {
    try {
      Permission permission;

      if (Platform.isAndroid) {
        // Use READ_MEDIA_IMAGES for Android 13+, otherwise use READ_EXTERNAL_STORAGE
        permission = await Permission.photos.isGranted ? Permission.photos : Permission.storage;
      } else if (Platform.isIOS) {
        permission = Permission.photos;
      } else {
        return null;
      }

      final permissionStatus = await permission.request();

      if (permissionStatus.isGranted) {
        Uint8List? img = await pickImage(ImageSource.gallery);
        return img;
      } else if (permissionStatus.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Permission is denied. Please allow access to your gallery in settings.")),
        );
        return null;
      } else if (permissionStatus.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Permission is permanently denied. Please allow access to your gallery in settings.")),
        );
        await openAppSettings(); // Open app settings if permission is permanently denied
        return null;
      }
    } catch (e) {
      print('Error selecting image: $e');
      return null;
    }
    return null;
  }

  // Function to pick an image using ImagePicker
  static Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    try {
      XFile? _file = await _imagePicker.pickImage(source: source);
      if (_file != null) {
        return await _file.readAsBytes();
      } else {
        print('No image selected');
        return null;
      }
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }
}


class FileUtils {
  static Future<bool> _request_per(Permission permission) async{
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if(build.version.sdkInt>=30){
      var re = await Permission.manageExternalStorage.request();
      if(re.isGranted){
        return true;
      }
      else {
        return false;
      }
    }
    else{
      if(await permission.isGranted){
        return true;
      }
      else{
        var result = await permission.request();
        if(result.isGranted){
          return true;
        }
        else{
          return false;
        }
      }
    }
    
  }

  // Select PDF file
  static Future<File?> selectPdf() async {
    try {
      if (await _request_per(Permission.storage) == true){
        print('Permission is granted');
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        if (result != null && result.files.isNotEmpty) {
          return File(result.files.first.path!);
        } else {
          print('No file selected');
          return null;
        }
      }
      else{
        print('Permission is not granted');
        return null;
      }
    } catch (e) {
      print('Error selecting PDF file: $e');
      return null;
    }
  }
}

class Country{
  final String countryName;
  final String countryID;
  final String image;

  Country(this.countryName, this.countryID, this.image);
}

class City{
  final String cityName;
  final String cityID;
  final String image;

  City(this.cityName, this.cityID, this.image);
}

class TourPackage{
  final String tourName;
  final String tourID;
  final String image;
  final String agency;

  TourPackage(this.tourName, this.tourID, this.image, this.agency);
}

class TravelAgent{
  final String name;
  final String companyName;
  final String id;
  final String image;

  TravelAgent(this.name, this.companyName, this.id, this.image);
}

class UserViewTourList{
  final String tourName;
  final String tourID;
  final String image;
  final String agency;
  final String? agentID;
  final List<dynamic> tourHighlight;
  final List<dynamic> availability;

  UserViewTourList(this.tourName, this.tourID, this.image, this.agency, this.tourHighlight, this.availability, {this.agentID});
}

class MessageList{
  final String receiverName;
  final String receiverProfile;
  final String receiverID;
  final String latestMessage;
  final Timestamp latestReceiveTime;
  final bool isCurrentUser;

  MessageList(this.receiverName, this.receiverProfile, this.receiverID, this.latestMessage, this.latestReceiveTime, this.isCurrentUser);
}

class CarList{
  final String carID;
  final String carModel;
  final String? carImage;
  final String? carType;
  final String? fuel;
  final String? transmission;
  final int? seat;
  final double? price;
  final String? agentID;
  final String? agencyName;
  final String? agencyContact;
  final String? pickUpLocation;
  final String? dropOffLocation;

  CarList(this.carID, this.carModel, {this.carImage, this.carType, this.fuel, this.transmission, this.seat, this.price, this.agentID, this.agencyName, this.agencyContact, this.pickUpLocation, this.dropOffLocation});
}

class LocalBuddy{
  final String localBuddyID;
  final String localBuddyName;
  final String localBuddyImage;
  final String? occupation;
  final int? status;
  final int? ranking;
  final String? locationArea;
  final String? languageSpoken;
  final String? locationAddress;
  final int? price;

  LocalBuddy({required this.localBuddyID, required this.localBuddyName, required this.localBuddyImage, this.occupation, this.status, this.ranking, this.locationArea, this.languageSpoken, this.locationAddress, this.price});

}

class itinerary{
  final String title;
  final String content;
  final String itineraryID;
  final String image;

  itinerary(this.title, this.content, this.itineraryID, this.image);
}

class tourBooking{
  final String tourBookingID;
  final String tourID;
  late String tourName;
  late String tourImage;
  final int fullyPaid;
  final String travelDate;
  final double totalPrice;
  final int pax;
  final int bookingStatus;

  tourBooking({
    required this.tourBookingID, 
    required this.tourID,
    required this.fullyPaid, 
    required this.travelDate, 
    required this.totalPrice, 
    required this.pax,
    required this.bookingStatus
  });

  factory tourBooking.fromFirestore(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    tourBooking tourbooking = tourBooking(
      tourBookingID: doc.id, 
      tourID: data['tourID'],
      fullyPaid: data['fullyPaid'], 
      travelDate: data['travelDate'], 
      totalPrice: data['totalPrice'], 
      pax: data['numberOfPeople'],
      bookingStatus: data['bookingStatus']
    );

    tourbooking.tourName = data['tourName'] ?? '';
    tourbooking.tourImage = data['tourCover'] ?? '';

    return tourbooking;
  }
}

class carRentalBooking{
  final String carRentalBookingID;
  final String carID;
  late String carName;
  late String carImage;
  final String bookingDate;
  final double totalPrice;
  final int bookingStatus;

  carRentalBooking({
    required this.carRentalBookingID, 
    required this.carID,
    required this.bookingDate, 
    required this.totalPrice,
    required this.bookingStatus
  });


  factory carRentalBooking.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Convert bookingStartDate and bookingEndDate to DateTime objects
    DateTime bookingStartDate = data['bookingStartDate'].toDate();
    DateTime bookingEndDate = data['bookingEndDate'].toDate();

    // Format the dates as dd/MM/yyyy
    String formattedStartDate = DateFormat('dd/MM/yyyy').format(bookingStartDate);
    String formattedEndDate = DateFormat('dd/MM/yyyy').format(bookingEndDate);

    // Combine the start and end dates into a single string
    String bookingDateRange = "$formattedStartDate - $formattedEndDate";

    carRentalBooking carRentalBookings = carRentalBooking(
      carRentalBookingID: doc.id,
      carID: data['carID'],
      totalPrice: data['totalPrice'],
      bookingDate: bookingDateRange, // Use the formatted date range here
      bookingStatus: data['bookingStatus'],
    );

    carRentalBookings.carName = data['carModel'] ?? '';
    carRentalBookings.carImage = data['carImage'] ?? '';

    return carRentalBookings;
  }
}

// class localBuddyBooking{
//   final String localBuddyBookingID;
//   final String localBuddyID;
//   late String localBuddyName;
//   late String localBuddyImage;
//   late String locationArea;
//   final String bookingDate;
//   final double totalPrice;
//   final int bookingStatus;

//   localBuddyBooking({
//     required this.localBuddyBookingID, 
//     required this.localBuddyID, 
//     required this.bookingDate, 
//     required this.totalPrice, 
//     required this.bookingStatus
//   });

//   factory localBuddyBooking.fromFirestore(DocumentSnapshot doc, DocumentSnapshot userDoc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     Map<String, dynamic> userdata = userDoc.data() as Map<String, dynamic>;

//     // Check if bookingStartDate and bookingEndDate are not null before calling toDate()
//     DateTime? bookingStartDate = data['bookingStartDate'] != null
//         ? (data['bookingStartDate'] as Timestamp).toDate()
//         : null;
//     DateTime? bookingEndDate = data['bookingEndDate'] != null
//         ? (data['bookingEndDate'] as Timestamp).toDate()
//         : null;

//     // Format the dates as dd/MM/yyyy, or set default values if null
//     String formattedStartDate = bookingStartDate != null
//         ? DateFormat('dd/MM/yyyy').format(bookingStartDate)
//         : 'N/A';  // Default to 'N/A' or any placeholder value if null
//     String formattedEndDate = bookingEndDate != null
//         ? DateFormat('dd/MM/yyyy').format(bookingEndDate)
//         : 'N/A';  // Default to 'N/A' or any placeholder value if null

//     // Combine the start and end dates into a single string
//     String bookingDateRange = "$formattedStartDate - $formattedEndDate";

//     localBuddyBooking localBuddyBookings = localBuddyBooking(
//       localBuddyBookingID: doc.id,
//       localBuddyID: data['localBuddyID'],
//       totalPrice: data['totalPrice'],
//       bookingDate: bookingDateRange,  // Use the formatted date range here
//       bookingStatus: data['bookingStatus'],
//     );

//     localBuddyBookings.localBuddyName = userdata['localBuddyName'] ?? '';
//     localBuddyBookings.localBuddyImage = userdata['profileImage'] ?? '';
//     localBuddyBookings.locationArea = data['locationArea'] ?? '';

//     return localBuddyBookings;
//   }

// }

class localBuddyBooking{
  final String localBuddyBookingID;
  final String localBuddyID;
  late String localBuddyName;
  late String localBuddyImage;
  late String locationArea;
  final String bookingDate;
  final double totalPrice;
  final int bookingStatus;

  localBuddyBooking({
    required this.localBuddyBookingID, 
    required this.localBuddyID, 
    required this.bookingDate, 
    required this.totalPrice, 
    required this.bookingStatus
  });

  factory localBuddyBooking.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Check if bookingStartDate and bookingEndDate are not null before calling toDate()
    DateTime? bookingStartDate = data['bookingStartDate'] != null
        ? (data['bookingStartDate'] as Timestamp).toDate()
        : null;
    DateTime? bookingEndDate = data['bookingEndDate'] != null
        ? (data['bookingEndDate'] as Timestamp).toDate()
        : null;

    // Format the dates as dd/MM/yyyy, or set default values if null
    String formattedStartDate = bookingStartDate != null
        ? DateFormat('dd/MM/yyyy').format(bookingStartDate)
        : 'N/A';  // Default to 'N/A' or any placeholder value if null
    String formattedEndDate = bookingEndDate != null
        ? DateFormat('dd/MM/yyyy').format(bookingEndDate)
        : 'N/A';  // Default to 'N/A' or any placeholder value if null

    // Combine the start and end dates into a single string
    String bookingDateRange = "$formattedStartDate - $formattedEndDate";

    localBuddyBooking localBuddyBookings = localBuddyBooking(
      localBuddyBookingID: doc.id,
      localBuddyID: data['localBuddyID'],
      totalPrice: data['totalPrice'],
      bookingDate: bookingDateRange,  // Use the formatted date range here
      bookingStatus: data['bookingStatus'],
    );

    localBuddyBookings.localBuddyName = data['localBuddyName'] ?? '';
    localBuddyBookings.localBuddyImage = data['profileImage'] ?? '';
    localBuddyBookings.locationArea = data['locationArea'] ?? '';

    return localBuddyBookings;
  }

}