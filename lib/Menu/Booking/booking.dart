import 'package:flutter/material.dart';
import 'package:passenger_app/Menu/Booking/confirmation.dart';
import 'package:passenger_app/shared/Styling/buttonStyles.dart';
import 'package:passenger_app/shared/busSearch.dart';
import '../../shared/Styling/colors.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:passenger_app/shared/drawer.dart';
import '../../Shared/services/mapServices/googlemapservice.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../shared/loading.dart';
import 'package:geocoding/geocoding.dart';

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String _currentBusType = "";
  TextEditingController _controller;
  TextEditingController _controller1;
  TextEditingController _controller2;
  final _formkey = GlobalKey<FormState>();
  bool clickStatbooking = false;

  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  static String _distance;
  static String _duration;
  List<String> mapData;
  String get distance => _distance;
  String get duration => _duration;

  // Future<Null> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2020, 2),
  //       lastDate: DateTime(2020, 6));
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //       _controller2.text = formatter.format(selectedDate);
  //     });
  // }

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
    _controller = TextEditingController();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    super.initState();
  }

  double distDouble;
  @override
  void dispose() {
    _controller?.dispose();
    _controller1?.dispose();
    _controller2?.dispose();
    super.dispose();
  }

  Future<List<String>> travel(String fromLocation, String toLocation) async {
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
    _distance = mapData[0];
    String dist = _distance;
    dist = dist.substring(0, dist.length - 3);
    print(_distance);
    print(dist);
    distDouble = double.parse(dist);
    distancing(distDouble);
  }

  bool clickStatBooking = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand-Medium'),
      title: 'Booking',
      home: loading
          ? Loading()
          : Scaffold(
              backgroundColor: bgColor,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 0,
                title: Text('Booking'),
                backgroundColor: appBarColor,
              ),
              drawer: DrawerBuild(),
              body: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(60.0),
                  alignment: Alignment.center,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Container(
                        child: Form(
                          key: _formkey,
                          autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                controller: _controller,
                                style: TextStyle(color: Colors.black),
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  showSearch(
                                      context: context,
                                      delegate:
                                          BusSearch("BFrom", _controller));
                                },
                                decoration: textInputDecoration("From"),
                                keyboardType: TextInputType.emailAddress,
                                cursorWidth: 0,
                                autofocus: false,
                                validator: (val) =>
                                    val.isEmpty && clickStatBooking
                                        ? 'This is required'
                                        : null,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _controller1,
                                style: TextStyle(color: Colors.black),
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  showSearch(
                                      context: context,
                                      delegate: BusSearch("BTo", _controller1));
                                },
                                decoration: textInputDecoration("To"),
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                cursorWidth: 0,
                                validator: (val) {
                                  if (val.isEmpty && clickStatBooking) {
                                    return 'This is requied';
                                  } else if (_controller.text ==
                                          _controller1.text &&
                                      _controller.text.isNotEmpty) {
                                    return 'Both location should not be same';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 60.0,
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
                                  _currentBusType = val;
                                  selectedBookingBusType = val;
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                }),
                                decoration: textInputDecorationNoHint(),
                                validator: (value) {
                                  if (value == null && clickStatBooking) {
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
                                    await travel(
                                        selectedBookingFrom, selectedBookingTo);
                                    loading = false;
                                    fare = getFare(_currentBusType, distDouble);
                                    clickStatBooking = true;
                                    if (_formkey.currentState.validate()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BookingConfirm(fare: fare)));
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
              ),
            ),
    );
  }
}
