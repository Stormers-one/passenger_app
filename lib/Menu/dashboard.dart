import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:passenger_app/Menu/Booking/confirmation.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'package:passenger_app/shared/services/mapServices/mapState.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

class Dashboard extends StatefulWidget {
  final fare;
  Dashboard({required this.fare, Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState(fare: fare);
}

class _DashboardState extends State<Dashboard> {
  final fare;
  _DashboardState({this.fare});
  GoogleMapController? mapController;
  LatLng? _center;
  Position? currentLocation;
  // CameraPosition _position;

  bool loading = true;

  TextEditingController? _controllerFrom;
  TextEditingController? _controllerTo;

  @override
  void initState() {
    _controllerFrom = new TextEditingController();
    _controllerTo = new TextEditingController();
    // getUserLocation();
    super.initState();
  }

  @override
  void dispose() {
    _controllerFrom?.dispose();
    _controllerTo?.dispose();
    super.dispose();
  }

  // getUserLocation() async {
  //   currentLocation = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     _center = LatLng(currentLocation!.latitude, currentLocation!.longitude);

  //     loading = false;
  //   });
  //   print('center $_center');
  // }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MapState>(context, listen: true);
    print('After selection, Dashboard :' + appState.initialPosition.toString());
    return Scaffold(
      backgroundColor: bgColor,
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.82,
                child: (appState.initialPosition == null)
                    ? Loading()
                    : SafeArea(
                        child: Stack(
                          children: <Widget>[
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  target: appState.initialPosition!,
                                  zoom: 10.0),
                              // onMapCreated: appState.onCreated,
                              // myLocationEnabled: true,
                              mapType: MapType.normal,
                              // compassEnabled: true,
                              markers: appState.markers,
                              // onCameraMove: appState.onCameraMove,
                              polylines: appState.polyLines,
                            ),
                          ],
                        ),
                      ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(100),
                          child: InkWell(
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: red,
                              ),
                              child:
                                  Icon(Icons.arrow_back, color: Colors.black),
                            ),
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: InfoField(
                                  fieldData: selectedBookingFrom,
                                  fieldName: 'From: '),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: InfoField(
                                  fieldData: selectedBookingTo,
                                  fieldName: 'To: '),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InfoField(
                                  fieldData: appState.distance,
                                  fieldName: 'Distance: '),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InfoField(
                                  fieldData: appState.duration,
                                  fieldName: 'Duration: '),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  minChildSize: 0.2,
                  maxChildSize: 0.7,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return SingleChildScrollView(
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: ListView(
                            shrinkWrap: true,
                            controller: scrollController,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            children: <Widget>[
                              BookingConfirm(
                                fare: fare,
                              ),
                            ]),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  final String fieldName;
  final String fieldData;
  InfoField({required this.fieldData, required this.fieldName});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        // padding: const EdgeInsets.all(20),
        height: 55,
        width: 180,
        decoration: BoxDecoration(
          color: salmonColor,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              width: 100,
              decoration: BoxDecoration(
                color: red,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Text(
                fieldName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                child: Text(
                  fieldData,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
