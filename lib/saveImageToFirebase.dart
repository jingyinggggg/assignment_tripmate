import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async{
    
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;

  }

  Future<String> updateUserProfile({
    required String userId,
    required String name,
    required String username,
    required String email,
    required String contact,
    required String address,
    Uint8List? file, // Make file nullable
  }) async {
    String resp = "Some Error Occurred";
    try {
      String? imageURL;

      if (file != null) {
        String fileName = "$userId($name).jpg";
        imageURL = await uploadImageToStorage("profile_images/users/$fileName", file);
      }

      // Prepare the update data
      Map<String, dynamic> updateData = {
        'name': name,
        'username': username,
        'email': email,
        'contact': contact,
        'address': address,
      };

      // Add profileImage to updateData only if it's not null
      if (imageURL != null) {
        updateData['profileImage'] = imageURL;
      }

      // Update the Firestore document
      await _firestore.collection("users").doc(userId).update(updateData);

      resp = "Success";
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  Future<String> updateTravelAgentProfile({
    required String userId, 
    required String name, 
    required String username, 
    required String email, 
    required String companyName, 
    required String companyContact, 
    required String companyAddress, 
    Uint8List? file, // Make file parameter optional
  }) async {
    String resp = "Some Error Occurred";
    try {
      String? imageURL;

      if (file != null) {
        String fileName = "$userId($name).jpg"; 
        imageURL = await uploadImageToStorage("profile_images/travelAgent/$fileName", file);
      }

      // Build the update data map with only non-null values
      Map<String, dynamic> updateData = {
        'name': name,
        'username': username,
        'email': email,
        'companyName': companyName,
        'companyContact': companyContact,
        'companyAddress': companyAddress,
      };

      // Only include 'profileImage' if a new image is provided
      if (imageURL != null) {
        updateData['profileImage'] = imageURL;
      }

      await _firestore.collection("travelAgent").doc(userId).update(updateData);
      resp = "Success";
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  Future<String> saveCountryData({
    required String country, 
    required String countryID, 
    required Uint8List file,
  }) async{
    String resp = "Some Error Occurred";
    try{
      String fileName = "$country.jpg"; 
      String imageURL = await uploadImageToStorage("countries/$country/$fileName", file);
      await _firestore.collection("countries").doc(country).set({
        'name': country,
        'countryID': countryID,
        'countryImage': imageURL
      });
      resp = "Success";
    } catch(err){
      resp = err.toString();
    }
    return resp;
  }

  Future<String> saveCityData({
    required String country, 
    required String city, 
    required String cityID, 
    required Uint8List file,
  }) async{
    String resp = "Some Error Occurred";
    try{
      String fileName = "$city.jpg"; 
      String imageURL = await uploadImageToStorage("countries/$country/$fileName", file);
      await _firestore.collection("countries").doc(country).collection("cities").doc(city).set({
        'city_name': city,
        'cityID': cityID,
        'cityImage': imageURL
      });
      resp = "Success";
    } catch(err){
      resp = err.toString();
    }
    return resp;
  }

  Future<String> saveTAData({
    required String name, 
    required String TAid, 
    required String email,
    required DateTime dob,
    required String companyContact, 
    required String companyName,
    required String companyAddress,
    required String password,
    required String gender,
    required Uint8List employeeCard,
  }) async{
    String resp = "Some Error Occurred";
    try{
      String fileName = "$TAid-$companyName.jpg"; 
      String imageURL = await uploadImageToStorage("travelAgent(employee card)/$fileName", employeeCard);
      await _firestore.collection("travelAgent").doc(TAid).set({
        'id': TAid,
        'name': name,
        'username': null,
        'email': email,
        'dob': dob,
        'companyContact': companyContact,
        'companyName': companyName,
        'companyAddress': companyAddress,
        'password': password,
        'gender': gender,
        'accountApproved': 0,
        'employeCardPath': imageURL
      });
      resp = "Success";
    } catch(err){
      resp = err.toString();
    }
    return resp;
  }
}