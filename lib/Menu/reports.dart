import 'package:flutter/material.dart';
import 'package:passenger_app/shared/Styling/buttonStyles.dart';
import 'package:passenger_app/shared/drawer.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'help.dart';

Color factColor = Colors.orange[200];
Color factBoxColor = bgOrange;
Color helpBoxColor = bgOrange;
Color helpColor = Colors.orange[200];

var loading = false;

var _reportType = "";
var selectedReport = "";

final List<String> reportType = <String>[
  'Breakdown',
  'Protest on route',
  'Road inaccessible',
  'Road Accident'
];

class Reports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand-Medium'),
      title: 'Reports',
      home: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          title: Text('Reports'),
          backgroundColor: appBarColor,
        ),
        drawer: DrawerBuild(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
              child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: helpBoxColor,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        new DropdownButtonFormField(
                          hint: Text(
                            'Select a report',
                            style: TextStyle(color: Colors.grey),
                          ),
                          value: _reportType.isNotEmpty ? _reportType : null,
                          items: reportType
                              .map((value) => new DropdownMenuItem(
                                    value: value,
                                    child: Text('$value'),
                                  ))
                              .toList(),
                          isExpanded: true,
                          onChanged: (val) => (() {
                            _reportType = val;
                            selectedReport = val;
                            FocusScope.of(context).requestFocus(FocusNode());
                          }),
                          decoration: textInputDecorationNoHint(),
                        ),
                      ],
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                  ),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        loading = true;
                        Fluttertoast.showToast(msg: "Report Sent!");
                        loading = false;
                      },
                      child:
                          const Text('Proceed', style: TextStyle(fontSize: 20)),
                      style: raisedButtonStyle,
                    ),
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
                          MaterialPageRoute(builder: (context) => Help()),
                        );
                      },
                      child: const Text('Go To Help Page',
                          style: TextStyle(fontSize: 20)),
                      style: raisedButtonStyle,
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
