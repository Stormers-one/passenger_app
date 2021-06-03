import 'package:flutter/material.dart';
import 'package:passenger_app/shared/Styling/buttonStyles.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'mapview.dart';

class Tracking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracking',
      theme: ThemeData(fontFamily: 'Quicksand-Medium'),
      home: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          title: Text('Tracking'),
          backgroundColor: appBarColor,
        ),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/images/bus_fleet.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(40.0),
                        child: new Form(
                          autovalidateMode: AutovalidateMode.always,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new TextFormField(
                                decoration: textInputDecoration("Fleet Number"),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                              ),
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MapView()),
                                    );
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
                ]),
          ),
        ),
      ),
    );
  }
}

class Track extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand-Medium'),
      title: 'Track',
      home: Scaffold(
        backgroundColor: Colors.orange[100],
        appBar: AppBar(
          elevation: 0,
          title: Text('Track'),
        ),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                constraints: BoxConstraints.expand(
                  height:
                      Theme.of(context).textTheme.headline4!.fontSize! * 1.1 +
                          200.0,
                ),
                padding: const EdgeInsets.all(8.0),
                color: Colors.blue[600],
                alignment: Alignment.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
