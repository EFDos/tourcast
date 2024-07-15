import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/application/weather_provider.dart';
import 'package:tourcast/domain/weather.dart';

class ForecastPageController extends AsyncNotifier<List<Weather>> {
  @override
  FutureOr<List<Weather>> build() {
    return [];
  }

  Future<void> getWeather(String cityName, int countryCode) async {
    state = const AsyncLoading();
    final weatherProvider = ref.read(WeatherProvider.provider);

    final forecast = await weatherProvider.getForecast(cityName, countryCode: countryCode);
    state = await AsyncValue.guard(() async {
      return forecast.weatherForecast;
    });
  }

  static final provider =
      AsyncNotifierProvider<ForecastPageController, List<Weather>>(
          () => ForecastPageController());
}
