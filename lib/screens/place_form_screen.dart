import 'dart:io';

import '/components/image_input.dart';
import '/components/location_input.dart';
import '/provider/places_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'address_input_screen.dart';


class PlaceFormScreen extends StatefulWidget {
  @override
  _PlaceFormScreenState createState() => _PlaceFormScreenState();
}
class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final GlobalKey<LocationInputState> _locationInputKey = GlobalKey<LocationInputState>();
  // final _addressController = TextEditingController();
  File? _pickedImage;
  LatLng? _pickedLocation;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectLocation(LatLng pickedLocation) {
    _pickedLocation = pickedLocation;
  }

  void _selectAddress() async {
    final coordinates = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AddressInputScreen(),
      ),
    );

    print("=================================================================");
    print(coordinates);
    print("=================================================================");
    if (coordinates == null) return;
    setState(() {
      _pickedLocation = coordinates;
    });


    // Atualiza o preview do mapa no LocationInput
    // final locationInputKey = GlobalKey<_LocationInputState>();
    // locationInputKey.currentState?.updateMapPreview(coordinates);
     _locationInputKey.currentState?.updateMapPreview(coordinates);
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
          // TextField(
          //   controller: _addressController,
          //   decoration: InputDecoration(labelText: 'Endereço'),
          // ),
          TextButton.icon(
            icon: Icon(Icons.search),
            label: Text('Inserir Endereço'),
            onPressed: _selectAddress,
          ),
          LocationInput(
            _selectLocation,
           key: _locationInputKey ,
          ),
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
