import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectionCheckState {
  connected,
  disconnected,
}

/// Informs current connection [state] and [lastUpdate] as
/// the last successfull remote data acquisition
class ConnectionCheckResult {
  final ConnectionCheckState state;
  final DateTime? lastUpdate;
  const ConnectionCheckResult({required this.state, this.lastUpdate});
}

/// Utility to check is internect is reachable
/// (Uses cloudflare DNS address to check for availability)
class ConnectionChecker {
  static const _cloudFlareAddress = '1.1.1.1';
  static const _defaultPort = 53;
  static const _defaultTimeout = Duration(seconds: 5);

  /// Perform a connection check and respond current [ConnectionCheckState] to [listener]
  static Future<void> checkConnection(
      Function(ConnectionCheckState state) listener) async {
    Socket? socket;
    try {
      socket = await Socket.connect(_cloudFlareAddress, _defaultPort,
          timeout: _defaultTimeout)
        ..destroy();
      listener(ConnectionCheckState.connected);
    } catch (e) {
      socket?.destroy();
      listener(ConnectionCheckState.disconnected);
    }
  }
}

/// Stores [lastUpdate] periodically check for internet availability
/// TODO: Ideally should be trigger the check-loop only while
/// disconnected
class ConnectionCheckerNotifier extends Notifier<ConnectionCheckResult> {
  DateTime? lastUpdate;

  @override
  ConnectionCheckResult build() {
    check();
    return const ConnectionCheckResult(state: ConnectionCheckState.connected);
  }

  /// Triggers and schedule a new check
  void check() {
    ConnectionChecker.checkConnection((newState) {
      state = ConnectionCheckResult(state: newState, lastUpdate: lastUpdate);
      Future.delayed(const Duration(seconds: 5), () => check());
    });
  }

  /// Used to update last time remote data was acquired
  void seedLastUpdate() {
    lastUpdate = DateTime.now();
  }

  static final provider =
      NotifierProvider<ConnectionCheckerNotifier, ConnectionCheckResult>(
          () => ConnectionCheckerNotifier());
}
