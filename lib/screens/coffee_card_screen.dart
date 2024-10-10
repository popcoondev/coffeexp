//CoffeeCardScreen

import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:countries_world_map/countries_world_map.dart';

class CoffeeCardScreen extends StatelessWidget {
  final Map<String, dynamic> coffeeData;

  CoffeeCardScreen({required this.coffeeData});

  @override
  Widget build(BuildContext context) {
    // 国名から国コードを取得
    String? countryName = coffeeData['country'];
    // String? countryCode = countryName != null ? 

    return Scaffold(
      appBar: AppBar(
        title: Text(coffeeData['coffeeName'] ?? 'No name'),
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
            SizedBox(height: 16.0),
            Text('Country: ${coffeeData['country'] ?? 'No country'}'),
            SizedBox(height: 16.0),
            Expanded(
              child: SimpleMap(
                instructions: SMapJapan.instructions,
                defaultColor: Colors.grey,       

                )
            ),
          ],
        ),
      ),
    );
  }
}