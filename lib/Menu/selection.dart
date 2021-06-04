import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passenger_app/Menu/Booking/confirmation.dart';
import 'package:passenger_app/Menu/dashboard.dart';
import 'package:passenger_app/shared/Styling/buttonStyles.dart';
import 'package:passenger_app/shared/busSearch.dart';
import 'package:passenger_app/shared/loading.dart';
import 'package:passenger_app/shared/model/busStatic.dart';
import 'package:passenger_app/shared/services/firebaseServices/auth.dart';
import 'package:passenger_app/shared/services/mapServices/mapState.dart';
import '../shared/Styling/colors.dart';
import 'package:passenger_app/shared/constants.dart';
import '../Shared/services/mapServices/googlemapservice.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:passenger_app/shared/model/ticketmodel.dart';
import 'package:passenger_app/Shared/services/firebaseServices/database.dart';
import 'package:passenger_app/shared/model/user.dart';
import 'package:provider/provider.dart';
import 'package:passenger_app/shared/Styling/colors.dart';

class Selection extends StatefulWidget {
  Selection({Key? key}) : super(key: key);
  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  String _currentBusType = "";
  String _currenttime = "";
  TextEditingController? _controllerFrom;
  TextEditingController? _controllerTo;
  TextEditingController? _controllerExtra;
  final _formkey = GlobalKey<FormState>();
  bool clickStatbooking = false;
  bool clickStatTiming = false;
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

  bool clickStatBooking = false;

  // MapState appState = MapState();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MapState>(context);
    // final appState = context.watch<MapState>();
    final userID = Provider.of<User>(context);
    print('Within selection: ' + userID.uid.toString());
    // print('Before selection:' +
    //     appState.initialPosition
    //         .toString());
    // final userID = Provider.of<User>(context);
    // print("[Booking] User is: " + userID.uid.toString());
    return StreamBuilder<List<BusStatic>>(
        stream: MapDatabaseService().busStaticData,
        builder: (BuildContext context, snapshot) {
          // print(snapshot);
          if (!snapshot.hasData) {
            print(snapshot.hasData);
            return Loading();
          } else {
            List<BusStatic> busData = snapshot.data!;
            return Container(
              color: bgColor,
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
                            controller: _controllerFrom,
                            style: TextStyle(color: Colors.black),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              showSearch(
                                  context: context,
                                  delegate:
                                      BusSearch("BFrom", _controllerFrom!));
                            },
                            decoration: textInputDecoration("From"),
                            keyboardType: TextInputType.emailAddress,
                            cursorWidth: 0,
                            autofocus: false,
                            validator: (val) => val!.isEmpty && clickStatBooking
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
                              FocusScope.of(context).requestFocus(FocusNode());
                              showSearch(
                                  context: context,
                                  delegate: BusSearch("BTo", _controllerTo!));
                            },
                            decoration: textInputDecoration("To"),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            cursorWidth: 0,
                            validator: (val) {
                              if (val!.isEmpty && clickStatBooking) {
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
                            value:
                                _currenttime.isNotEmpty ? _currenttime : null,
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
                              FocusScope.of(context).requestFocus(FocusNode());
                            }),
                            decoration: textInputDecorationNoHint(),
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
                              FocusScope.of(context).requestFocus(FocusNode());
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
                                selectedBookingFrom = _controllerFrom!.text;
                                selectedBookingTo = _controllerTo!.text;
                                await travel(
                                    selectedBookingFrom, selectedBookingTo);
                                await appState.sendRequest(selectedBookingFrom,
                                    selectedBookingTo, busData);
                                print('After selection:' +
                                    appState.initialPosition.toString());

                                loading = false;
                                fare = getFare(_currentBusType, distDouble!);
                                clickStatBooking = true;
                                if (_formkey.currentState!.validate()) {
                                  if (_currentBusType.isEmpty || bkey == 0) {
                                    inUrl =
                                        'https://www.aanavandi.com//search/results/source/' +
                                            _controllerFrom!.text +
                                            '/destination/' +
                                            _controllerTo!.text +
                                            '/timing/$time1';
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Dashboard(fare: fare!)));
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
            );
          }
        });
  }
}

class BookingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<User>(context);
    return StreamProvider<List<TicketData>>.value(
      initialData: [],
      value: DatabaseService(uid: userID.uid!).getUserBookings,
      child: MaterialApp(
        title: 'My Bookings',
        theme: ThemeData(fontFamily: 'Quicksand-Medium'),
        home: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            elevation: 0,
            title: Text('My Bookings'),
            backgroundColor: appBarColor,
          ),
          body: BookLister(),
        ),
      ),
    );
  }
}

class BookLister extends StatefulWidget {
  @override
  _BookListerState createState() => _BookListerState();
}

class _BookListerState extends State<BookLister> {
  @override
  Widget build(BuildContext context) {
    final book = Provider.of<List<TicketData>>(context);
    print(book);
    book.forEach((f) {
      print(f.bookid);
    });
    return ListView.builder(
      itemCount: book.length,
      itemBuilder: (context, index) {
        return BookingTile(book: book[index]);
      },
    );
  }
}

class BookingTile extends StatelessWidget {
  final TicketData book;
  BookingTile({required this.book});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Card(
          color: Colors.orange[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            //  CircleAvatar(
            //    radius: 50.0,
            //    backgroundColor: red,
            //  ),
            title: Text("Booking ID: " + book.bookid!),
            subtitle: Text("From: " + book.bookfrom! + "\nTo: " + book.bookto!),
          ),
        ));
  }
}
