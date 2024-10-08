//CoffeeCardScreen

import 'package:flutter/material.dart';

class CoffeeCardScreen extends StatelessWidget {
  final Map<String, dynamic> coffeeData;

  CoffeeCardScreen({required this.coffeeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(coffeeData['name'] ?? 'No name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Roast level: ${coffeeData['roastLevel'] ?? 'No level'}'),
            SizedBox(height: 16.0),
            Text('Price: ${coffeeData['price'] ?? 'No price'}'),
            SizedBox(height: 16.0),
            Text('Description: ${coffeeData['description'] ?? 'No description'}'),
          ],
        ),
      ),
    );
  }
}