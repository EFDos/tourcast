import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tourcast/data/local_weather_repository.dart';
import 'package:tourcast/domain/weather.dart';
import 'package:tourcast/domain/forecast.dart';

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
    var baseForecast =
        Forecast(
          weatherForecast: [Weather(temperature: 33.2, description: 'very hot oh dear')],
          time: DateTime.now()
        );
    await repository.saveForecast('Sao Paulo', baseForecast);

    var retrievedForecast = await repository.getForecast('Sao Paulo');
    expect(retrievedForecast, baseForecast);

    baseForecast = Forecast(
      weatherForecast: [Weather(temperature: 16.5, description: 'rainy')],
      time: DateTime.now()
    );
    await repository.saveForecast('Monte Carlo', baseForecast);

    retrievedForecast = await repository.getForecast('Monte Carlo');
    expect(retrievedForecast, baseForecast);
  });

  test('local weather repository save forecast', () async {
    final baseForecast = Forecast(weatherForecast: <Weather>[
      Weather(description: 'rainy', temperature: 15.0),
      Weather(description: 'rainy', temperature: 12.0),
      Weather(description: 'rainy', temperature: 13.0),
      Weather(description: 'sunny', temperature: 22.0),
      Weather(description: 'sunny', temperature: 25.0),
    ], time: DateTime.now());

    await repository.saveForecast('Silverstone', baseForecast);
    final retrieved = await repository.getForecast('Silverstone');
    expect(baseForecast, retrieved);
  });
}
