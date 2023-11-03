import 'dart:io';

class DeviceUtils {
  static String get os {
    return Platform.operatingSystem;
  }

  static toIp(int _ip) {
    var _strData = StringBuffer();
    for (int i = 0; i < 4; i++) {
      _strData.write(_ip >> 24 & 0xff);
      if (i < 3) {
        _strData.write(".");
      }
      _ip = _ip << 8;
    }
    return _strData.toString();
  }
}
