import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tourcast/domain/geocoordinates.dart';
import 'package:tourcast/domain/weather.dart';

class WeatherRepository {
  static const String _baseUrl = 'api.openweathermap.org';
  static const String _api = '/data/2.5';
  static const String _weather = '/weather';

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
      stderr.writeln('TODO: Handle no internet connection');
      exit(-1);
    }
  }
}
