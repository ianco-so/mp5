import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/map_screen.dart';
import '../utils/location_util.dart';
class LocationInput extends StatefulWidget {
  final Function onSelectLocation;

  // LocationInput(this.onSelectLocation);
  LocationInput(this.onSelectLocation, {Key? key}) : super(key: key); // Pass key to parent

  @override
  LocationInputState createState() => LocationInputState();
}

class LocationInputState extends State<LocationInput> {
  // final locationInputKey = GlobalKey<LocationInputState>();
  String? _previewImageUrl;
  LatLng? _selectedLocation;

  void updateMapPreview(LatLng coordinates) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
      _selectedLocation = coordinates;
    });

    widget.onSelectLocation(_selectedLocation!);
  }

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    updateMapPreview(LatLng(locData.latitude!, locData.longitude!));
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MapScreen(),
      ),
    );

    if (selectedPosition != null) {
      updateMapPreview(selectedPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? Text('Localização não informada!')
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Localização atual'),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              label: Text('Selecione no Mapa'),
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
