import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passenger_app/Menu/dashboard.dart';
import 'package:passenger_app/shared/Styling/buttonStyles.dart';
import 'package:passenger_app/shared/busSearch.dart';
import 'package:passenger_app/shared/loading.dart';
import 'package:passenger_app/shared/model/busStatic.dart';
import 'package:passenger_app/shared/routes.dart';
import 'package:passenger_app/shared/services/mapServices/mapState.dart';
import 'package:passenger_app/shared/constants.dart';
import '../Shared/services/mapServices/googlemapservice.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:passenger_app/Shared/services/firebaseServices/database.dart';
import 'package:provider/provider.dart';

class Landing extends StatefulWidget {
  Landing({Key? key}) : super(key: key);
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  String _currentBusType = "";
  String _currenttime = "";
  TextEditingController? _controllerFrom;
  TextEditingController? _controllerTo;
  TextEditingController? _controllerExtra;
  final _formkey = GlobalKey<FormState>();
  bool clickStatus = false;
  var queryResult = [];
  var busStopName = [];
  int count = 0;

  BusListService? res = BusListService();
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  static String? _distance;
  static String? _duration;
  List<String>? mapData;
  String get distance => _distance!;
  String get duration => _duration!;

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResult = [];
        busStopName = [];
      });
    }
    //if(queryResult.length == 0 && value.length == 1 ) {
    res!.getBusStopList(value).then((QuerySnapshot docs) {
      for (var i = 0; i < docs.docs.length; i++) {
        queryResult.add(docs.docs[i].data);
      }
    });
    //}
    //else{
    busStopName = [];
    queryResult.forEach((element) {
      setState(() {
        if (element['Stop Name'].contains(value)) {
          busStopName.add(element['Stop Name']);
        }
      });
    });
    print(busStopName);
    print("\n\n\n ");
    count++;
    print(count);
  }

  final List<String> bustype = <String>[
    'Ordinary',
    'Limited Stop Ordinary',
    'Town to Town Ordinary',
    'Fast Passenger',
    'LS Fast Passenger',
    'Point to Point Fast Passenger',
    'Super Fast',
    'Super Express',
    'Super Dulex',
    'Garuda King Class Volvo',
    'Low Floor Non-AC',
    'Ananthapuri Fast',
    'Garuda Maharaja Scania',
  ];

  List<String> bustime = [
    'Time',
    'Morning : 6AM to 12PM',
    'Afternoon: 12PM to 6PM',
    'Night: 6PM to 6AM',
  ];
  bool loading = false;

  @override
  void initState() {
    _controllerFrom = TextEditingController();
    _controllerTo = TextEditingController();
    _controllerExtra = TextEditingController();
    super.initState();
  }

  double? distDouble;
  @override
  void dispose() {
    _controllerFrom?.dispose();
    _controllerTo?.dispose();
    _controllerExtra?.dispose();
    super.dispose();
  }

  Future travel(String fromLocation, String toLocation) async {
    fromLocation = fromLocation + ', Kerala';
    toLocation = toLocation + ', Kerala';
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
    mapData = await _googleMapsServices.getTravelInfo(start, destination);
    _distance = mapData![0];
    String dist = _distance!;
    dist = dist.substring(0, dist.length - 3);
    print(_distance);
    print(dist);
    this.distDouble = double.parse(dist);
    distancing(distDouble!);
  }
  // MapState appState = MapState();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MapState>(context);
    return StreamBuilder<List<BusStatic>>(
        stream: MapDatabaseService().busStaticData,
        builder: (BuildContext context, snapshot) {
          // print(snapshot);
          if (!snapshot.hasData) {
            print(snapshot.hasData);
            return Loading();
          } else {
            List<BusStatic> busData = snapshot.data!;
            return Stack(
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(30, 1, 30, 1),
                        child: Form(
                          key: _formkey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                controller: _controllerFrom,
                                style: TextStyle(color: Colors.black),
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  showSearch(
                                      context: context,
                                      delegate:
                                          BusSearch("BFrom", _controllerFrom!));
                                },
                                decoration: textInputDecoration("From"),
                                keyboardType: TextInputType.emailAddress,
                                cursorWidth: 0,
                                autofocus: false,
                                validator: (val) => val!.isEmpty && clickStatus
                                    ? 'This is required'
                                    : null,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _controllerTo,
                                style: TextStyle(color: Colors.black),
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  showSearch(
                                      context: context,
                                      delegate:
                                          BusSearch("BTo", _controllerTo!));
                                },
                                decoration: textInputDecoration("To"),
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                cursorWidth: 0,
                                validator: (val) {
                                  if (val!.isEmpty && clickStatus) {
                                    return 'This is requied';
                                  } else if (_controllerFrom!.text ==
                                          _controllerTo!.text &&
                                      _controllerFrom!.text.isNotEmpty) {
                                    return 'Both location should not be same';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField(
                                hint: Text(
                                  'Time',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                value: _currenttime.isNotEmpty
                                    ? _currenttime
                                    : null,
                                items: bustime
                                    .map((value) => DropdownMenuItem(
                                          value: value,
                                          child: Text('$value'),
                                        ))
                                    .toList(),
                                isExpanded: true,
                                onChanged: (val) => setState(() {
                                  _currenttime = val.toString();
                                  setTime(_currenttime);
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                }),
                                decoration: textInputDecorationNoHint(),
                                validator: (value) {
                                  if (value == null && clickStatus) {
                                    return "Select Bus Timing";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField(
                                hint: Text(
                                  'Bus Type',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                value: _currentBusType.isNotEmpty
                                    ? _currentBusType
                                    : null,
                                items: bustype
                                    .map((value) => DropdownMenuItem(
                                          value: value,
                                          child: Text('$value'),
                                        ))
                                    .toList(),
                                isExpanded: true,
                                onChanged: (val) => setState(() {
                                  _currentBusType = val.toString();
                                  selectedBookingBusType = val.toString();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                }),
                                decoration: textInputDecorationNoHint(),
                                validator: (value) {
                                  if (value == null && clickStatus) {
                                    return "Select The Bus Type";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    loading = true;
                                    selectedBookingFrom = _controllerFrom!.text;
                                    selectedBookingTo = _controllerTo!.text;
                                    await travel(
                                        selectedBookingFrom, selectedBookingTo);
                                    await appState.sendRequest(
                                        selectedBookingFrom,
                                        selectedBookingTo,
                                        busData);
                                    print('After selection:' +
                                        appState.initialPosition.toString());
                                    loading = false;
                                    fare =
                                        getFare(_currentBusType, distDouble!);
                                    clickStatus = true;
                                    if (_formkey.currentState!.validate()) {
                                      if (_currentBusType.isEmpty ||
                                          bkey == 0) {
                                        inUrl =
                                            'https://www.aanavandi.com//search/results/source/' +
                                                _controllerFrom!.text +
                                                '/destination/' +
                                                _controllerTo!.text +
                                                '/timing/$time1';
                                        setState(() {});
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Dashboard()));
                                      }
                                    }
                                  },
                                  child: const Text('Proceed',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  style: raisedButtonStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                loading ? Loading() : Container(),
              ],
            );
          }
        });
  }
}
