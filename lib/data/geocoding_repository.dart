import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/environment/environment.dart';
import 'package:tourcast/domain/geocoordinates.dart';
import 'package:tourcast/exceptions/exceptions.dart';

/// [GeocodingRepository]
/// Uses OpenWeather Geocoding API to fetch Geocoordinates
/// from a city name and optionally country code.
class GeocodingRepository {
  static const String _baseUrl = 'api.openweathermap.org';
  static const String _api = '/geo/1.0';
  static const String _direct = '/direct';

  final http.Client client;
  final String apiKey;

  /// Http [client] and [apiKey] must be provided
  GeocodingRepository({required this.client, required this.apiKey});

  /// Get geocoordinates from [cityName]
  /// Although [countryCode] is required as parameter, it's not
  /// always necessary to provide the correct code.
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
        if (decoded is! List<dynamic> || decoded.isEmpty) {
          throw const FormatException('Invalid Json: empty result');
        }
        return GeoCoordinates.fromJson(decoded[0]);
      } else {
        throw HttpException(
            'Http error: ${response.statusCode}: ${response.body}');
      }
    } on SocketException catch (_) {
      throw const NoInternetException();
    }
  }

  static final provider = Provider<GeocodingRepository>((ref) {
    final client = http.Client();
    return GeocodingRepository(client: client, apiKey: Environment.apiKey);
  });
}
