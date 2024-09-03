import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_generator/qr_display_page.dart'; // Kendi proje adını kullan
import 'package:share_plus/share_plus.dart'; // Share Plus paketini ekleyin
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WebPage extends StatefulWidget {
  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  TextEditingController urlController = TextEditingController();
  String? qrData;

  _generateQRCode(String url) {
    setState(() {
      qrData = url;
    });
  }

  Future<void> _shareQRCode(String data) async {
    final tempDir = await getTemporaryDirectory();
    final file = await _generateQrImageFile(data, tempDir.path);
    Share.shareXFiles([XFile(file.path)],
        text: 'Here is the QR code for $data');
  }

  Future<File> _generateQrImageFile(String data, String path) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode!;
      final painter = QrPainter.withQr(
        qr: qrCode,
        color: const Color(0xFF000000),
        emptyColor: const Color(0xFFFFFFFF),
        gapless: true,
      );
      final picData =
          await painter.toImageData(2048, format: ImageByteFormat.png);
      final file = File('$path/qr_code.png');
      await file.writeAsBytes(picData!.buffer.asUint8List());
      return file;
    } else {
      throw Exception('Could not generate QR code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter URL'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'URL',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _generateQRCode(urlController.text);
              },
              child: Text('Generate QR Code'),
            ),
            SizedBox(height: 20),
            qrData != null
                ? Column(
                    children: [
                      QrImageView(
                        data: qrData!,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _shareQRCode(qrData!);
                        },
                        child: Text('Share'),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
