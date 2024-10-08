import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String mainText;
  final String subText;
  final bool isRequired;

  Label({required this.mainText, required this.subText, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(mainText, style: TextStyle(fontSize: 16)),
        SizedBox(width: 8),
        Text(subText, style: TextStyle(fontSize: 12)),
        // 入力必須の場合は赤い星を表示
        if (isRequired) Text('*', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}