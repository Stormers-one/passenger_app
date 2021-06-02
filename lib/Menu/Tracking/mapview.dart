// Kerala City limits :
// southwest: LatLng(7.962818, 74.949406),
// northeast: LatLng(11.879561, 77.688881),

import 'package:flutter/material.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../shared/loading.dart';
// import '../Maps/distance.java';

class MapView extends StatefulWidget {
  @override
  _MapView createState() => _MapView();
}

class _MapView extends State<MapView> {
  GoogleMapController mapController;
  LatLng _center;
  Position currentLocation;
  CameraPosition _position;
  bool loading = true;

  BitmapDescriptor pinLocationIcon;

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/position.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });

    getUserLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // final Map<String, Marker> _markers = {};
  Set<Marker> _markers = {};

  getUserLocation() async {
    currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      _markers.clear();
      _markers.add(Marker(
          markerId: MarkerId('curr_loc'),
          position: _center,
          icon: pinLocationIcon));
      loading = false;
    });
    print('center $_center');
  }

  void _onMapCreated(GoogleMapController mapController) {
    this.mapController = mapController;
  }

  void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _position = position;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand-Medium'),
      home: loading
          ? Loading()
          : Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: red,
                title: Text('Bus Routes'),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Stack(
                  children: <Widget>[
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 11.0,
                      ),
                      compassEnabled: true,
                      onCameraMove: _updateCameraPosition,
                      // markers: _markers,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
