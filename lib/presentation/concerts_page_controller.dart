import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/domain/weather.dart';
import 'package:tourcast/application/weather_provider.dart';

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
    final weatherProvider = ref.read(WeatherProvider.provider);
    final Map<String, Weather> weatherMap = {};

    for (final (index, city) in cities.indexed) {
      weatherMap[city] = await weatherProvider.getCurrent(city,
          countryCode: countryCode[index]);
    }
    state = AsyncValue.data(weatherMap);
  }

  static final provider =
      AsyncNotifierProvider<ConcertsPageController, Map<String, Weather>>(
          () => ConcertsPageController());
}
