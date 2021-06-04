import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:passenger_app/shared/Styling/colors.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SpinKitFadingFour(
          color: red,
          size: 90.0,
        ),
      ),
    );
  }
}

class LoadingSignin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitFadingFour(
          color: red,
          size: 90.0,
        ),
      ),
    );
  }
}
