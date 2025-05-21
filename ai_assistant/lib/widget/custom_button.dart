import 'package:ai_assistant/helper/global.dart';
import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CustomBtn({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.blue),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          minimumSize: WidgetStateProperty.all(Size(mq.width * .4, 50)),
        ),
        onPressed: onTap,

        child: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
