import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/presentation/forecast_page_controller.dart';

class ForecastPage extends ConsumerWidget {
  static const route = '/forecast';

  const ForecastPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityName = ModalRoute.of(context)!.settings.arguments as String;
    final state = ref.watch(ForecastPageController.provider);
    return Scaffold(
      appBar: AppBar(title: Text(cityName)),
      body: state.when(
        data: (data) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Card(
                child: Row(
                  children: [
                    const Icon(Icons.sunny),
                    Text(data[index].temperature.toString()),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const CircularProgressIndicator.adaptive(),
        error: (e, __) => Text(e.toString()),
      ),
    );
  }
}
