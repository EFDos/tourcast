import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart' as http;
import 'package:tourcast/environment/environment.dart';
import 'package:tourcast/data/weather_repository.dart';
import 'package:tourcast/domain/geocoordinates.dart';
import 'package:tourcast/domain/weather.dart';

const currentWeatherResponseJson = '''
{
  "coord": {
    "lon": 10.99,
    "lat": 44.34
  },
  "weather": [
    {
      "id": 501,
      "main": "Rain",
      "description": "moderate rain",
      "icon": "10d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 298.48,
    "feels_like": 298.74,
    "temp_min": 297.56,
    "temp_max": 300.05,
    "pressure": 1015,
    "humidity": 64,
    "sea_level": 1015,
    "grnd_level": 933
  },
  "visibility": 10000,
  "wind": {
    "speed": 0.62,
    "deg": 349,
    "gust": 1.18
  },
  "rain": {
    "1h": 3.16
  },
  "clouds": {
    "all": 100
  },
  "dt": 1661870592,
  "sys": {
    "type": 2,
    "id": 2075663,
    "country": "IT",
    "sunrise": 1661834187,
    "sunset": 1661882248
  },
  "timezone": 7200,
  "id": 3163858,
  "name": "Zocca",
  "cod": 200
}
''';

const forecastResponseJson = '''
{
"cod": "200",
"message": 0,
"cnt": 40,
"list": [
{
"dt": 1661871600,
"main": {
  "temp": 296.76,
  "feels_like": 296.98,
  "temp_min": 296.76,
  "temp_max": 297.87,
  "pressure": 1015,
  "sea_level": 1015,
  "grnd_level": 933,
  "humidity": 69,
  "temp_kf": -1.11
},
"weather": [
  {
    "id": 500,
    "main": "Rain",
    "description": "light rain",
    "icon": "10d"
  }
],
"dt_txt": "2022-08-30 15:00:00"
},
{
"dt": 1661871600,
"main": {
  "temp": 296.76,
  "feels_like": 296.98,
  "temp_min": 296.76,
  "temp_max": 297.87,
  "pressure": 1015,
  "sea_level": 1015,
  "grnd_level": 933,
  "humidity": 69,
  "temp_kf": -1.11
},
"weather": [
  {
    "id": 500,
    "main": "Rain",
    "description": "light rain",
    "icon": "10d"
  }
],
"dt_txt": "2022-08-30 15:00:00"
},
{
"dt": 1661871600,
"main": {
  "temp": 296.76,
  "feels_like": 296.98,
  "temp_min": 296.76,
  "temp_max": 297.87,
  "pressure": 1015,
  "sea_level": 1015,
  "grnd_level": 933,
  "humidity": 69,
  "temp_kf": -1.11
},
"weather": [
  {
    "id": 500,
    "main": "Rain",
    "description": "light rain",
    "icon": "10d"
  }
],
"dt_txt": "2022-08-30 15:00:00"
},
{
"dt": 1661871600,
"main": {
  "temp": 296.76,
  "feels_like": 296.98,
  "temp_min": 296.76,
  "temp_max": 297.87,
  "pressure": 1015,
  "sea_level": 1015,
  "grnd_level": 933,
  "humidity": 69,
  "temp_kf": -1.11
},
"weather": [
  {
    "id": 500,
    "main": "Rain",
    "description": "light rain",
    "icon": "10d"
  }
],
"dt_txt": "2022-08-30 15:00:00"
},
{
"dt": 1661871600,
"main": {
  "temp": 296.76,
  "feels_like": 296.98,
  "temp_min": 296.76,
  "temp_max": 297.87,
  "pressure": 1015,
  "sea_level": 1015,
  "grnd_level": 933,
  "humidity": 69,
  "temp_kf": -1.11
},
"weather": [
  {
    "id": 500,
    "main": "Rain",
    "description": "light rain",
    "icon": "10d"
  }
],
"dt_txt": "2022-08-30 15:00:00"
},
{
"dt": 1661871600,
"main": {
  "temp": 296.76,
  "feels_like": 296.98,
  "temp_min": 296.76,
  "temp_max": 297.87,
  "pressure": 1015,
  "sea_level": 1015,
  "grnd_level": 933,
  "humidity": 69,
  "temp_kf": -1.11
},
"weather": [
  {
    "id": 500,
    "main": "Rain",
    "description": "light rain",
    "icon": "10d"
  }
],
"dt_txt": "2022-08-30 15:00:00"
},
{
"dt": 1661871600,
"main": {
  "temp": 296.76,
  "feels_like": 296.98,
  "temp_min": 296.76,
  "temp_max": 297.87,
  "pressure": 1015,
  "sea_level": 1015,
  "grnd_level": 933,
  "humidity": 69,
  "temp_kf": -1.11
},
"weather": [
  {
    "id": 500,
    "main": "Rain",
    "description": "light rain",
    "icon": "10d"
  }
],
"dt_txt": "2022-08-30 15:00:00"
},
{
"dt": 1661871600,
"main": {
  "temp": 296.76,
  "feels_like": 296.98,
  "temp_min": 296.76,
  "temp_max": 297.87,
  "pressure": 1015,
  "sea_level": 1015,
  "grnd_level": 933,
  "humidity": 69,
  "temp_kf": -1.11
},
"weather": [
  {
    "id": 500,
    "main": "Rain",
    "description": "light rain",
    "icon": "10d"
  }
],
"dt_txt": "2022-08-30 15:00:00"
}
]
}
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('current weather response test', () async {
    final client = http.MockClient((request) async {
      return Response(currentWeatherResponseJson, 200, request: request);
    });

    final repository =
        WeatherRepository(client: client, apiKey: Environment.apiKey);

    Weather weather = await repository
        .getCurrentWeather(GeoCoordinates(latitude: 44.34, longitude: 10.99));
    expect(weather, Weather(description: 'moderate rain', temperature: 298.48, min: 297.56, max: 300.05));
  });

  test('forecast response test', () async {
    final client = http.MockClient((request) async {
      return Response(forecastResponseJson, 200, request: request);
    });

    final repository =
        WeatherRepository(client: client, apiKey: Environment.apiKey);

    final forecast = await repository
        .getForecast(GeoCoordinates(latitude: 44.34, longitude: 10.99));
    expect(forecast.weatherForecast.length, 1);
  });
}
