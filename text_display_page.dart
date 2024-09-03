import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class TextDisplayPage extends StatelessWidget {
  final String text;

  TextDisplayPage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Scanned Text:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(text, style: TextStyle(fontSize: 18, color: Colors.black)),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Text copied to clipboard')),
                );
              },
              child: Text('Kopyala'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Share.share(text);
              },
              child: Text('Paylaş'),
            ),
          ],
        ),
      ),
    );
  }
}
