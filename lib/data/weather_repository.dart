import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/domain/geocoordinates.dart';
import 'package:tourcast/domain/weather.dart';
import 'package:tourcast/domain/forecast.dart';
import 'package:tourcast/environment/environment.dart';
import 'package:tourcast/exceptions/exceptions.dart';

class WeatherRepository {
  static const String _baseUrl = 'api.openweathermap.org';
  static const String _api = '/data/2.5';
  static const String _weather = '/weather';
  static const String _forecast = '/forecast';

  final http.Client client;
  final String apiKey;

  WeatherRepository({required this.client, required this.apiKey});

  Future<Weather> getCurrentWeather(GeoCoordinates geocoordinates) async {
    final url = Uri.https(_baseUrl, _api + _weather, {
      'lat': geocoordinates.latitude.toString(),
      'lon': geocoordinates.longitude.toString(),
      'units': 'metric',
      'appid': apiKey,
    });

    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return Weather.fromJson(decoded);
      } else {
        throw HttpException(
            'Http error: ${response.statusCode}: ${response.body}');
      }
    } on SocketException catch (_) {
      throw const NoInternetException();
    }
  }

  Future<Forecast> getForecast(GeoCoordinates geocoordinates) async {
    final url = Uri.https(_baseUrl, _api + _forecast, {
      'lat': geocoordinates.latitude.toString(),
      'lon': geocoordinates.longitude.toString(),
      'units': 'metric',
      'appid': apiKey,
    });

    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return Forecast.fromJson(decoded);
      } else {
        throw HttpException(
            'Http error: ${response.statusCode}: ${response.body}');
      }
    } on SocketException catch (_) {
      stderr.writeln('TODO: Handle no internet connection');
      exit(-1);
    }
  }

  static final provider = Provider<WeatherRepository>((ref) {
    final client = http.Client();
    return WeatherRepository(client: client, apiKey: Environment.apiKey);
  });
}
