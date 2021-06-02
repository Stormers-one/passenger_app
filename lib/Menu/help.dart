import 'package:flutter/material.dart';
import 'package:passenger_app/shared/Styling/buttonStyles.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'package:passenger_app/shared/drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:passenger_app/shared/model/user.dart';
import 'package:passenger_app/shared/services/firebaseServices/database.dart';
import 'package:provider/provider.dart';

class Help extends StatefulWidget {
  @override
  _Help createState() => _Help();
}

class _Help extends State<Help> {
  TextEditingController? feedbackText;

  List<String> devs = [
    'Anandu R',
    'Afthab Nihar',
    'Aishwarya Michael',
    'Rachel Kunjumon',
    'Smitha John',
    'Kennith Philips'
  ];
  var _feedbackType = "";
  var selectedType = "";

  final List<String> feedbackType = <String>[
    'Application',
    'Route',
  ];

  @override
  void initState() {
    feedbackText = TextEditingController();
    super.initState();
  }

  double? distDouble;
  @override
  void dispose() {
    feedbackText?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<User>(context);
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand-Medium'),
      title: 'Help',
      home: Scaffold(
        backgroundColor: bgColor,
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: red,
        //   title: Text('Help'),
        // ),
        drawer: DrawerBuild(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: ListView(
              children: <Widget>[
                Container(
                  // constraints: BoxConstraints.expand(),
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  // height: MediaQuery.of(context).size.height,
                  child: Column(children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            child: Text(
                              "Send Feedback",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  maxLines: 6,
                                  controller: feedbackText,
                                  onChanged: (val) => (() {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  }),
                                  decoration: textInputDecorationNoHint(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  "Feedback Type:",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 180,
                                child: DropdownButtonFormField(
                                  hint: Text(
                                    'Select feedback type',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  value: _feedbackType.isNotEmpty
                                      ? _feedbackType
                                      : null,
                                  items: feedbackType
                                      .map((value) => new DropdownMenuItem(
                                            value: value,
                                            child: Text('$value'),
                                          ))
                                      .toList(),
                                  isExpanded: true,
                                  onChanged: (val) {
                                    print(val);
                                    _feedbackType = val.toString();
                                    selectedType = val.toString();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                  decoration: textInputDecorationNoHint(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (selectedType == "Application") {
                                  DatabaseService(uid: userID.uid!)
                                      .appFeedbackSubmit(userID.uid!,
                                          feedbackText!.text, "", "");
                                } else if (selectedType == "Route") {
                                  print("Database connection not established");
                                  Fluttertoast.showToast(
                                      msg:
                                          ("Database connection not established!"));
                                }
                                feedbackText!.clear();
                                Fluttertoast.showToast(msg: "Report Sent!");
                              },
                              child: const Text('Proceed',
                                  style: TextStyle(fontSize: 20)),
                              style: raisedButtonStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: helpBoxColor,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text('Help',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: helpColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: Text('Helpline No.',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Quicksand-SemiBold')),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: helpColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: Text('KeralaRTC Hub',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Quicksand-SemiBold')),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: factBoxColor),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(height: 10),
                            Container(
                              child: Text('Facts',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30)),
                            ),
                            SizedBox(height: 17),
                            Container(
                              decoration: BoxDecoration(
                                color: factColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              padding: const EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width * 0.80,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text('Maps',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    child: Text(
                                        'The user can input To and From locations to find the distance and duration of travel between the two locations along with the fastest route. More information such as bus timing and nearest bus stop will be added with further development',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                            SizedBox(height: 17),
                            Container(
                              decoration: BoxDecoration(
                                color: factColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              padding: const EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width * 0.80,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text('Booking',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    child: Text(
                                        ' The users can book tickets for a preferred bus type, during which the users are also made aware of the cost of their travel.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                            SizedBox(height: 17),
                            Container(
                              decoration: BoxDecoration(
                                color: factColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              padding: const EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width * 0.80,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text('Tracking',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    child: Text(
                                        'With bus fleet number one can track the location of a bus. Since we do not have real-time coordinates of buses which can be tracked using google’s transport tracking api, there was no practical way to demonstrate this.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                            SizedBox(height: 17),
                            Container(
                              decoration: BoxDecoration(
                                color: factColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              padding: const EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width * 0.80,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Timing',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    child: Text(
                                        'The user inputs To, From locations, along with type of bus and time of travel to obtain a comprehensive list of bus timings. Presently we do not have access to the state transport bus schedule therefore the app fetches this information by querying “Aanavandi” website.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                            SizedBox(height: 17),
                            Container(
                              decoration: BoxDecoration(
                                color: factColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              padding: const EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width * 0.80,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'My Booking',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    child: Text(
                                        '“My Bookings” section in the drawer allows the users to view all their current bookings.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                            SizedBox(height: 17),
                          ]),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
