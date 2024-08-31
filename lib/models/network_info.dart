import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

enum OperatingSystem { android, fuchsia, ios, linux, macos, windows }

/*
ConnectivityResult
  bluetooth,
  wifi,
  ethernet,
  mobile,
  none,
  /// VPN: Device connected to a VPN
  /// Note for iOS and macOS:
  /// There is no separate network interface type for [vpn].
  /// It returns [other] on any device (also simulator).
  vpn,
  other
*/

enum Detail {
  device,
  name,
  bssid,
  ip4,
  ip6,
  broadcast,
  gateway,
  submask,
  dns1,
  dns2
}

class NetworkInfo {
  const NetworkInfo(
      this.isConnected, this.os, this.type, this.label, this.data);

  final InternetConnection isConnected;
  final OperatingSystem os;
  final ConnectivityResult type;
  final Detail label;
  final String data;
}
