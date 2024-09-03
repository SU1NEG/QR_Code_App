import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_generator/qr_display_page.dart'; // Kendi proje adını kullan
import 'package:share_plus/share_plus.dart'; // Share Plus paketini ekleyin
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
      ),
      body: FutureBuilder(
        future: _getContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  Contact contact = snapshot.data!.elementAt(index);
                  return ListTile(
                    title: Text(contact.displayName ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        _shareContact(contact);
                      },
                    ),
                    onTap: () {
                      _showQrCode(context, contact);
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text('No contacts found.'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<Iterable<Contact>> _getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      return await ContactsService.getContacts();
    } else {
      return [];
    }
  }

  void _showQrCode(BuildContext context, Contact contact) {
    String name = contact.displayName ?? '';
    String? phone =
        contact.phones?.isNotEmpty == true ? contact.phones?.first.value : '';
    String? email =
        contact.emails?.isNotEmpty == true ? contact.emails?.first.value : '';
    String data = 'MECARD:N:$name;TEL:$phone;EMAIL:$email;;';
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrDisplayPage(data: data)),
    );
  }

  Future<void> _shareContact(Contact contact) async {
    String name = contact.displayName ?? '';
    String? phone =
        contact.phones?.isNotEmpty == true ? contact.phones?.first.value : '';
    String? email =
        contact.emails?.isNotEmpty == true ? contact.emails?.first.value : '';

    // vCard formatında veri oluşturma
    String vCardData =
        'BEGIN:VCARD\nVERSION:3.0\nFN:$name\nTEL:$phone\nEMAIL:$email\nEND:VCARD';

    // Geçici dosya oluşturma
    final tempDir = await getTemporaryDirectory();
    final vCardFile = File('${tempDir.path}/contact.vcf');
    await vCardFile.writeAsString(vCardData);

    // Paylaşma
    Share.shareXFiles([XFile(vCardFile.path)],
        text: 'Here is the contact information for $name');
  }
}
