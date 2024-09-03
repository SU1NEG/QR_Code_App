import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'contact_details_page.dart';
import 'url_display_page.dart';
import 'text_display_page.dart'; // Yeni sayfa import

class QRReaderPage extends StatefulWidget {
  @override
  _QRReaderPageState createState() => _QRReaderPageState();
}

class _QRReaderPageState extends State<QRReaderPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Reader'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan a QR code'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isProcessing) {
        isProcessing = true;
        var qrText = scanData.code;

        // Check if the scanned data is a URL
        if (qrText != null &&
            (qrText.startsWith('http://') ||
                qrText.startsWith('https://') ||
                qrText.startsWith('www.'))) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UrlDisplayPage(url: qrText),
            ),
          ).then((_) {
            isProcessing = false;
          });
        } else if (qrText != null && qrText.contains('MECARD:')) {
          var vCardData = _parseVCard(qrText);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactDetailsPage(
                name: vCardData['name'] ?? 'Unknown',
                phoneNumber: vCardData['phoneNumber'] ?? 'Unknown',
                email: vCardData['email'] ?? 'Unknown',
                address: vCardData['address'] ?? 'Unknown',
              ),
            ),
          ).then((_) {
            isProcessing = false;
          });
        } else if (qrText != null) {
          // New text QR code handling
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TextDisplayPage(text: qrText),
            ),
          ).then((_) {
            isProcessing = false;
          });
        } else {
          isProcessing = false;
        }
      }
    });
  }

  Map<String, String> _parseVCard(String vCard) {
    Map<String, String> data = {};

    // vCard satırlarını ayır
    var lines = vCard.split('\n');
    for (var line in lines) {
      if (line.startsWith('FN:')) {
        data['name'] = line.substring(3).trim();
      } else if (line.startsWith('TEL:') || line.startsWith('TEL;')) {
        data['phoneNumber'] = line.substring(line.indexOf(':') + 1).trim();
      } else if (line.startsWith('EMAIL:')) {
        data['email'] = line.substring(6).trim();
      } else if (line.startsWith('ADR:')) {
        data['address'] = line.substring(4).trim();
      }
    }

    return data;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
