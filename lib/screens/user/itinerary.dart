import 'package:assignment_tripmate/screens/user/itineraryAI.dart';
import 'package:flutter/material.dart';

class ItineraryScreen extends StatefulWidget {
  final String userId;
  const ItineraryScreen({super.key, required this.userId});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("images/itineraryPic.png"),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                ),
                SizedBox(height: 20,),
                Container(
                  width: 380,
                  child: Text(
                    "You do not create any itinerary yet. Start to create your itinerary now with own idea or build with AI.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => AIItineraryScreen(userId: widget.userId,))
                            );
                          }, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF467BA1),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Build with AI",
                            style: TextStyle(
                              color: Colors.white,
                            ),

                          )
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (){}, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF467BA1),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Create own trip",
                            style: TextStyle(
                              color: Colors.white,
                            ),

                          )
                        ),
                      )
                    ],
                  ),
                )
                
              ],
            ),
          )
        ],
      ),
    );
  }



}