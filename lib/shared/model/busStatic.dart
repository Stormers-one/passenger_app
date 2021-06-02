import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusStatic {
  final String busId;
  final String direction;
  final String latitude;
  final GeoPoint location;
  final String longitude;
  final String routeId;
  final int count;
  BusStatic(
      {this.busId,
      this.direction,
      this.latitude,
      this.location,
      this.longitude,
      this.routeId,
      this.count});
}
