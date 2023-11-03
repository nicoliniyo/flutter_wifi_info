// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:app/classes/device_utils.dart';
import 'package:app/classes/operating_system_icon.dart';
import 'package:app/classes/string_capitalize_extension.dart';

import 'package:app/models/info_item.dart';
import 'package:app/widgets/app_drawer.dart';
import 'package:app/widgets/connectivity.dart';
import 'package:app/widgets/item_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../theme/custom_theme.dart';

class WirelessPage extends StatefulWidget {
  const WirelessPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<WirelessPage> createState() => _WirelessPageState();
}

class _WirelessPageState extends State<WirelessPage> {
  final List<InfoItem> _itemsStatus = List.empty(growable: true);
  final NetworkInfo _networkInfo = NetworkInfo();
//  final ConnectivityWidget _connectivityWidget = const ConnectivityWidget();

  InternetStatus? _connectionStatus;
  late StreamSubscription<InternetStatus> _subscription;

  @override
  void initState() {
    _initNetworkInfo();
    AndroidFlutterWifi.init();
    // var isConnected = AndroidFlutterWifi.isConnected();
    getAndroidWifiDhcpInfo();
    _subscription = InternetConnection().onStatusChange.listen((status) {
      setState(() {
        _connectionStatus = status;
        developer.log('ConnectionStatus:  $_connectionStatus - $status');
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_interpolation_to_compose_strings
        title: Row(
          children: [
            Text(DeviceUtils.os.capitalize(),
                style: ThemeTextStyle.robotoWhiteText),
            const SizedBox(
              width: 10,
            ),
            OperatingSystemIcon(operatingSystem: DeviceUtils.os),
            const SizedBox(
              width: 10,
            ),
            // connectivityWidget,
            // networkStateAndType(_connectionStatus!),
          ],
        ),
        elevation: 4,
        backgroundColor: (_connectionStatus == InternetStatus.connected
            ? ThemeColors.primaryDark
            : ThemeColors.primary),
        iconTheme: const IconThemeData(color: ThemeColors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon((_connectionStatus == InternetStatus.connected
                  ? Icons.wifi
                  : Icons.wifi_off)),
              onPressed: () {
                // Add your icon's onPressed functionality here
              },
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                (_connectionStatus == InternetStatus.connected
                    ? ThemeColors.primaryDark
                    : ThemeColors.primaryDark), // Adjust colors as needed
                (_connectionStatus == InternetStatus.connected
                    ? ThemeColors.primaryLigth
                    : ThemeColors.accentColor), // Adjust colors as needed
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(
            'Wireless info',
            style: ThemeTextStyle.robotoBold16Text,
          ),
          const SizedBox(height: 16),
          //Text(_connectionStatus),
          ItemInfo(_itemsStatus)
        ],
      )),
    );
  }

  Widget _networkStateAndType(InternetStatus internetStatus) {
    Icon icon = const Icon(
      Icons.wifi,
      size: 32,
      color: ThemeColors.primaryText,
    );

    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        icon,
        Positioned(
          right: -2,
          top: 12,
          child: Icon(
            _connectionStatus == InternetStatus.connected
                ? Icons.check_circle
                : Icons.error_outlined,
            size: 18,
            color: _connectionStatus == InternetStatus.connected
                ? Colors.white
                : Colors.red,
          ),
        ),
      ],
    );
  }
  // getActiveWifiNetwork() async {
  //   ActiveWifiNetwork activeWifiNetwork =
  //       await AndroidFlutterWifi.getActiveWifiInfo();
  // }

  Future<DhcpInfo> getAndroidWifiDhcpInfo() async {
    DhcpInfo dhcpInfo = await AndroidFlutterWifi.getDhcpInfo();
    // Debug
    // String ipString = AndroidFlutterWifi.toIp(dhcpInfo.gateway!);
    // String formedIp = AndroidFlutterWifi.getFormedIp(ipString);
    // String dns1 = setIp(int.parse(dhcpInfo.dns1!));
    // String dns2 = (dhcpInfo.dns2!);

    return dhcpInfo;
  }

  Future<void> _initNetworkInfo() async {
    String? deviceInfo,
        wifiName,
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
      } else if (!kIsWeb && Platform.isAndroid) {
        var status = await Permission.location.status;
        if (status.isPermanentlyDenied ||
            status.isDenied ||
            status.isRestricted) {
          if (await Permission.location.request().isGranted) {
            // Either the permission was already granted before or the user just granted it.
          }
        }
        //wifiName = await _connectivity.getWifiName();

        // if(wifiName == null) {
        //   wifiName = Permission.location.status.toString();
        // }
      }
      wifiName = await _networkInfo.getWifiName();
      developer.log('wifiName: $wifiName');
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
      developer.log('wifiBSSID: $wifiBSSID');
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi BSSID', error: e);
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      wifiIPv4 = await _networkInfo.getWifiIP();
      developer.log('wifiIPv4: $wifiIPv4');
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv4', error: e);
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }

    try {
      if (!Platform.isWindows) {
        wifiIPv6 = await _networkInfo.getWifiIPv6();
        wifiIPv6 ??= 'Not found!';
      }
      developer.log('wifiIPv6: $wifiIPv6');
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv6', error: e);
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      if (!Platform.isWindows) {
        wifiSubmask = await _networkInfo.getWifiSubmask();
      }
      developer.log('wifiSubmask: $wifiSubmask');
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi submask address', error: e);
      wifiSubmask = 'Failed to get Wifi submask address';
    }

    try {
      if (!Platform.isWindows) {
        wifiBroadcast = await _networkInfo.getWifiBroadcast();
      }
      developer.log('wifiBroadcast: $wifiBroadcast');
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi broadcast', error: e);
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      if (!Platform.isWindows) {
        wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      }
      //wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      if (wifiGatewayIP == null) {
        final InternetAddress internetAddress = InternetAddress(wifiIPv4!);
        var host = internetAddress.host;
        if (host != null) {
          wifiGatewayIP = internetAddress.host;
        } else {
          wifiGatewayIP = "Failed to get Wifi gateway address";
        }
      }
      developer.log('wifiGatewayIP: $wifiGatewayIP');
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi gateway address', error: e);
      wifiGatewayIP = 'Failed to get Wifi gateway address';
    }

    try {
      if (!kIsWeb && Platform.isAndroid) {
        var dhcpInfo = await getAndroidWifiDhcpInfo();
        wifiDns1 = AndroidFlutterWifi.getFormedIp(
            DeviceUtils.toIp(int.parse(dhcpInfo.dns1!)));
        wifiDns2 = AndroidFlutterWifi.getFormedIp(
            DeviceUtils.toIp(int.parse(dhcpInfo.dns2!)));
      } else {
        wifiDns1 = "Not Found!";
        wifiDns2 = "Not Found!";
      }
      developer.log('wifiDns: $wifiDns1 - $wifiDns2');
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi DNS address', error: e);
      wifiDns1 = "Failed to get DNS address 1";
      wifiDns2 = "Failed to get DNS address 2";
    }

    try {
      deviceInfo = DeviceUtils.os;
      developer.log('deviceInfo: $deviceInfo');
    } on PlatformException catch (e) {
      developer.log('Failed to get Platform.operatingsystem', error: e);
    }

    setState(() {
      _itemsStatus
          .add(InfoItem("Wireless", "Device", deviceInfo!.capitalize()));
      _itemsStatus
          .add(InfoItem("Wireless", "Name", wifiName!.replaceAll('"', '')));
      _itemsStatus.add(InfoItem("Wireless", "BSSID", wifiBSSID!));
      _itemsStatus.add(InfoItem("Wireless", "IP4", wifiIPv4!));
      _itemsStatus.add(InfoItem("Wireless", "IP6", wifiIPv6!));
      _itemsStatus.add(InfoItem("Wireless", "Broadcast", wifiBroadcast!));
      _itemsStatus.add(InfoItem("Wireless", "Gateway", wifiGatewayIP!));
      _itemsStatus.add(InfoItem("Wireless", "Submask", wifiSubmask!));
      _itemsStatus.add(InfoItem("Wireless", "DNS 1", wifiDns1!));
      _itemsStatus.add(InfoItem("Wireless", "DNS 2", wifiDns2!));
    });
  }
}
