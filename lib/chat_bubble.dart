import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget{
  final String message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFF467BA1).withOpacity(0.2)
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}