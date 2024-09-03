import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_generator/qr_display_page.dart'; // Kendi proje adını kullan
import 'package:share_plus/share_plus.dart'; // Share Plus paketini ekleyin
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FreePage extends StatefulWidget {
  @override
  _FreePageState createState() => _FreePageState();
}

class _FreePageState extends State<FreePage> {
  TextEditingController textController = TextEditingController();
  String? qrData;

  _generateQRCode(String text) {
    setState(() {
      qrData = text;
    });
  }

  Future<void> _shareQRCode(String data) async {
    final tempDir = await getTemporaryDirectory();
    final file = await _generateQrImageFile(data, tempDir.path);
    Share.shareFiles([file.path], text: 'Here is the QR code for $data');
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
        title: Text('Enter Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Text',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _generateQRCode(textController.text);
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
