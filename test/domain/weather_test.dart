import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tourcast/domain/weather.dart';

void main() {
  test('weather equality', () {
    final weatherA = Weather(description: 'A', temperature: 42.0, min: 40.0, max: 43.0);
    final weatherB = Weather(description: 'A', temperature: 42.0, min: 40.0, max: 43.0);
    expect(weatherA, weatherB);

    final weatherC = Weather(description: 'C', temperature: 16, min: 15, max: 17);
    expect(weatherA, isNot(equals(weatherC)));
  });

  test('weather convert success', () {
    final weather = Weather.fromJson(json.decode(
        '{"weather": [{ "description": "light rain" }], "main": { "temp": 298.48 }}'));
    expect(weather, Weather(description: "light rain", temperature: 298.48));
  });

  test('weather convert fail', () {
    expect(() => Weather.fromJson(json.decode('')),
        throwsA(isA<FormatException>()));
    expect(() => Weather.fromJson(json.decode('{}')),
        throwsA(isA<FormatException>()));
    expect(
        () =>
            Weather.fromJson(json.decode('{"main": { "temp": "dummyValue" }}')),
        throwsA(isA<FormatException>()));
    expect(
        () => Weather.fromJson(
            json.decode('{"weather": { "description": "dummyValue" }}')),
        throwsA(isA<FormatException>()));
  });
}
