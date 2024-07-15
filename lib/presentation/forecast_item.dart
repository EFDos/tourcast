import 'package:flutter/material.dart';
import 'package:tourcast/presentation/weather_icon.dart';

class ForecastItem extends StatelessWidget {
  final double temperature;
  final double min;
  final double max;
  final int conditionId;
  const ForecastItem(
      {required this.temperature,
      required this.min,
      required this.max,
      required this.conditionId,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          WeatherIcon(conditionId: conditionId),
          Text(temperature.toString()),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          Text(max.toString()),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          Text(min.toString()),
        ],
      ),
    );
  }
}
