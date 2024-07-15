import 'package:flutter/material.dart';
import 'package:tourcast/presentation/weather_icon.dart';

class CityWeatherItem extends StatelessWidget {
  final String cityName;
  final String country;
  final String description;
  final double temperature;
  final int conditionId;

  const CityWeatherItem(
      {required this.cityName,
      required this.country,
      this.temperature = 0.0,
      this.description = '',
      this.conditionId = 0,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue.shade100,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: WeatherIcon(conditionId: conditionId),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('$cityName, $country'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: temperature == 0.0
                ? const CircularProgressIndicator.adaptive()
                : Text('${temperature.toString()}º C'),
          ),
        ],
      ),
    );
  }
}
