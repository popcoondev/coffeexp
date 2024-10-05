import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String mainText;
  final String subText;

  Label({required this.mainText, required this.subText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(mainText, style: TextStyle(fontSize: 16)),
        SizedBox(width: 8),
        Text(subText, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}