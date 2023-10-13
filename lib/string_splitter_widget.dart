import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class StringSplitterWidget extends StatelessWidget {
  //final String inputString = 'Split this string by spaces';

  const StringSplitterWidget(this.splitStrings, {super.key});
  final List<String> splitStrings;



  @override
  Widget build(BuildContext context) {
    //List<String> splitStrings = inputString.split(' ');

    return ListView.builder(
      itemCount: 8,//splitStrings.length,
      itemBuilder: (context, index) {
        String text = splitStrings[index];
      print("SPW: " + text);
        return Column(
          children: [
            ListTile(
              title: Text(text),
            ),
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                _copyToClipboard(text, context);
              },
            ),
            Divider(), // Optional: Divider between items
          ],
        );
      },
    );
  }

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
      ),
    );
  }
}
