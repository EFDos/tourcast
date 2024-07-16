import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/data/geocoding_repository.dart';
import 'package:tourcast/data/weather_repository.dart';
import 'package:tourcast/data/local_weather_repository.dart';
import 'package:tourcast/domain/weather.dart';
import 'package:tourcast/domain/forecast.dart';
import 'connection_checker.dart';

/// [WeatherProvider]
/// Handles logic between available repositories:
/// [GeocodingRepository], [WeatherRepository], [LocalWeatherRepository]
/// when data is avaialable through LocalWeatherRepository, new remote
/// data will only be acquired when time from last update is greater
/// than [minMinutesDelay].
///
/// [GeocodingRepository] is used only to fetch GeoCoordinates from
/// a City's name.
class WeatherProvider {
  static const minMinutesDelay = 10;

  final Map<String, Forecast> _forecastTable = {};
  final GeocodingRepository _geocodingRepository;
  final WeatherRepository _weatherRepository;
  final LocalWeatherRepository _localWeatherRepository;

  /// Used to reference ConnectionChecker provider
  final Ref _ref;

  WeatherProvider(
      GeocodingRepository geocodingRepository,
      WeatherRepository weatherRepository,
      LocalWeatherRepository localWeatherRepository,
      Ref ref)
      : _geocodingRepository = geocodingRepository,
        _weatherRepository = weatherRepository,
        _localWeatherRepository = localWeatherRepository,
        _ref = ref;

  /// Get most recent [Forecast] in local storage or fetch new
  /// data from remote when time since [lastUpdate] is greater than [minMinutesDelay]
  FutureOr<Forecast> getForecast(String cityName, {int countryCode = 0}) async {
    final lastUpdate = await _localWeatherRepository.getLastUpdate(cityName);
    if (lastUpdate == null || DateTime.now().minute - lastUpdate.minute > minMinutesDelay) {
      try {
        final cityLocation = await _geocodingRepository.getCityLocation(
            cityName: cityName, countryCode: countryCode);
        final remoteForecast =
            await _weatherRepository.getForecast(cityLocation);
        _localWeatherRepository.saveForecast(cityName, remoteForecast);
        _forecastTable[cityName] = remoteForecast;

        // Notify connection checker
        _ref.read(ConnectionCheckerNotifier.provider.notifier).seedLastUpdate();

        return remoteForecast;
      } catch (_) {}
    }

    final inMemoryForecast = _forecastTable[cityName];
    if (inMemoryForecast != null) {
      return inMemoryForecast;
    }

    final localForecast = await _localWeatherRepository.getForecast(cityName);
    if (localForecast.weatherForecast.isNotEmpty) {
      _forecastTable[cityName] = localForecast;
      return localForecast;
    }

    return const Forecast(weatherForecast: []);
  }

  /// Always fetch current [Weather] from remote unless network is not reachable.
  /// In such case current [Weather] will be provided as the most recent sample
  /// from a [Forecast] in [LocalWeatherRepository] if available
  /// Returns zeroed data if no all sources fail.
  FutureOr<Weather> getCurrent(String cityName, {int countryCode = 0}) async {
    try {
      final cityLocation = await _geocodingRepository.getCityLocation(
          cityName: cityName, countryCode: countryCode);
      final remoteForecast = _weatherRepository.getCurrentWeather(cityLocation);

      // Notify connection checker
      _ref.read(ConnectionCheckerNotifier.provider.notifier).seedLastUpdate();

      return remoteForecast;
    } on Exception catch (_) {
      if (_forecastTable.containsKey(cityName)) {
        return _forecastTable[cityName]!.weatherForecast[0];
      }

      final localForecast = await _localWeatherRepository.getForecast(cityName);
      if (localForecast.weatherForecast.isNotEmpty) {
        _forecastTable[cityName] = localForecast;
        return localForecast.weatherForecast[0];
      }
      return Weather.undefined;
    }
  }

  static final provider = Provider<WeatherProvider>((ref) {
    final geocodingRepo = ref.read(GeocodingRepository.provider);
    final weatherRepo = ref.read(WeatherRepository.provider);
    final localWeatherRepo = ref.read(LocalWeatherRepository.provider);

    return WeatherProvider(geocodingRepo, weatherRepo, localWeatherRepo, ref);
  });
}
