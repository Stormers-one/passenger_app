import 'package:cloud_firestore/cloud_firestore.dart';

class BusStatic {
  final String? busID;
  final String? direction;
  final String? latitude;
  final GeoPoint? location;
  final String? longitude;
  final String? routeId;
  final int? count;
  BusStatic(
      {this.busID,
      this.direction,
      this.latitude,
      this.location,
      this.longitude,
      this.routeId,
      this.count});
}
