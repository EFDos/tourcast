import 'package:flutter/material.dart';
import 'package:tourcast/presentation/widgets/weather_icon.dart';

/// Widget for each sample in Forecast list
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
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            WeatherIcon(conditionId: conditionId),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
            Text(temperature.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
            const Icon(Icons.keyboard_arrow_up, color: Colors.orange),
            Text(max.toString()),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
            const Icon(Icons.keyboard_arrow_down, color: Colors.lightBlue),
            Text(min.toString()),
          ],
        ),
      ),
    );
  }
}
