import 'dart:io';

import 'package:f09_recursos_nativos/components/image_input.dart';
import 'package:f09_recursos_nativos/components/location_input.dart';
import 'package:f09_recursos_nativos/provider/places_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class PlaceFormScreen extends StatefulWidget {
  @override
  _PlaceFormScreenState createState() => _PlaceFormScreenState();
}
class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  File? _pickedImage;
  LatLng? _pickedLocation;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectLocation(LatLng pickedLocation) {
    _pickedLocation = pickedLocation;
  }

  Future<void> _submitForm() async {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty) {
      return;
    }

    Provider.of<PlacesModel>(context, listen: false).addPlace(
      _titleController.text,
      _pickedImage!,
      _phoneController.text,
      _emailController.text,
      _pickedLocation!,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Novo Lugar')),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Título'),
          ),
          ImageInput(_selectImage),
          LocationInput(_selectLocation),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'Telefone'),
            keyboardType: TextInputType.phone,
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
