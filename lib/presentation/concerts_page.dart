import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/presentation/concerts_page_controller.dart';
import 'package:tourcast/presentation/city_weather_item.dart';
import 'package:tourcast/presentation/forecast_page.dart';
import 'package:tourcast/presentation/forecast_page_controller.dart';

class ConcertsPage extends ConsumerWidget {
  static const route = '/concerts';
  const ConcertsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ConcertsPageController.provider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concerts List'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        centerTitle: false,
        backgroundColor: Colors.lightBlue.shade200,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue.shade200, Colors.blue.shade800]),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: ConcertsPageController.cities.length,
          itemBuilder: (context, index) {
            return state.when(
              data: (data) {
                final val = data[ConcertsPageController.cities[index]];
                return GestureDetector(
                  child: CityWeatherItem(
                    cityName: ConcertsPageController.cities[index],
                    country: ConcertsPageController.countries[index],
                    temperature: val == null ? 0.0 : val.temperature,
                    description: val == null ? '' : val.description,
                  ),
                  onTap: () {
                    final cityName = ConcertsPageController.cities[index];
                    final countryCode = ConcertsPageController.countryCode[
                        ConcertsPageController.cities
                            .where((e) => e == cityName)
                            .indexed
                            .first
                            .$1];
                    ref
                        .read(ForecastPageController.provider.notifier)
                        .getWeather(cityName, countryCode);
                    Navigator.of(context).pushNamed(ForecastPage.route,
                        arguments: ConcertsPageController.cities[index]);
                  },
                );
              },
              error: (e, __) => Text(e.toString()),
              loading: () => const CircularProgressIndicator.adaptive(),
            );
          },
        ),
      ),
    );
  }
}
