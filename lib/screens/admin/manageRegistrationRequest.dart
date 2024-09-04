import 'package:assignment_tripmate/screens/admin/registrationRequest.dart';
import 'package:flutter/material.dart';

class AdminManageRegistrationRequestScreen extends StatefulWidget {
  final String userId;
  final String TAId;

  const AdminManageRegistrationRequestScreen({super.key, required this.userId, required this.TAId});

  @override
  State<AdminManageRegistrationRequestScreen> createState() => _AdminManageRegistrationRequestScreenState();
}

class _AdminManageRegistrationRequestScreenState extends State<AdminManageRegistrationRequestScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar( 
        title: Text("Registration Request"), 
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => RegistrationRequestScreen(userId: widget.userId))
            );
          },
        ),
      )
    );
  }
}