import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'weather.dart';

/// [Forecast] Model class
/// Holds data up to 5 days
class Forecast {
  /// Maximum daily forecast
  static const dailyForecastMax = 5;

  /// Since samples are provide in a 3 hour interval, each day is comprised of 8 [dailySamples]
  static const dailySamples = 8;

  /// List up to 5 [Weather] samples
  final List<Weather> weatherForecast;

  const Forecast({required this.weatherForecast});

  /// Factory [Forecast] from a Json object
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
    for (var i = 0; i < weatherListData.length / dailySamples; ++i) {
      double min = double.maxFinite, max = 0;
      for (var j = 0; j < dailySamples; ++j) {
        min = math.min(min,
            weatherListData[hourlyOffset + j]['main']['temp_min'] as double);
        max = math.max(max,
            weatherListData[hourlyOffset + j]['main']['temp_max'] as double);
      }
      weatherForecast.add(Weather.fromJson(weatherListData[hourlyOffset])
          .copyWith(min: min, max: max));
      hourlyOffset += 8;
    }

    return Forecast(weatherForecast: weatherForecast);
  }

  @override
  bool operator ==(Object other) {
    return other is Forecast &&
        listEquals(weatherForecast, other.weatherForecast);
  }

  @override
  int get hashCode => Object.hashAll(weatherForecast);
}
