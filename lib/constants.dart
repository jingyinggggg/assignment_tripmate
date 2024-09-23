import 'package:flutter/material.dart';

const String apiKey = "AIzaSyCHTQkSfA59c9agWbthQ-w1X4YxcQLxpYo";

const Color primaryColor = Color(0xFF467BA1);
const Color secondaryColor = Colors.black54;
const defaultFontSize = 14.0;
const defaultLabelFontSize = 16.0;

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

// Method to show a dialog with a title and content
void showCustomDialog({
  required BuildContext context,  // Pass context from the caller
  required String title,
  required String content,
  required VoidCallback onPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: onPressed,
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}