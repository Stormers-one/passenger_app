import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:passenger_app/shared/Styling/colors.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[300],
      child: Center(
        child: SpinKitFadingFour(
          color: red,
          size: 90.0,
        ),
      ),
    );
  }
}
