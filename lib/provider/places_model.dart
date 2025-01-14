import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

import '../utils/location_util.dart';
import '/models/place_location.dart';
import '/models/place.dart';
import '/utils/db_util.dart';


class PlacesModel with ChangeNotifier {
  List<Place> _items = [];


  List<Place> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int index) {
    return _items[index];
  }

  void addPlace(String title, File image, String phone, String email, LatLng latLng) async {
    final address = await LocationUtil.getAddressFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    // Print location and address
    print('Latitude: ${latLng.latitude}');
    print('Longitude: ${latLng.longitude}');
    print('Address: $address');

    final newPlace = Place(
      id: Random().nextDouble().toString(),
      title: title,
      location: PlaceLocation(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        address: address,
      ),
      image: image,
      phone: phone,
      email: email,
    );

    _items.add(newPlace);
    DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'latitude': newPlace.location!.latitude,
      'longitude': newPlace.location!.longitude,
      'address': newPlace.location!.address,
      'phone': newPlace.phone!,
      'email': newPlace.email!,
    });
    notifyListeners();
  }


  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: PlaceLocation(
              latitude: item['latitude'],
              longitude: item['longitude'],
              address: item['address'],
            ),
            phone: item['phone'],
            email: item['email'],
          ),
        )
        .toList();
    notifyListeners();
  }
}
