import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class AddressReaderPage extends StatefulWidget {
  @override
  _AddressReaderPageState createState() => _AddressReaderPageState();
}

class _AddressReaderPageState extends State<AddressReaderPage> {
  final ImagePicker _picker = ImagePicker();
  String _address = '';
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _isLoading = true;
      });
      await _extractTextFromImage(File(image.path));
    }
  }

  Future<void> _extractTextFromImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String address = '';
    final addressRegex = RegExp(
        r'(\bmah\b|\bsokak\b|\bsk\b|\bno\b|\bil\b|\bilçe\b|\bşehir\b|\bulke\b|\bmahallesi\b)',
        caseSensitive: false);
    final phoneRegex = RegExp(
        r'(\+?\d{1,4}?[-.\s]?(\(?\d{1,3}?\)?[-.\s]?|\d{1,4})\d{1,4}[-.\s]?\d{1,9})');
    final emailRegex = RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b');
    final urlRegex =
        RegExp(r'\b((http|https)://)?([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?\b');

    bool foundAddressStart = false;

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (addressRegex.hasMatch(line.text)) {
          address += line.text + '\n';
          foundAddressStart = true;
        } else if (foundAddressStart && line.text.trim().isNotEmpty) {
          if (!phoneRegex.hasMatch(line.text) &&
              !emailRegex.hasMatch(line.text) &&
              !urlRegex.hasMatch(line.text)) {
            address += line.text + '\n';
          } else {
            foundAddressStart = false;
          }
        }
      }
    }

    setState(() {
      _address = address.trim();
      _isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressDisplayPage(address: _address),
      ),
    );

    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Reader'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Capture Image'),
                  ),
                ],
              ),
      ),
    );
  }
}

class AddressDisplayPage extends StatelessWidget {
  final String address;

  AddressDisplayPage({required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Extracted Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          address,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
