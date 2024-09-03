import 'package:flutter/material.dart';
import 'package:qr_generator/address_reader_page.dart';
import 'package:qr_generator/contact_page.dart';
import 'package:qr_generator/web_page.dart';
import 'package:qr_generator/free_page.dart';
import 'package:qr_generator/qr_reader_page.dart';
import 'package:qr_generator/license_plate_reading_page.dart'; // Yeni sayfayı dahil ettik

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR APP'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactPage()),
                );
              },
              child: Text('QR Code Generator'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRReaderPage()),
                );
              },
              child: Text('QR Reader'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddressReaderPage()),
                );
              },
              child: Text('Address Reader'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LicensePlateReadingPage()), // Burada sayfayı dahil ettik
                );
              },
              child: Text('License Plate Reading'),
            ),
          ],
        ),
      ),
    );
  }
}
