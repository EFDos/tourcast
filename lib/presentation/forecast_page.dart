import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/presentation/forecast_page_controller.dart';
import 'package:tourcast/presentation/forecast_item.dart';
import 'package:tourcast/application/connection_checker.dart';

class ForecastPage extends ConsumerWidget {
  static const route = '/forecast';

  const ForecastPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityName = ModalRoute.of(context)!.settings.arguments as String;
    final connectionState = ref.watch(ConnectionCheckerNotifier.provider);
    final state = ref.watch(ForecastPageController.provider);
    return Scaffold(
      appBar: AppBar(title: Text(cityName)),
      body: Expanded(
        child: Column(
          children: [
            connectionState.when(
              data: (connected) {
                if (!connected) {
                  return const Text('No internet connection');
                } else {
                  return const Center();
                }
              },
              loading: () => const Center(),
              error: (e, __) => Text(e.toString()),
            ),
            state.when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final weather = data[index];
                    return ForecastItem(
                      temperature: weather.temperature,
                      min: weather.min,
                      max: weather.max,
                      conditionId: weather.conditionId,
                    );
                  },
                );
              },
              loading: () => const CircularProgressIndicator.adaptive(),
              error: (e, __) => Text(e.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
