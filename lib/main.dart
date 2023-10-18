// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:collection';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:ui';

import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:app/models/info_item.dart';
import 'package:app/widgets/build_number.dart';
import 'package:app/widgets/item_info.dart';
import 'package:app/theme/custom-theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

// Sets a platform override for desktop to avoid exceptions. See
// https://flutter.dev/desktop#target-platform-override for more info.
void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _enablePlatformOverrideForDesktop();
  runApp(const NetworkinfoApp());
}

class NetworkinfoApp extends StatelessWidget {
  const NetworkinfoApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Info',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: ThemeColors.white,
      ),
      home: const WirelessPage(title: 'Network Info'),
    );
  }
}

class WirelessPage extends StatefulWidget {
  const WirelessPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<WirelessPage> createState() => _WirelessPageState();
}

class _WirelessPageState extends State<WirelessPage> {
  List<InfoItem> _connectionStatus = List.empty(growable: true);
  final NetworkInfo _networkInfo = NetworkInfo();
  final Widget buildNumber = const BuildNumber();
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Wireless',
      style: optionStyle,
    ),
    Text(
      'Index 1: Mobile',
      style: optionStyle,
    ),
    Text(
      'Index 2: Utils',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {

    _initNetworkInfo();
    AndroidFlutterWifi.init();
    var isConnected = AndroidFlutterWifi.isConnected();
    getDhcpInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Info App',
          style: ThemeTextStyle.robotoWhiteText),
        elevation: 4,
        backgroundColor: ThemeColors.primary,
        iconTheme: const IconThemeData(color: ThemeColors.white),

      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.green], // Adjust colors as needed
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/nicapps-logo.png', // Replace with the actual asset path
                          width: 80.0, // Adjust width as needed
                          height: 80.0, // Adjust height as needed
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Network Info App',
                          style: ThemeTextStyle.robotoWhite16Text,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Wireless', style: ThemeTextStyle.robotoText),
                    selected: _selectedIndex == 0,
                    onTap: () {
                      _onItemTapped(0);
                      Navigator.pop(context);
                    },
                  ),
                  // Add other list items here
                ],
              ),
            ),
            ListTile(
              title: buildNumber,
            ),
          ],
        ),
      ),

    body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Wireless info',
                style: ThemeTextStyle.robotoBold16Text,
              ),
              const SizedBox(height: 16),
              //Text(_connectionStatus),
              ItemInfo(_connectionStatus)
            ],
          )),
    );
  }

  getActiveWifiNetwork() async {
    ActiveWifiNetwork activeWifiNetwork =
    await AndroidFlutterWifi.getActiveWifiInfo();
  }

  Future<DhcpInfo> getDhcpInfo() async {
    DhcpInfo dhcpInfo = await AndroidFlutterWifi.getDhcpInfo();
    // Debug
    // String ipString = AndroidFlutterWifi.toIp(dhcpInfo.gateway!);
    // String formedIp = AndroidFlutterWifi.getFormedIp(ipString);
    // String dns1 = setIp(int.parse(dhcpInfo.dns1!));
    // String dns2 = (dhcpInfo.dns2!);

    return dhcpInfo;
  }

  static setIp(int _ip){
    var _strData = StringBuffer();
    for (int i = 0; i<4; i++){
      _strData.write(_ip >> 24 &0xff );
      if (i < 3) {
        _strData.write(".");
      }
      _ip = _ip << 8;
    }
    return _strData.toString();
  }

  Future<void> _initNetworkInfo() async {
    String? wifiName,
        wifiBSSID,
        wifiIPv4,
        wifiIPv6,
        wifiGatewayIP,
        wifiBroadcast,
        wifiSubmask,
        wifiDns1,
        wifiDns2;

    try {
      if (!kIsWeb && Platform.isIOS) {
        // ignore: deprecated_member_use
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          // ignore: deprecated_member_use
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiName = await _networkInfo.getWifiName();
        } else {
          wifiName = await _networkInfo.getWifiName();
        }
      } else {
        var status = await Permission.location.status;
        if(status.isPermanentlyDenied || status.isDenied || status.isRestricted)
        {
          if (await Permission.location.request().isGranted)
          {
            // Either the permission was already granted before or the user just granted it.
          }
        }
        //wifiName = await _connectivity.getWifiName();
        wifiName = await _networkInfo.getWifiName();
        // if(wifiName == null) {
        //   wifiName = Permission.location.status.toString();
        // }
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi Name', error: e);
      wifiName = 'Failed to get Wifi Name';
    }

    try {
      if (!kIsWeb && Platform.isIOS) {
        // ignore: deprecated_member_use
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          // ignore: deprecated_member_use
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        } else {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        }
      } else {
        wifiBSSID = await _networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi BSSID', error: e);
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      wifiIPv4 = await _networkInfo.getWifiIP();
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv4', error: e);
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }

    try {
      if (!Platform.isWindows) {
        wifiIPv6 = await _networkInfo.getWifiIPv6();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv6', error: e);
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      if (!Platform.isWindows) {
        wifiSubmask = await _networkInfo.getWifiSubmask();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi submask address', error: e);
      wifiSubmask = 'Failed to get Wifi submask address';
    }

    try {
      if (!Platform.isWindows) {
        wifiBroadcast = await _networkInfo.getWifiBroadcast();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi broadcast', error: e);
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      if (!Platform.isWindows) {
        wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      }
      wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      if(wifiGatewayIP == null) {
        final InternetAddress internetAddress = InternetAddress(wifiIPv4!);
        var host = internetAddress.host;
        if(host != null) {
          wifiGatewayIP = internetAddress.host;
        } else {
          wifiGatewayIP = "No se obtuvo valor";
        }
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi gateway address', error: e);
      wifiGatewayIP = 'Failed to get Wifi gateway address';
    }

    try {
      var dhcpInfo = await getDhcpInfo();
      if(dhcpInfo != null) {
        wifiDns1 = AndroidFlutterWifi.getFormedIp(setIp(int.parse(dhcpInfo.dns1!)));
        wifiDns2 = AndroidFlutterWifi.getFormedIp(setIp(int.parse(dhcpInfo.dns2!)));
      } else {
        wifiDns1 = "Not Found!";
        wifiDns2 = "Not Found!";
      }
    } on PlatformException catch(e) {
      developer.log('Failed to get Wifi DNS address', error: e);
    }

    setState(() {
      _connectionStatus.add(InfoItem("Wireless", "Name", wifiName!));
      _connectionStatus.add(InfoItem("Wireless", "BSSID", wifiBSSID! ));
      _connectionStatus.add(InfoItem("Wireless", "IP4", wifiIPv4!));
      _connectionStatus.add(InfoItem("Wireless", "IP6", wifiIPv6!));
      _connectionStatus.add(InfoItem("Wireless", "Broadcast", wifiBroadcast!));
      _connectionStatus.add(InfoItem("Wireless", "Gateway", wifiGatewayIP!));
      _connectionStatus.add(InfoItem("Wireless", "Submask", wifiSubmask!));
      _connectionStatus.add(InfoItem("Wireless", "DNS 1", wifiDns1!));
      _connectionStatus.add(InfoItem("Wireless", "DNS 2", wifiDns2!));

    });
  }
}