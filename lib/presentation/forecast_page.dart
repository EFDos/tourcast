import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/presentation/forecast_page_controller.dart';
import 'package:tourcast/presentation/forecast_item.dart';
import 'package:tourcast/presentation/connection_notifier.dart';

class ForecastPage extends ConsumerWidget {
  static const route = '/forecast';

  const ForecastPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityName = ModalRoute.of(context)!.settings.arguments as String;
    final state = ref.watch(ForecastPageController.provider);
    return Scaffold(
      appBar: AppBar(title: Text(cityName)),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ConnectionNotifier(),
            Expanded(
              child: state.when(
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
            ),
          ],
        ),
      ),
    );
  }
}
