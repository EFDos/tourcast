import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tourcast/domain/geocoordinates.dart';

void main() {
  test('geocoordinates equality', () {
    final geoCoordsA = GeoCoordinates(latitude: 0.525, longitude: 1.25);
    final geoCoordsB = GeoCoordinates(latitude: 0.525, longitude: 1.25);
    expect(geoCoordsA, equals(geoCoordsB));

    final geoCoordsC = GeoCoordinates(latitude: 0.425, longitude: -1.25);
    expect(geoCoordsA, isNot(equals(geoCoordsC)));
  });

  test('geocoordinates convert success', () {
    final geoCoords =
        GeoCoordinates.fromJson(json.decode('{"lat": 0.425, "lon": -1.25}'));
    expect(geoCoords.latitude, 0.425);
    expect(geoCoords.longitude, -1.25);
  });

  test('geocoordinates convert fail', () {
    expect(() => GeoCoordinates.fromJson(json.decode('{}')),
        throwsA(isA<FormatException>()));
    expect(
        () => GeoCoordinates.fromJson(
            json.decode('{"lat": "whatto", "lon": "expect?"}')),
        throwsA(isA<FormatException>()));
  });
}
