import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ConnectivityWidget extends StatefulWidget {
  const ConnectivityWidget({Key? key}) : super(key: key);

  @override
  State<ConnectivityWidget> createState() => _ConnectivityWidget();
}

class _ConnectivityWidget extends State<ConnectivityWidget> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return getConnectivityType(_connectionStatus);
  }

  Icon getConnectivityType(ConnectivityResult connectivityResult) {
    Icon type = const Icon(Icons.device_unknown);
    developer.log('Connectivity Type $connectivityResult');
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      type = const Icon(Icons.phone_android);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      type = const Icon(Icons.wifi);
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      // I am connected to a ethernet network.
      type = const Icon(Ionicons.unlink);
    } else if (connectivityResult == ConnectivityResult.vpn) {
      // I am connected to a vpn network.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
      type = const Icon(Icons.vpn_lock);
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      // I am connected to a bluetooth.
      type = const Icon(Icons.bluetooth);
    } else if (connectivityResult == ConnectivityResult.other) {
      // I am connected to a network which is not in the above mentioned networks.
    } //else if (connectivityResult == ConnectivityResult.none) {

    return type;
    //}
  }
}
