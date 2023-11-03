import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/custom_theme.dart';
import 'build_number.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AppDrawer();
  }
}

class _AppDrawer extends State<AppDrawer> {
  int _selectedIndex = 0;
  final Widget buildNumber = const BuildNumber();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.green
                      ], // Adjust colors as needed
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
                      const SizedBox(height: 10.0),
                      Text(
                        'NicApps',
                        style: ThemeTextStyle.robotoWhite16Text,
                      ),
                      Text('https://nicoliniyo.github.io/nicapps/', style: ThemeTextStyle.roboto10WhiteText),
                    ],
                  ),
                ),
                ListTile(
                  title: Row(
                    children: [
                      const Icon(
                        Icons.wifi,
                        color: ThemeColors.primaryText,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Network Info', style: ThemeTextStyle.robotoText),
                    ],
                  ),
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
    );
  }
}
