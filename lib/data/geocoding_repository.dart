import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tourcast/domain/geocoordinates.dart';

class GeocodingRepository {
  static const String _endpoint = 'api.openweathermap.org';
  static const String _apiPath = '/geo/1.0/direct';

  final http.Client client;
  final String apiKey;

  GeocodingRepository({required this.client, required this.apiKey});
  Future<GeoCoordinates> getCityLocation(
      String cityName, int countryCode) async {
    cityName.replaceAll(' ', '\\');

    try {
      final response =
          await client.get(Uri.http(_endpoint, _apiPath), headers: {
        'q': '$cityName,$countryCode',
        'limit': '1',
        'appid': apiKey,
      });

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return GeoCoordinates.fromJson(decoded[0]);
      } else {
        throw StateError;
      }
    } on SocketException catch (_) {
      stderr.writeln('TODO: Handle no internet connection');
      exit(-1);
    }
  }
}
