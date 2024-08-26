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
    required Uint8List file,
  }) async{
    String resp = "Some Error Occurred";
    try{
      String fileName = "$name.jpg"; 
      String imageURL = await uploadImageToStorage("profile_images/$fileName", file);
      await _firestore.collection("users").doc(userId).update({
        'name': name,
        'username': username,
        'email': email,
        'contact': contact,
        'address': address,
        'profileImage': imageURL
      });
      resp = "Success";
    } catch(err){
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
    required int TAid, 
    required String email,
    required DateTime dob,
    required String companyContact, 
    required String companyName,
    required String password,
    required String gender,
    required Uint8List employeeCard,
  }) async{
    String resp = "Some Error Occurred";
    try{
      String fileName = "$name-$companyName.jpg"; 
      String imageURL = await uploadImageToStorage("travelAgent/$fileName", employeeCard);
      await _firestore.collection("travelAgent").doc(email).set({
        'id': TAid,
        'name': name,
        'username': null,
        'email': email,
        'dob': dob,
        'companyContact': companyContact,
        'companyName': companyName,
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