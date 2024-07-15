import 'package:flutter/material.dart';

class CityWeatherItem extends StatelessWidget {
  final String cityName;
  final String country;
  final String description;
  final double temperature;

  const CityWeatherItem(
      {required this.cityName,
      required this.country,
      this.temperature = 0.0,
      this.description = '',
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue.shade50,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.sunny),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('$cityName, $country'),
          ),
          temperature == 0.0
              ? const CircularProgressIndicator.adaptive()
              : Text(temperature.toString()),
          Text(description)
        ],
      ),
    );
  }
}
