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
  static const countries = <String>[
    'Great Britain',
    'Brazil',
    'Australia',
    'Monaco'
  ];
  static const countryCode = <int>[826, 76, 36, 492];

  @override
  FutureOr<Map<String, Weather>> build() {
    getWeather();
    return {};
  }

  Future<void> getWeather() async {
    state = const AsyncLoading();
    final geocodingRepository = ref.read(GeocodingRepository.provider);
    final weatherRepository = ref.read(WeatherRepository.provider);
    final Map<String, Weather> weatherMap = {};

    try {
      for (final (index, city) in cities.indexed) {
        final loc = await geocodingRepository.getCityLocation(
            cityName: city, countryCode: countryCode[index]);
        weatherMap[city] = await weatherRepository.getCurrentWeather(loc);
      }
    } on Exception catch (e) {
      print('exception: $e');
    }
    state = await AsyncValue.guard(() async {
      return weatherMap;
    });
  }

  static final provider =
      AsyncNotifierProvider<ConcertsPageController, Map<String, Weather>>(
          () => ConcertsPageController());
}
