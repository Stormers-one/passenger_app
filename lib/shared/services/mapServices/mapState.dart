import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'package:passenger_app/shared/model/busStatic.dart';
import 'googlemapservice.dart';
import 'package:geocoding/geocoding.dart';

class MapState with ChangeNotifier {
  static LatLng? _initialPosition;
  bool locationServiceActive = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  // GoogleMapController? _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();

  // Map access Split START
  // bool get tracking => _tracking;
  // set tracking(bool track) => _tracking;
  // static bool _tracking;
  // Map access Split END

  // Distance START
  static String _distance = "";
  static String _duration = "";
  static List<String> _gmapData = [];
  List<String> get gmapData => _gmapData;
  String get distance => _distance;
  String get duration => _duration;
  // Distance END

  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  LatLng? get initialPosition => _initialPosition!;
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  // GoogleMapController get mapController => _mapController!;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;

  String? _from, _to, _routeName;
  String get routeName => _routeName!;

  List<BusStatic>? _busData;
  set setBusData(List<BusStatic> busData) {
    this._busData = busData;
  }

  MapState() {
    // _getUserLocation();
    _setCustomMapPin();
  }

  String extractRouteName(String s) {
    s = s.split(' ')[0].toLowerCase();
    s = s[0].toUpperCase() + s.substring(1);
    return s;
  }

  RegExp expRouteExtract = new RegExp(r'([\w ]+)[^(\w+)]?');

  String extractRoute(String route) {
    var _from =
        expRouteExtract.stringMatch(route).toString().trim().toLowerCase();
    var _fromList = _from.split(' ');
    List<String> newList = [];
    _fromList.forEach((element) {
      if (element != 'bs') {
        newList.add(element);
      }
    });
    var _res = newList.join(' ');
    return _res;
  }

  static List<BitmapDescriptor?> _pinList = [];

  void _setCustomMapPin() async {
    _pinList.add(await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/bus_loc_red.png'));
    _pinList.add(await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/bus_loc_orange.png'));
    _pinList.add(await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/bus_loc_yellow.png'));
    _pinList.add(await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/bus_loc_green.png'));
  }

  // ! TO CREATE ROUTE
  sendRequest(String _fromLocation, String _toLocation) async {
    String fromLocation = _fromLocation + ', Kerala';
    String toLocation = _toLocation + ', Kerala';
    List<Location> placemark1 = await locationFromAddress(fromLocation);
    print(placemark1);
    List<Location> placemark2 = await locationFromAddress(toLocation);
    print(placemark2);
    double latitude1 = placemark1[0].latitude;
    double longitude1 = placemark1[0].longitude;
    double latitude2 = placemark2[0].latitude;
    double longitude2 = placemark2[0].longitude;
    LatLng start = LatLng(latitude1, longitude1);
    LatLng destination = LatLng(latitude2, longitude2);
    _markers.clear();
    _addMarker(start, fromLocation);
    _addMarker(destination, toLocation);
    // _from = extractRouteName(fromLocation);
    // _to = extractRouteName(toLocation);
    _from = extractRoute(_fromLocation);
    _to = extractRoute(_toLocation);
    _from = _from![0].toUpperCase() + _from!.substring(1);
    _to = _to![0].toUpperCase() + _to!.substring(1);
    _routeName = _from! + ' - ' + _to!;
    print(_fromLocation);
    print(_from);
    print(_routeName);
    String route =
        await _googleMapsServices.getRouteCoordinates(start, destination);
    createRoute(route);
    _gmapData = await _googleMapsServices.getTravelInfo(start, destination);
    _distance = _gmapData[0];
    _duration = _gmapData[1];
    _initialPosition = start;

    notifyListeners();
  }

  setBusMarkers() {
    print('set bus markers');
    int i;
    for (i = 0; i < _busData!.length; i++) {
      print(_busData![i]);
      _addBusMarker(
        LatLng(double.parse(_busData![i].latitude!),
            double.parse(_busData![i].longitude!)),
        _busData![i],
      );
    }
    notifyListeners();
  }

  int opt = 3;
  void _addBusMarker(LatLng location, BusStatic data) {
    if (data.count! < 20) {
      opt = 3;
    } else if (data.count! > 20 && data.count! < 40) {
      opt = 2;
    } else if (data.count! > 40 && data.count! > 50) {
      opt = 1;
    } else {
      opt = 0;
    }

    _markers.add(Marker(
        markerId: MarkerId(data.busID.toString()),
        position: location,
        infoWindow: InfoWindow(
            title: data.busID,
            snippet: 'Direction: ' + data.direction.toString()),
        icon: _pinList[opt]!));
    notifyListeners();
  }

  void _addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(address.toString()),
        position: location,
        infoWindow: InfoWindow(title: address),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  void createRoute(String encondedPoly) {
    _polyLines.clear();
    _polyLines.add(Polyline(
        polylineId: PolylineId(_initialPosition.toString()),
        width: 7,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: red));
    // notifyListeners();
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  // ! ON CAMERA MOVE
  void onCameraMove(CameraPosition position) {
    notifyListeners();
  }

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    setBusMarkers();
    notifyListeners();
  }
}
