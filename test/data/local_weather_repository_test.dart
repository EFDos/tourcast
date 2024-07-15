import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tourcast/data/local_weather_repository.dart';
import 'package:tourcast/domain/weather.dart';

void main() {
  late final LocalWeatherRepository repository;
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    repository = LocalWeatherRepository();
  });

  tearDownAll(() {
    repository.clear();
  });

  test('local weather repository save current', () async {
    var baseWeather =
        Weather(temperature: 33.2, description: 'very hot oh dear');
    await repository.saveForecast('Sao Paulo', [baseWeather]);

    var retrievedWeather = await repository.getForecast('Sao Paulo');
    expect(retrievedWeather.length, 1);
    expect(retrievedWeather[0], baseWeather);

    baseWeather = Weather(temperature: 16.5, description: 'rainy');
    await repository.saveForecast('Monte Carlo', [baseWeather]);

    retrievedWeather = await repository.getForecast('Monte Carlo');
    expect(retrievedWeather.length, 1);
    expect(retrievedWeather[0], baseWeather);
  });

  test('local weather repository save forecast', () async {
    final baseForecast = <Weather>[
      Weather(description: 'rainy', temperature: 15.0),
      Weather(description: 'rainy', temperature: 12.0),
      Weather(description: 'rainy', temperature: 13.0),
      Weather(description: 'sunny', temperature: 22.0),
      Weather(description: 'sunny', temperature: 25.0),
    ];

    await repository.saveForecast('Silverstone', baseForecast);
    final retrieved = await repository.getForecast('Silverstone');
    expect(baseForecast, retrieved);
  });
}
