import 'dart:io';

class DeviceUtils {
  static String get os {
    return Platform.operatingSystem;
  }

  static toIp(int ip) {
    var strData = StringBuffer();
    for (int i = 0; i < 4; i++) {
      strData.write(ip >> 24 & 0xff);
      if (i < 3) {
        strData.write(".");
      }
      ip = ip << 8;
    }
    return strData.toString();
  }
}
