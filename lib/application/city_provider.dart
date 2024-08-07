import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/domain/city.dart';
import 'package:tourcast/constants.dart';

/// [CityProvider]
/// Provide the list of cities used by ConcertsListPage,
/// filtered by the search bar
class CityProvider extends Notifier<List<City>> {
  @override
  List<City> build() {
    return Constants.cities;
  }

  /// Linear search of cities containing [predicate]
  void searchCity(String predicate) {
    state = Constants.cities
        .where((c) => c.name.toLowerCase().contains(predicate.toLowerCase()))
        .toList();
  }

  static final provider =
      NotifierProvider<CityProvider, List<City>>(() => CityProvider());
}
