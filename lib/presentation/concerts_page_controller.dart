import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/constants.dart';
import 'package:tourcast/domain/weather.dart';
import 'package:tourcast/application/weather_provider.dart';

/// Notifies [ConcertsPage] with current weather for all cities
class ConcertsPageController extends AsyncNotifier<Map<String, Weather>> {
  @override
  FutureOr<Map<String, Weather>> build() {
    getWeather();
    return {};
  }

  /// Get current weather for all cities
  Future<void> getWeather() async {
    state = const AsyncLoading();
    final weatherProvider = ref.read(WeatherProvider.provider);
    final Map<String, Weather> weatherMap = {};

    for (final city in Constants.cities) {
      weatherMap[city.name] = await weatherProvider.getCurrent(city.name,
          countryCode: city.countryCode);
    }
    state = AsyncValue.data(weatherMap);
  }

  static final provider =
      AsyncNotifierProvider<ConcertsPageController, Map<String, Weather>>(
          () => ConcertsPageController());
}
