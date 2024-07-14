import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tourcast/domain/weather.dart';

void main() {
  test('weather convert success', () {
    final weather =
        Weather.fromJson(json.decode('{"main": { "temp": 298.48 }}'));
    expect(weather.temperature, 298.48);
  });

  test('weather convert fail', () {
    expect(() => Weather.fromJson(json.decode('{}')),
        throwsA(isA<FormatException>()));
    expect(() => Weather.fromJson(json.decode('{"main": { "temp": "dummyValue" }}')),
        throwsA(isA<FormatException>()));
  });
}
