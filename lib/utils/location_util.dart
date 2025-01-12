import 'package:http/http.dart' as http;
import 'dart:convert';


const GOOGLE_API_KEY = 'AIzaSyCKUtPnx83SazE84hyETiCY9omPf3nmDEg';
class LocationUtil {
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    //https://developers.google.com/maps/documentation/maps-static/overview
    //https://pub.dev/packages/google_maps_flutter
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getAddressFromCoordinates(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY');
    final response = await http.get(url);
    final data = json.decode(response.body);
    if (data['results'] == null || data['results'].isEmpty) {
      return 'Endereço não encontrado!';
    }
    return data['results'][0]['formatted_address'];
  }
}
