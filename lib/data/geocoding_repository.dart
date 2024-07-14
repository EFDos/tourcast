import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tourcast/domain/geocoordinates.dart';

class GeocodingRepository {
  static const String _baseUrl = 'api.openweathermap.org';
  static const String _api = '/geo/1.0';
  static const String _direct = '/direct';

  final http.Client client;
  final String apiKey;

  GeocodingRepository({required this.client, required this.apiKey});
  Future<GeoCoordinates> getCityLocation(
      {required String cityName, required int countryCode}) async {
    cityName.replaceAll(' ', '\\');

    try {
      final url = Uri.http(_baseUrl, _api + _direct, {
        'q': '$cityName,$countryCode',
        'limit': '1',
        'appid': apiKey,
      });
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return GeoCoordinates.fromJson(decoded[0]);
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
