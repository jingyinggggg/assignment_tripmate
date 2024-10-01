import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/user/localBuddyHomepage.dart';
import 'package:flutter/material.dart';

class LocalBuddyDetailsScreen extends StatefulWidget{
  final String userId;
  final String localBuddyId;

  const LocalBuddyDetailsScreen({
    super.key,
    required this.userId,
    required this.localBuddyId
  });

  @override
  State<StatefulWidget> createState() => _LocalBuddyDetailsScreenState();
}

class _LocalBuddyDetailsScreenState extends State<LocalBuddyDetailsScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar( 
          title: Text("Local Buddy"), 
          centerTitle: true,
          backgroundColor: const Color(0xFF749CB9),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Inika',
            fontWeight: FontWeight.bold,
            fontSize: defaultAppBarTitleFontSize,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => LocalBuddyHomepageScreen(userId: widget.userId))
              );
            },
          ),
      )
    );
  }
}