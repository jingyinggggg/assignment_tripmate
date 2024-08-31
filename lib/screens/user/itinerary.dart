import 'package:flutter/material.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {

  int currentPageIndex = 0;

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
                  width: 200,
                  height: 200,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 180,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: (){}, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF467BA1),
                            textStyle: const TextStyle(
                              fontSize: 18,
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
                        width: 180,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: (){}, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF467BA1),
                            textStyle: const TextStyle(
                              fontSize: 18,
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