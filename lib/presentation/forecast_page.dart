import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/constants.dart';
import 'package:tourcast/domain/city.dart';
import 'package:tourcast/presentation/forecast_page_controller.dart';
import 'package:tourcast/presentation/forecast_item.dart';
import 'package:tourcast/presentation/widgets/connection_notifier.dart';

/// Forecast details page
/// Used with [ForecastPageController]
class ForecastPage extends ConsumerWidget {
  static const route = '/forecast';

  const ForecastPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = ModalRoute.of(context)!.settings.arguments as City;
    final state = ref.watch(ForecastPageController.provider);
    return Scaffold(
      appBar: AppBar(
        title: Text(city.name),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Constants.nightColorDark,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Constants.backgroundGradient,
          ),
        ),
        child: SafeArea(
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
      ),
    );
  }
}
