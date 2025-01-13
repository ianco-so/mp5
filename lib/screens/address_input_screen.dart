import 'package:flutter/material.dart';
import '../utils/location_util.dart';

class AddressInputScreen extends StatefulWidget {
  @override
  _AddressInputScreenState createState() => _AddressInputScreenState();
}

class _AddressInputScreenState extends State<AddressInputScreen> {
  final _addressController = TextEditingController();

  Future<void> _fetchCoordinates() async {
    if (_addressController.text.isEmpty) return;

    final coordinates = await LocationUtil.getCoordinatesFromAddress(_addressController.text);
    Navigator.of(context).pop(coordinates); // Retorna para a tela anterior com as coordenadas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Digite o Endereço')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Endereço Completo'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchCoordinates,
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}