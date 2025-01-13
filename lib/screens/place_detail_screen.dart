import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/place.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;

  PlaceDetailScreen(this.place);

  // Future<void> _launchPhone(String phone) async {
  //   final url = 'tel:$phone';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> _launchPhone(String phone) async {
    // final url = 'tel:$phone';
    final url = Uri.parse('tel:+55$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchEmail(String email) async {
    // final url = 'mailto:$email';
    final url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchMap(double lat, double lng) async {
    // final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.file(
              place.image,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              place.location?.address ?? 'Endereço não disponível',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 10),
            TextButton.icon(
              icon: Icon(Icons.phone),
              label: Text(place.phone ?? 'Sem telefone'),
              onPressed: () => _launchPhone(place.phone!),
            ),
            TextButton.icon(
              icon: Icon(Icons.email),
              label: Text(place.email ?? 'Sem email'),
              onPressed: () => _launchEmail(place.email!),
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              label: Text('Ver no mapa'),
              onPressed: () => _launchMap(
                place.location!.latitude,
                place.location!.longitude,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
