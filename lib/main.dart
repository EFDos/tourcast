import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/presentation/concerts_page.dart';
import 'package:tourcast/presentation/forecast_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
      routes: {
        ConcertsPage.route: (context) => const ConcertsPage(),
        ForecastPage.route: (context) => const ForecastPage(),
      }
    );
  }
}
