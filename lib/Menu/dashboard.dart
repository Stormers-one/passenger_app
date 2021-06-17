import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passenger_app/Menu/Booking/confirmation.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:passenger_app/shared/loading.dart';
import 'package:passenger_app/shared/model/busStatic.dart';
import 'package:passenger_app/shared/services/firebaseServices/database.dart';
import 'package:passenger_app/shared/services/mapServices/mapState.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Dashboard extends StatefulWidget {
  // final fare;
  // Dashboard({required this.fare, Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // final fare;
  // _DashboardState({this.fare});
  GoogleMapController? mapController;
  // LatLng? _center;
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
  Future<bool> _onWillPop() async {
    Navigator.popUntil(context, ModalRoute.withName('/'));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MapState>(context, listen: true);
    print('After selection, Dashboard :' + appState.initialPosition.toString());
    return WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Scaffold(
          backgroundColor: bgColor,
          body: new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: StreamBuilder<List<BusStatic>>(
                stream: MapDatabaseService(routeName: appState.routeName)
                    .busStaticData,
                builder: (BuildContext context, snapshot) {
                  // print(snapshot);
                  if (!snapshot.hasData) {
                    print(snapshot.hasData);
                    return Loading();
                  } else {
                    appState.setBusData = snapshot.data!;
                    print(snapshot.data);
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.82,
                            child: (appState.initialPosition == null)
                                ? Container(
                                    color: Colors.white,
                                    child: Loading(),
                                  )
                                : SafeArea(
                                    child: Stack(
                                      children: <Widget>[
                                        GoogleMap(
                                          initialCameraPosition: CameraPosition(
                                              target: appState.initialPosition!,
                                              zoom: 10.0),
                                          onMapCreated: appState.onCreated,
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
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: red,
                                          ),
                                          child: Icon(Icons.arrow_back,
                                              color: Colors.black),
                                        ),
                                        onTap: () => Navigator.popUntil(
                                            context, ModalRoute.withName('/')),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Container(),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: raspberryColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                        selectedBookingFrom,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(
                                                      MdiIcons
                                                          .swapHorizontalBold,
                                                      color: Colors.white),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                        selectedBookingTo,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: Container(),
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
                              initialChildSize: 0.2,
                              minChildSize: 0.2,
                              maxChildSize: 0.65,
                              builder: (BuildContext context,
                                  ScrollController scrollController) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                  child: Container(
                                    color: Colors.white,
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: Column(
                                          // shrinkWrap: true,
                                          // controller: scrollController,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0,
                                                          bottom: 5.0),
                                                  child: Icon(
                                                    Icons
                                                        .horizontal_rule_rounded,
                                                    size: 30,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(25),
                                                ),
                                                child: Container(
                                                  color: Colors.grey.shade200,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.55,
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    children: [
                                                      BookingConfirm(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                    );
                  }
                }),
          ),
        ));
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
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
