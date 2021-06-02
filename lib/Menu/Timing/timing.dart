import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger_app/Menu/Timing/avtimes.dart';
import 'package:passenger_app/shared/Styling/buttonStyles.dart';
import 'package:passenger_app/shared/busSearch.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:passenger_app/shared/model/busStop.dart';
import 'package:passenger_app/Shared/services/firebaseServices/database.dart';
import 'package:passenger_app/shared/drawer.dart';
import 'package:provider/provider.dart';
import 'package:passenger_app/shared/Styling/colors.dart';

class Timing extends StatefulWidget {
  @override
  _Timing createState() => _Timing();
}

class _Timing extends State<Timing> {
  String _currentBusType = "";
  String _currenttime = "";
  var queryResult = [];
  var busStopName = [];
  int count = 0;
  DatabaseService res = DatabaseService();
  TextEditingController _controller;
  TextEditingController _controller1;
  final _formkey = GlobalKey<FormState>();
  bool clickStatTiming = false;

  final List<String> bustype = <String>[
    'Bus Type',
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

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResult = [];
        busStopName = [];
      });
    }
    //if(queryResult.length == 0 && value.length == 1 ) {
    res.getBusStopList(value).then((QuerySnapshot docs) {
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

  @override
  void initState() {
    _controller = TextEditingController();
    _controller1 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller1?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   bkey = 0;
    // });
    return StreamProvider<List<BusStopData>>.value(
      initialData: [],
      value: DatabaseService().busStopData,
      child: MaterialApp(
        title: 'Bus Timing',
        theme: ThemeData(fontFamily: 'Quicksand-Medium'),
        home: Scaffold(
          backgroundColor: bgColor,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            title: Text('Bus Timing'),
            backgroundColor: appBarColor,
          ),
          drawer: DrawerBuild(),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: _controller,
                              style: TextStyle(color: Colors.black),
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                showSearch(
                                    context: context,
                                    delegate: BusSearch("From", _controller));
                              },
                              decoration: textInputDecoration("From"),
                              keyboardType: TextInputType.emailAddress,
                              cursorWidth: 0,
                              autofocus: false,
                              validator: (val) => val.isEmpty && clickStatTiming
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
                                      delegate: BusSearch("To", _controller1));
                                },
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration("To"),
                                keyboardType: TextInputType.text,
                                cursorWidth: 0,
                                validator: (val) {
                                  if (val.isEmpty && clickStatTiming) {
                                    return 'This is required';
                                  } else if (_controller.text ==
                                          _controller1.text &&
                                      _controller.text.isNotEmpty) {
                                    return 'Both location should not be same';
                                  } else {
                                    return null;
                                  }
                                }),
                            SizedBox(
                              height: 30,
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
                              onChanged: (val) {
                                setState(() {
                                  _currentBusType = val;
                                  // bkey = setBusKey(_currentBusType.toString());
                                  // print(bkey);
                                });
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              decoration: textInputDecorationNoHint(),
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
                                _currenttime = val;
                                setTime(_currenttime);
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }),
                              decoration: textInputDecorationNoHint(),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 50,
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () async {
                                  clickStatTiming = true;
                                  if (_formkey.currentState.validate()) {
                                    if (_currentBusType.isEmpty || bkey == 0) {
                                      inUrl =
                                          'https://www.aanavandi.com//search/results/source/' +
                                              _controller.text +
                                              '/destination/' +
                                              _controller1.text +
                                              '/timing/$time1';
                                    }
                                    // else{
                                    //   inUrl = 'https://www.aanavandi.com//search/results/source/'+ _controller.text +'/destination/'+ _controller1.text +'/type/$bkey/timing/$time1';
                                    // }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Aanavandi()),
                                    );
                                  }
                                },
                                child: const Text('Search',
                                    style: TextStyle(fontSize: 20)),
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
        ),
      ),
    );
  }
}
