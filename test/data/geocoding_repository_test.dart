import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart' as http;
import 'package:tourcast/environment/environment.dart';
import 'package:tourcast/data/geocoding_repository.dart';
import 'package:tourcast/domain/geocoordinates.dart';

const responseJson = '''
[
{
"name":"London",
"lat":51.5073219,
"lon":-0.1276474,
"country":"GB",
"state":"England"
}
]
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('geocoding repository response test', () async {
    final client = http.MockClient((request) async {
      return Response(responseJson, 200, request: request);
    });

    final repository = GeocodingRepository(
        client: client, apiKey: await Environment.getApiKey());

    GeoCoordinates geoCoords =
        await repository.getCityLocation(cityName: 'Sao Paulo', countryCode: 55);
    expect(geoCoords, GeoCoordinates(latitude: 51.5073219, longitude: -0.1276474));
  });
}
