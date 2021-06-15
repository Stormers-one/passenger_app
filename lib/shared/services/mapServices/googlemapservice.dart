// import '../Maps/distance.java';

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:passenger_app/privateConfig.dart';

const apiKey = Constants.GoogleServices_api_key;

class GoogleMapsServices {
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    Uri url = Uri.https("maps.googleapis.com", "/maps/api/directions/json", {
      "origin": "${l1.latitude},${l1.longitude}",
      "destination": "${l2.latitude},${l2.longitude}",
      "key": apiKey
    });
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"] ?? '';
  }

  Future<List<String>> getTravelInfo(LatLng l1, LatLng l2) async {
    Uri url =
        Uri.https("maps.googleapis.com", "/maps/api/distancematrix/json", {
      "units": "metric",
      "origins": "${l1.latitude},${l1.longitude}",
      "destinations": "${l2.latitude},${l2.longitude}",
      "key": apiKey
    });
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    // print("Values Variable : $values");
    List<String> _gmapData = [
      values["rows"][0]["elements"][0]["distance"]["text"],
      values["rows"][0]["elements"][0]["duration"]["text"]
    ];
    return _gmapData;
  }
}
