import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

import '../utils/location_util.dart';
import '/models/place_location.dart';
import '/models/place.dart';
import '/utils/db_util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/url_util.dart';


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
        latitude: latLng.latitude!,
        longitude: latLng.longitude!,
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


  // Future<void> loadPlaces() async {
  //   final dataList = await DbUtil.getData('places');
  //   _items = dataList
  //       .map(
  //         (item) => Place(
  //           id: item['id'],
  //           title: item['title'],
  //           image: File(item['image']),
  //           location: PlaceLocation(
  //             latitude: item['latitude'],
  //             longitude: item['longitude'],
  //             address: item['address'],
  //           ),
  //           phone: item['phone'],
  //           email: item['email'],
  //         ),
  //       )
  //       .toList();
  //   notifyListeners();
  // }
  Future<void> loadRecentPlaces() async {
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

    // Ordenar por data (considerando que o Firebase retorna 'createdAt')
    _items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _items = _items.take(10).toList();

    notifyListeners();
  }



  Future<void> addPlaceToFirebase(Place place) async {
    final url = Uri.parse('${UrlUtil.FIREBASE_URL}/places.json');
    final response = await http.post(
      url,
      body: json.encode({
        'title': place.title,
        'image': place.image.path,
        'latitude': place.location?.latitude,
        'longitude': place.location?.longitude,
        'address': place.location?.address,
        'phone': place.phone,
        'email': place.email,
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );
    if (response.statusCode >= 400) {
      throw Exception('Failed to save place on Firebase');
    }
  }

  Future<void> syncWithFirebase() async {
    final url = Uri.parse('${UrlUtil.FIREBASE_URL}/places.json');
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch data from Firebase');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final List<Place> firebasePlaces = [];

    data.forEach((id, placeData) {
      firebasePlaces.add(
        Place(
          id: id,
          title: placeData['title'],
          image: File(placeData['image']),
          location: PlaceLocation(
            latitude: placeData['latitude'],
            longitude: placeData['longitude'],
            address: placeData['address'],
          ),
          phone: placeData['phone'],
          email: placeData['email'],
        ),
      );
    });

    // Atualizar SQLite
    for (var place in firebasePlaces) {
      DbUtil.insert('places', {
        'id': place.id,
        'title': place.title,
        'image': place.image.path,
        'latitude': place.location!.latitude,
        'longitude': place.location!.longitude,
        'address': place.location!.address,
        'phone': place.phone!,
        'email': place.email!,
      });
    }

    notifyListeners();
  }

}
