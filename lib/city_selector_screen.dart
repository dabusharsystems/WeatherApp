import 'package:flutter/material.dart';

class CitySelectionScreen extends StatelessWidget {
  final List<String> cities = ['New York', 'London', 'Nairobi', 'Tokyo','Nigeria'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select your City')),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cities[index]),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/weather',
                arguments: cities[index],
              );
            },
          );
        },
      ),
    );
  }
}
