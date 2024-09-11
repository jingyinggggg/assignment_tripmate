import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';

class ImageUtils {
  // Request permission to access photos
  static Future<void> requestPermissions() async {
    final permissionStatus = await Permission.photos.request();
    if (permissionStatus.isDenied) {
      print('Permission denied');
    } else if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  // Select image from gallery
  static Future<Uint8List?> selectImage(BuildContext context) async {
    try {
      await requestPermissions();

      final permissionStatus = await Permission.photos.status;
      if (permissionStatus.isGranted) {
        Uint8List? img = await pickImage(ImageSource.gallery);
        return img;
      } else {
        print('Permission to access photos was not granted.');
        return null;
      }
    } catch (e) {
      print('Error selecting image: $e');
      return null;
    }
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
  final List<dynamic> tourHighlight;
  final List<dynamic> availability;

  UserViewTourList(this.tourName, this.tourID, this.image, this.agency, this.tourHighlight, this.availability);
}

class MessageList{
  final String receiverName;
  final String receiverProfile;
  final String receiverID;
  final String latestMessage;

  MessageList(this.receiverName, this.receiverProfile, this.receiverID, this.latestMessage);
}

class CarBrand{
  final String carId;
  final String carImage;
  final String carName;

  CarBrand(this.carId, this.carImage, this.carName);
}
