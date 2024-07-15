import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionChecker {
  static Future<bool> checkConnection() async {
    Socket? socket;
    try {
      socket = await Socket.connect('1.1.1.1', 53,
          timeout: const Duration(seconds: 5))
        ..destroy();
      return true;
    } catch (e) {
      socket?.destroy();
      return false;
    }
  }

  //static final provider = FutureProvider<bool>((ref) {
  //return ConnectionChecker.checkConnection();
  //});
}

class ConnectionCheckerNotifier extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() {
    check();
    return true;
  }

  Future<void> check() async {
    state = await AsyncValue.guard(() {
      return ConnectionChecker.checkConnection();
    });
  }

  static final provider =
      AsyncNotifierProvider<ConnectionCheckerNotifier, bool>(() => ConnectionCheckerNotifier());
}
