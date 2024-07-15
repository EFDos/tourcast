import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/data/geocoding_repository.dart';
import 'package:tourcast/data/weather_repository.dart';
import 'package:tourcast/domain/weather.dart';

class ForecastPageController extends AsyncNotifier<List<Weather>> {
  @override
  FutureOr<List<Weather>> build() {
    return [];
  }

  Future<void> getWeather(String cityName, int countryCode) async {
    state = const AsyncLoading();
    final geocodingRepository = ref.read(GeocodingRepository.provider);
    final weatherRepository = ref.read(WeatherRepository.provider);

    try {
      final loc = await geocodingRepository.getCityLocation(
          cityName: cityName, countryCode: countryCode);
      final forecast = await weatherRepository.getForecast(loc);
      state = await AsyncValue.guard(() async {
        return forecast;
      });
    } on Exception catch (e) {
      print('exception: $e');
    }
  }

  static final provider =
      AsyncNotifierProvider<ForecastPageController, List<Weather>>(
          () => ForecastPageController());
}
