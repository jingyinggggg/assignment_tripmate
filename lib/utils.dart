import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

class TravelAgent{
  final String name;
  final String companyName;
  final int id;
  final String image;

  TravelAgent(this.name, this.companyName, this.id, this.image);
}
