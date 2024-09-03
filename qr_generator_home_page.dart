import 'package:flutter/material.dart';
import 'package:qr_generator/contact_page.dart';
import 'package:qr_generator/web_page.dart';
import 'package:qr_generator/free_page.dart';

class QrGeneratorHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(context, 'Contact', ContactPage()),
            _buildButton(context, 'Web', WebPage()),
            _buildButton(context, 'Free', FreePage()),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(title),
    );
  }
}
