import 'package:flutter/material.dart';
import 'package:passenger_app/shared/Styling/buttonStyles.dart';
import 'package:passenger_app/shared/busSearch.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:passenger_app/shared/drawer.dart';
import 'package:passenger_app/shared/loading.dart';
import 'package:passenger_app/shared/model/busStatic.dart';
import 'package:passenger_app/shared/services/firebaseServices/database.dart';
import 'mapview.dart';
import 'package:provider/provider.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import '../../Shared/services/mapServices/mapState.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class Maps extends StatefulWidget {
  @override
  _Maps createState() => _Maps();
}

class _Maps extends State<Maps> {
  TextEditingController _controller;
  TextEditingController _controller1;
  final _formkey = GlobalKey<FormState>();
  bool clickStatMaps = false;

  @override
  void initState() {
    _controller = new TextEditingController();
    _controller1 = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller1?.dispose();
    super.dispose();
  }

  final String documentId;
  _Maps({this.documentId});

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
          List<BusStatic> busData = snapshot.data;
          return Scaffold(
            backgroundColor: bgColor,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text('Maps'),
              backgroundColor: appBarColor,
            ),
            drawer: DrawerBuild(),
            body: new GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
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
                        child: new Form(
                          key: _formkey,
                          autovalidateMode: AutovalidateMode.always,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new TextFormField(
                                controller: _controller,
                                style: new TextStyle(color: Colors.black),
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  showSearch(
                                      context: context,
                                      delegate:
                                          BusSearch("MFrom", _controller));
                                },
                                decoration: textInputDecoration("From"),
                                keyboardType: TextInputType.emailAddress,
                                cursorWidth: 0,
                                validator: (val) =>
                                    val!.isEmpty && clickStatMaps
                                        ? 'This is required'
                                        : null,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              new TextFormField(
                                  controller: _controller1,
                                  style: new TextStyle(color: Colors.black),
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    showSearch(
                                        context: context,
                                        delegate:
                                            BusSearch("MTo", _controller1));
                                  },
                                  decoration: textInputDecoration("To"),
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  cursorWidth: 0,
                                  validator: (val) {
                                    if (val!.isEmpty && clickStatMaps) {
                                      return 'This is requied';
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
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    selectedMapsFrom = _controller.text;
                                    selectedMapsTo = _controller1.text;
                                    clickStatMaps = true;
                                    if (_formkey.currentState!.validate()) {
                                      appState.sendRequest(selectedMapsFrom,
                                          selectedMapsTo, busData);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MapView()),
                                      );
                                    }
                                  },
                                  child: const Text('Search',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  style: raisedButtonStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
