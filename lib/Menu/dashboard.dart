import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passenger_app/Menu/Booking/confirmation.dart';
import 'package:passenger_app/Menu/Maps/mapview.dart';
import 'package:passenger_app/shared/Styling/colors.dart';

class Dashboard extends StatefulWidget {
  final fare;
  Dashboard({required this.fare});
  @override
  _DashboardState createState() => _DashboardState(fare: fare);
}

class _DashboardState extends State<Dashboard> {
  final fare;
  _DashboardState({this.fare});
  @override
  Widget build(BuildContext context) {
    // final appstate = Provider.of<MapState>(context);
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
            elevation: 0,
            title: Text('Confirm Details'),
            backgroundColor: appBarColor,
            actions: <Widget>[]),
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
                  height: MediaQuery.of(context).size.height * 3 / 4,
                  child: MapView(),
                ),
                DraggableScrollableSheet(
                    initialChildSize: 0.3,
                    minChildSize: 0.2,
                    maxChildSize: 0.8,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return SingleChildScrollView(
                        child: Container(
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
        ));
  }
}
