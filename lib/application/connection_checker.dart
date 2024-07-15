import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionChecker {
  static Future<void> checkConnection(Function(bool state) listener) async {
    Socket? socket;
    try {
      socket = await Socket.connect('1.1.1.1', 53,
          timeout: const Duration(seconds: 5))
        ..destroy();
      listener(true);
    } catch (e) {
      socket?.destroy();
      listener(false);
    }
  }

  //static final provider = FutureProvider<bool>((ref) {
  //return ConnectionChecker.checkConnection();
  //});
}

class ConnectionCheckerNotifier extends Notifier<bool> {
  /*@override
  FutureOr<bool> build() {
    check();
    return true;
  }*/

  @override
  bool build() {
    check();
    return true;
  }

  void check() {
    ConnectionChecker.checkConnection((newState) {
      state = newState;
      Future.delayed(const Duration(seconds: 5), () => check());
    });
  }

  static final provider = NotifierProvider<ConnectionCheckerNotifier, bool>(
      () => ConnectionCheckerNotifier());
}
