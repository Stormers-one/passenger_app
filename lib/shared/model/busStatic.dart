import 'package:cloud_firestore/cloud_firestore.dart';

class BusStatic {
  final String? busId;
  final String? direction;
  final String? latitude;
  final GeoPoint? location;
  final String? longitude;
  final String? routeId;
  final int? count;
  BusStatic(
      {this.busId,
      this.direction,
      this.latitude,
      this.location,
      this.longitude,
      this.routeId,
      this.count});
}
