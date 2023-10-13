import 'package:app/models/info_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';


class StringSplitterWidget extends StatefulWidget {
  const StringSplitterWidget(this.splitStrings, {super.key});
  final List<InfoItem> splitStrings ;

  @override
  State<StatefulWidget> createState() {
    return _StringSplitterWidget(splitStrings);
  }
}

class _StringSplitterWidget extends State<StringSplitterWidget> {
  _StringSplitterWidget(this.splitStrings);
  final List<InfoItem> splitStrings ;

  @override
  Widget build(BuildContext context) {
    print("SPW 2: $splitStrings");

    if(splitStrings.isNotEmpty) {

      //print("Not empty! $splitStrings" + splitStrings.first);

      return Column( children: [
        ...splitStrings.map((element) {
          print(element);
          return _createText(element, context);
        })
      ],);
    }else {
      return const Text("Wireless Information Not found!");
    }
  }

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
      ),
    );
  }

  Widget _createText(InfoItem item, BuildContext context) {
    print("Creando Widgets $item");
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
