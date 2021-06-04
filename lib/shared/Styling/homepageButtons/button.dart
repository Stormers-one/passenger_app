import 'package:flutter/material.dart';
import 'package:passenger_app/Menu/Booking/bookingList.dart';
import 'package:passenger_app/Menu/Timing/avtimes.dart';
import 'package:passenger_app/Menu/Tracking/tracking.dart';
import 'package:passenger_app/Menu/help.dart';
// import '../homepageButtons/buttonClass.dart';
// import '../homepageButtons/data.dart';

class Button extends StatelessWidget {
  final String image;
  final String route;
  final String text;
  final BuildContext context;
  final int index = 0;
  Button(
      {required this.image,
      required this.route,
      required this.text,
      required this.context});
  // @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.transparent)),
      fillColor: Colors.grey.shade300,
      splashColor: Colors.grey,
      textStyle: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0),
      child: Container(
        height: 90,
        width: 90,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(
                image,
              ),
              height: 70,
              width: 70,
            ),
            // SizedBox(
            //   height: 2,
            // ),
            Text(text,
                style: TextStyle(
                  fontFamily: 'Quicksand-Bold',
                )),
          ],
        ),
      ),
      onPressed: () {
        _navigate(route);
      },
    );
  }

  void _navigate(String route) {
    // Navigator.of(context).pushNamed('/$route');
    if (route == 'Tracking') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Tracking()),
      );
    } else if (route == 'BookingList') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookingList()),
      );
    } else if (route == 'Timing') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Aanavandi()),
      );
    } else if (route == 'Help') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Help()),
      );
    }
  }
}

typedef VoidNavigate = void Function(String route);
