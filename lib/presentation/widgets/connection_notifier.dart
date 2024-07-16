import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/application/connection_checker.dart';

/// Widget used to notify the user when internet
/// is not reachable
class ConnectionNotifier extends ConsumerWidget {
  const ConnectionNotifier({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionCheckResult = ref.watch(ConnectionCheckerNotifier.provider);
    return connectionCheckResult.state == ConnectionCheckState.connected
        ? const Center()
        : Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: Column(
              children: [
                const Text(
                    'No internet connection\nCheck if your Wi-Fi or Mobile Data is enabled',
                    textAlign: TextAlign.center),
                connectionCheckResult.lastUpdate != null
                    ? Text('Last updated: ${connectionCheckResult.lastUpdate}',
                        textAlign: TextAlign.center)
                    : const Center()
              ],
            ),
          );
  }
}
