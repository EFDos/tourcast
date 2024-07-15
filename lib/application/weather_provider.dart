import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/data/geocoding_repository.dart';
import 'package:tourcast/data/weather_repository.dart';
import 'package:tourcast/data/local_weather_repository.dart';
import 'package:tourcast/domain/weather.dart';
import 'package:tourcast/domain/forecast.dart';

class WeatherProvider {
  final Map<String, Forecast> _forecastTable = {};
  final GeocodingRepository _geocodingRepository;
  final WeatherRepository _weatherRepository;
  final LocalWeatherRepository _localWeatherRepository;

  WeatherProvider(
      GeocodingRepository geocodingRepository,
      WeatherRepository weatherRepository,
      LocalWeatherRepository localWeatherRepository)
      : _geocodingRepository = geocodingRepository,
        _weatherRepository = weatherRepository,
        _localWeatherRepository = localWeatherRepository;

  FutureOr<Forecast> getForecast(String cityName,
      {int countryCode = 0}) async {
    final inMemoryForecast = _forecastTable[cityName];
    if (inMemoryForecast != null) {
      return inMemoryForecast;
    }

    final localForecast = await _localWeatherRepository.getForecast(cityName);
    if (localForecast.weatherForecast.isNotEmpty) {
      _forecastTable[cityName] = localForecast;
      return localForecast;
    }

    final cityLocation = await _geocodingRepository.getCityLocation(
        cityName: cityName, countryCode: countryCode);

    try {
      final remoteForecast = await _weatherRepository.getForecast(cityLocation);
      _localWeatherRepository.saveForecast(cityName, remoteForecast);
      _forecastTable[cityName] = remoteForecast;
      return remoteForecast;
    } on Exception catch (_) {
      return Forecast(weatherForecast: [], time: DateTime.now());
    }
  }

  static final provider = Provider<WeatherProvider>((ref) {
    final geocodingRepo = ref.read(GeocodingRepository.provider);
    final weatherRepo = ref.read(WeatherRepository.provider);
    final localWeatherRepo = ref.read(LocalWeatherRepository.provider);

    return WeatherProvider(geocodingRepo, weatherRepo, localWeatherRepo);
  });
}
