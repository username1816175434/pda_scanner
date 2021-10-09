import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pda_scanner/pda_listener_mixin.dart';

class PdaSource {
  static const String channelName = 'com.shinow.pda_scanner/plugin';
  static late EventChannel _scannerPlugin;
  static late StreamSubscription _subscription;

  static List<PdaListenerMixin> listeners = [];

  /// You need to initialize it as necessary, when the program starts for the first time.
  static void init() {
    // ignore: unnecessary_null_comparison
    if (_scannerPlugin == null) _scannerPlugin = const EventChannel(channelName);
    _subscription = _scannerPlugin.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    // .listen(_onEvent, onError: _onError);
  }

  static void registerListener(PdaListenerMixin listener) {
    if (!listeners.contains(listener)) listeners.add(listener);
  }

  static void unRegisterListener(PdaListenerMixin listener) {
    if (listeners.contains(listener)) listeners.remove(listener);
  }

  /// You need to call this method to release resources when you exit the entire application.
  static void dispose() {
    listeners.clear();
    assert(_subscription != null);
    _subscription.cancel();
  }

  static void _onEvent(Object? code) {
    listeners.forEach((listener) => listener.checkRouteAndFireEvent(code));
  }

  static void _onError(Object error) {
    listeners.forEach((listener) => listener.onError(error));
  }
}
