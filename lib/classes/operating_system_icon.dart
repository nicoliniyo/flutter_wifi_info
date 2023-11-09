import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OperatingSystemIcon extends StatelessWidget {
  final String operatingSystem;

  const OperatingSystemIcon({
    Key? key,
    required this.operatingSystem,
  }) : super(key: key);

  Icon _getOperatingSystemIcon() {
    switch (operatingSystem) {
      case 'android':
        return const Icon(Icons.android);
      case 'fuchsia':
        return const Icon(Ionicons.logo_google);
      case 'ios':
        return const Icon(Ionicons.logo_apple);
      case 'linux':
        return Icon(MdiIcons.linux);
      case 'macos':
        return const Icon(Icons.apple);
      case 'windows':
        return const Icon(Ionicons.logo_microsoft);
      default:
        return const Icon(Icons.question_mark);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getOperatingSystemIcon();
  }
}
