import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/constants.dart';
import 'package:tourcast/application/city_provider.dart';
import 'package:tourcast/presentation/city_weather_item.dart';
import 'package:tourcast/presentation/city_search_field.dart';
import 'package:tourcast/presentation/connection_notifier.dart';
import 'package:tourcast/presentation/forecast_page.dart';
import 'package:tourcast/presentation/concerts_page_controller.dart';
import 'package:tourcast/presentation/forecast_page_controller.dart';

class ConcertsPage extends ConsumerWidget {
  static const route = '/concerts';
  const ConcertsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = ref.watch(CityProvider.provider);
    final state = ref.watch(ConcertsPageController.provider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Concerts List'),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [const Shadow(blurRadius: 2)]),
        centerTitle: false,
        backgroundColor: Constants.nightColorLight,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: Constants.backgroundGradient),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const ConnectionNotifier(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CitySearchField(),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    return state.when(
                      data: (data) {
                        final val = data[cities[index].name];
                        return GestureDetector(
                          child: CityWeatherItem(
                            cityName: cities[index].name,
                            country: cities[index].countryName,
                            temperature: val == null ? 0.0 : val.temperature,
                            description: val == null ? '' : val.description,
                            conditionId: val == null ? 0 : val.conditionId,
                          ),
                          onTap: () {
                            ref
                                .read(ForecastPageController.provider.notifier)
                                .getWeather(cities[index].name,
                                    cities[index].countryCode);
                            Navigator.of(context).pushNamed(ForecastPage.route,
                                arguments: cities[index]);
                          },
                        );
                      },
                      error: (e, __) => Text(e.toString()),
                      loading: () => const CircularProgressIndicator.adaptive(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
