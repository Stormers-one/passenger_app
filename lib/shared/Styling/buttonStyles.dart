import 'package:flutter/material.dart';
import 'package:passenger_app/shared/Styling/colors.dart';

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.grey,
  primary: red,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
    side: BorderSide(color: Colors.transparent),
  ),
);
