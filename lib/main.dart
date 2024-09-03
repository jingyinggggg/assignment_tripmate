import 'package:assignment_tripmate/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:assignment_tripmate/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Disable App Check for Firebase Storage
  // FirebaseStorage.instance.useStorageEmulator('localhost', 9199); 

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build (BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEDF2F6),
      ),
      home: const WelcomeScreen(),
    );
  }
}

