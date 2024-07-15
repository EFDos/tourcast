import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/presentation/concerts_page_controller.dart';
import 'package:tourcast/presentation/city_weather_item.dart';

class ConcertsPage extends ConsumerWidget {
  const ConcertsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ConcertsPageController.provider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concerts List'),
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
                return val == null ? const CircularProgressIndicator.adaptive() :
                    CityWeatherItem(
                        cityName: ConcertsPageController.cities[index],
                        country: ConcertsPageController.countries[index],
                        temperature: val.temperature,
                        description: val.description,
                    );
              },
              error: (e, __) => Text(e.toString()),
              loading: () =>
                  const CircularProgressIndicator(color: Colors.pink),
            );
          },
        ),
      ),
    );
  }
}
