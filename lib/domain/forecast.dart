import 'package:flutter/foundation.dart';
import 'weather.dart';

class Forecast {
  static const dailyForecastMax = 5;

  final List<Weather> weatherForecast;
  final DateTime time;

  Forecast({required this.weatherForecast, required this.time});

  factory Forecast.fromJson(Map<String, dynamic> data) {
    final weatherForecast = <Weather>[];
    final weatherListData = data['list'];
    if (weatherListData is! List<dynamic>) {
      throw const FormatException('Invalid Json: Expected "list" as list');
    }
    if (weatherListData.length < 8) {
      throw const FormatException(
          'Invalid Json: Expected "list" length to be at least 8');
    }

    int hourlyOffset = 0;
    for (var i = 0; i < weatherListData.length / 8; ++i) {
      double temp = 0, min = 0, max = 0;
      weatherListData.getRange(hourlyOffset, hourlyOffset + 8).map((e) {
        temp += e['main']['temp'];
        min += e['main']['temp_min'];
        max += e['main']['temp_max'];
      });
      temp /= 8;
      min /= 8;
      max /= 8;
      weatherForecast.add(
          Weather(description: 'shit', temperature: temp, min: min, max: max));
      hourlyOffset += 8;
    }
    //assert(hourlyOffset == 40);
    assert(weatherForecast.isNotEmpty);
    int timestamp = weatherListData[0]['dt'];

    return Forecast(
        weatherForecast: weatherForecast,
        time: DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  @override
  bool operator ==(Object other) {
    return other is Forecast && listEquals(weatherForecast, other.weatherForecast);
  }

  @override
  int get hashCode => Object.hashAll(weatherForecast);
}
