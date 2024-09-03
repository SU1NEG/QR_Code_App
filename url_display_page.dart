import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlDisplayPage extends StatelessWidget {
  final String url;

  UrlDisplayPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('URL Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Scanned URL:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(url, style: TextStyle(fontSize: 18, color: Colors.blue)),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _launchURL(url);
              },
              child: Text('Open URL'),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
