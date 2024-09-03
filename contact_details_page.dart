import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:contacts_service/contacts_service.dart'; // Eklenen paket

class ContactDetailsPage extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String email;
  final String address;

  ContactDetailsPage({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: $name', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Phone: $phoneNumber', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: $email', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Address: $address', style: TextStyle(fontSize: 18)),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _saveContact(context, name, phoneNumber, email, address);
              },
              child: Text('Rehbere Kaydet'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _makePhoneCall(phoneNumber);
              },
              child: Text('Ara'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _sendEmail(email);
              },
              child: Text('E-posta Gönder'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _copyToClipboard(name, phoneNumber, email, address);
              },
              child: Text('Kopyala'),
            ),
          ],
        ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  void _sendEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launch(emailLaunchUri.toString());
  }

  void _copyToClipboard(
      String name, String phoneNumber, String email, String address) {
    final String userDetails =
        'Name: $name\nPhone: $phoneNumber\nEmail: $email\nAddress: $address';
    Clipboard.setData(ClipboardData(text: userDetails));
  }

  void _saveContact(BuildContext context, String name, String phoneNumber,
      String email, String address) async {
    final newContact = Contact(
      givenName: name,
      phones: [Item(label: 'mobile', value: phoneNumber)],
      emails: [Item(label: 'work', value: email)],
      postalAddresses: [PostalAddress(label: 'home', street: address)],
    );

    try {
      await ContactsService.addContact(newContact);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Rehbere kaydedildi.')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Rehbere kaydedilemedi: $e')));
    }
  }
}
