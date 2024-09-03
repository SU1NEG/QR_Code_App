import 'package:flutter/material.dart';
import 'package:qr_generator/contact_page.dart';
import 'package:qr_generator/qr_reader_page.dart';
import 'package:qr_generator/web_page.dart';
import 'package:qr_generator/free_page.dart';
import 'package:qr_generator/qr_generator_home_page.dart';
import 'package:qr_generator/address_reader_page.dart';
import 'package:qr_generator/license_plate_reading_page.dart'; // Yeni sayfayı dahil ettik

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(context, 'QR Code Generator', QrGeneratorHomePage()),
            _buildButton(context, 'QR Reader', QRReaderPage()),
            _buildButton(context, 'Address Reader', AddressReaderPage()),
            _buildButton(context, 'License Plate Reading',
                LicensePlateReadingPage()), // Burada sayfayı dahil ettik
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, Widget? page) {
    return ElevatedButton(
      onPressed: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      child: Text(title),
    );
  }
}
