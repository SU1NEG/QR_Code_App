import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class LicensePlateReadingPage extends StatefulWidget {
  @override
  _LicensePlateReadingPageState createState() =>
      _LicensePlateReadingPageState();
}

class _LicensePlateReadingPageState extends State<LicensePlateReadingPage> {
  String? _licensePlate;

  Future<void> _getImageAndDetectPlate() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      String? detectedPlate;
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          if (_isTurkishLicensePlate(line.text)) {
            detectedPlate = line.text;
            break;
          }
        }
      }

      await textRecognizer.close();

      setState(() {
        _licensePlate = detectedPlate ?? 'Plaka bulunamadı';
      });
    }
  }

  bool _isTurkishLicensePlate(String text) {
    final plateRegex = RegExp(r'^[0-9]{2} [A-Z]{1,3} [0-9]{1,4}$');
    return plateRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('License Plate Reading'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _getImageAndDetectPlate,
              child: Text('Fotoğraf Çek ve Plakayı Oku'),
            ),
            SizedBox(height: 20),
            Text(
              _licensePlate ?? 'Henüz plaka taranmadı.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
