import 'dart:io';

import 'package:f09_recursos_nativos/components/image_input.dart';
import 'package:f09_recursos_nativos/components/location_input.dart';
import 'package:f09_recursos_nativos/provider/places_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PlaceFormScreen extends StatefulWidget {
  @override
  _PlaceFormScreenState createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  File? _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _submitForm() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null          ||
        _phoneController.text.isEmpty || 
        _emailController.text.isEmpty) {
      return;
    }
    // Provider.of<PlacesModel>(context, listen: false)
    //     .addPlace(_titleController.text, _pickedImage!);

    Provider.of<PlacesModel>(context, listen: false).addPlace(
      _titleController.text,
      _pickedImage!,
      _phoneController.text,
      _emailController.text,
    );
    Navigator.of(context).pop();

    // Navigator.of(context).pop();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Novo Lugar', style: TextStyle(color: Colors.white),),
  //       backgroundColor: Colors.indigo,
  //     ),
  //     body: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         Expanded(
  //           child: SingleChildScrollView(
  //             child: Padding(
  //               padding: const EdgeInsets.all(10),
  //               child: Column(
  //                 children: [
  //                   TextField(
  //                     controller: _titleController,
  //                     decoration: InputDecoration(labelText: 'Título',),
  //                   ),
  //                   SizedBox(height: 10),
  //                   ImageInput(this._selectImage),
  //                   SizedBox(height: 10),
  //                   LocationInput(),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: ElevatedButton.icon(
  //             icon: Icon(Icons.add),
  //             label: Text('Adicionar'),
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Theme.of(context).colorScheme.secondary,
  //               elevation: 0,
  //               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //             ),
  //             onPressed: _submitForm,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
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
          LocationInput(),
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
