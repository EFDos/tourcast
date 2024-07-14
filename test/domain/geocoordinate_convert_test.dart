import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tourcast/domain/geocoordinates.dart';

void main() {
  test('geocoordinates convert success', () {
    final geoCoords =
        GeoCoordinates.fromJson(json.decode('{"lat": 0.425, "lon": -1.25}'));
    expect(geoCoords.latitude, 0.425);
    expect(geoCoords.longitude, -1.25);
  });

  test('geocoordinates convert fail', () {
    expect(() => GeoCoordinates.fromJson(json.decode('{}')), throwsA(isA<FormatException>()));
    expect(() => GeoCoordinates.fromJson(
        json.decode('{"lat": "whatto", "lon": "expect?"}')), throwsA(isA<FormatException>()));
  });
}
