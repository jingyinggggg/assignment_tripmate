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
      String fileName = "$name.jpg"; // You can adjust the file extension as needed
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
}