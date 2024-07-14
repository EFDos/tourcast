import 'package:flutter/material.dart';
import 'package:tourcast/presentation/concerts_page.dart';

import 'package:http/http.dart' as http;
import 'package:tourcast/data/geocoding_repository.dart';
import 'package:tourcast/data/weather_repository.dart';
import 'package:tourcast/domain/geocoordinates.dart';
import 'package:tourcast/domain/weather.dart';
import 'package:tourcast/environment/environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final key = await Environment.getApiKey();
  final client = http.Client();

  final loc = await GeocodingRepository(client: client, apiKey: key)
      .getCityLocation(cityName: 'Buenos Aires', countryCode: 55);
  print('BA coordinates: ${loc.latitude}, ${loc.longitude}');
  final weather = await WeatherRepository(client: client, apiKey: key)
      .getCurrentWeather(loc);
  print('BA temperature: ${weather.temperature}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourcast',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ConcertsPage(),
    );
  }
}
