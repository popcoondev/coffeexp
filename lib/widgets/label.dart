import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String mainText;
  final String subText;
  final bool isRequired;

  Label({required this.mainText, required this.subText, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        Row(
          children: [
            Text(mainText, 
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(width: 8),
            Text(subText, 
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).primaryColor,
              ),
            ),
            // 入力必須の場合は赤い星を表示
            if (isRequired) Text(' * ', style: TextStyle(color: const Color.fromARGB(180, 244, 67, 54), fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}