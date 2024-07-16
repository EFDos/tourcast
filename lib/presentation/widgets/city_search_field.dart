import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/application/city_provider.dart';

/// Widget utilized in [ConcertsPage] to filter the
/// concerts list
class CitySearchField extends ConsumerStatefulWidget {
  const CitySearchField({super.key});

  @override
  ConsumerState createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends ConsumerState<CitySearchField> {
  final _textController = TextEditingController();

  @override
  initState() {
    super.initState();
    //_textController.text = ref.read()
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: const InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(10), right: Radius.circular(10)),
        ),
        hintText: 'Search City',
      ),
      onChanged: (text) =>
          ref.read(CityProvider.provider.notifier).searchCity(text),
    );
  }
}
