import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/application/connection_checker.dart';

class ConnectionNotifier extends ConsumerWidget {
  const ConnectionNotifier({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(ConnectionCheckerNotifier.provider);
    return connectionState
        ? const Center()
        : Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: Column(
              children: [
                const Text('No internet connection',
                    textAlign: TextAlign.center),
                Text('Last updated: ${DateTime.now()}',
                    textAlign: TextAlign.center),
              ],
            ),
          );
  }
}
