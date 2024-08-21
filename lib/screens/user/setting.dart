import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Setting"),
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
            Navigator.pop(context);
          },
        ),
      ),

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/account_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color(0xFFEDF2F6).withOpacity(0.6),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 30, left: 10), // Space before the container
            child: Container(
              width: 150,
              height: 150,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Jing Ying",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    Icons.account_circle_rounded,
                    color: Color(0xFF467BA1),
                    size: 100.0,
                  ),
                  
                ],
              ),
            ),
          ),

          Positioned(
            top: 55,
            left: 30,
            child: Image(
              image: const AssetImage("images/route line.png"),
              height: 200,
              width: 340,
            ),
          ),

          Positioned(
            top: 40,
            left: 320,
            child: Column(
              children: [
                const Text(
                  "Setting",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Image.asset(
                  'images/location-pin.png',
                  width: 50,
                  height: 50,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 260, left: 10, right: 10), // Space before the container
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle navigation or other actions here.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Color(0xFF467BA1), width: 3),
                    ),
                    minimumSize: const Size(120, 65),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.lock,
                        color: Colors.black,
                        size: 25,
                      ),
                      SizedBox(width: 15),

                      SizedBox(
                        width: 270,
                        child: Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    // Handle navigation or other actions here.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Color(0xFF467BA1), width: 3),
                    ),
                    minimumSize: const Size(120, 65),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                        size: 25,
                      ),
                      SizedBox(width: 15),

                      SizedBox(
                        width: 270,
                        child: Text(
                          "Delete Account",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    // Handle navigation or other actions here.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Color(0xFF467BA1), width: 3),
                    ),
                    minimumSize: const Size(120, 65),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      ImageIcon(
                        AssetImage("images/leave_feedback.png"),  // The path to your image asset
                        color: Colors.black,  // Set the color of the image icon
                        size: 25,  // Set the size of the image icon
                      ),

                      SizedBox(width: 15),

                      SizedBox(
                        width: 270,
                        child: Text(
                          "Leave a feedback",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
