import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/domain/weather.dart';
import 'package:tourcast/data/geocoding_repository.dart';
import 'package:tourcast/data/weather_repository.dart';

class ConcertsPageController extends AsyncNotifier<Map<String, Weather>> {
  static const cities = <String>[
    'Silverstone',
    'Sao Paulo',
    'Melbourne',
    'Monte Carlo'
  ];
  static const countries = <String>['UK', 'Brazil', 'Australia', 'Monaco'];

  @override
  FutureOr<Map<String, Weather>> build() {
    getWeather();
    return {};
  }

  Future<void> getWeather() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final geocodingRepository = ref.read(GeocodingRepository.provider);
      final weatherRepository = ref.read(WeatherRepository.provider);
      final Map<String, Weather> weatherMap = {};

      try {
        for (final city in cities) {
          final loc = await geocodingRepository.getCityLocation(
              cityName: city, countryCode: 55);
          weatherMap[city] = await weatherRepository.getCurrentWeather(loc);
        }
      } on Exception catch (e) {
        print('exception: $e');
      }
      return weatherMap;
    });
  }

  static final provider =
      AsyncNotifierProvider<ConcertsPageController, Map<String, Weather>>(
          () => ConcertsPageController());
}
