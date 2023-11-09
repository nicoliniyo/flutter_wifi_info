

import 'package:app/theme/custom_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BuildNumber extends StatefulWidget {
  const BuildNumber({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BuildNumber();
  }
}
class _BuildNumber extends State<BuildNumber> {

  String bn = "Version: Not Available";

  @override
  Widget build(BuildContext context) {
    return Text(bn, style: ThemeTextStyle.roboto10Text,);
  }

  @override
  void initState() {

    getBuildNumber();
    super.initState();
  }


  Future<void> getBuildNumber()  async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //PackageInfo.fromPlatform().then((PackageInfo packageInfo) ;
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    setState(() {
      bn = "$appName v$version Build: $buildNumber";
    });

  }

}