import 'package:app/models/info_item.dart';
import 'package:app/theme/custom_theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';


class ItemInfo extends StatefulWidget {
  const ItemInfo(this.splitStrings, {super.key});
  final List<InfoItem> splitStrings ;

  @override
  State<StatefulWidget> createState() {
    return _ItemInfo(splitStrings);
  }
}

class _ItemInfo extends State<ItemInfo> {
  _ItemInfo(this.splitStrings);
  final List<InfoItem> splitStrings ;

  @override
  Widget build(BuildContext context) {
    if(splitStrings.isNotEmpty) {
      return Column( children: [
        ...splitStrings.map((element) {
          print(element);
          return _createText(element, context);
        })
      ],);
    }else {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Oh ... no se pudo obtener la información!',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Pruebe conectando su dispositivo a otra red!',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      );
    }
  }

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ThemeColors.accentColor,
        content: Text('Copied to clipboard: $text'),
      ),
    );
  }

  Widget _createText(InfoItem item, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label),
                  Text(item.data),
                ],
              ),
              IconButton(
                icon: Icon(Icons.copy),
                color: ThemeColors.primaryDark,
                onPressed: () {
                  _copyToClipboard(item.data, context);
                },
              ),
            ],
          ),
        ),
        Divider(), // Optional: Divider between items
      ],
    );
  }
}
