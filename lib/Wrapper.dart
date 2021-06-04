import 'package:flutter/material.dart';
import 'package:passenger_app/Shared/services/firebaseServices/Signing_and_Auth/loginPage.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:passenger_app/homepage.dart';
import 'package:passenger_app/shared/model/user.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // final appState = Provider.of<MapState>(context);
    // print('Wrapper: ' + appState.initialPosition.toString());
    if (user.uid == null) {
      return LoginPage();
    } else {
      userID = user.uid;
      print("[Wrapper] User is :" + userID.toString());
      return Homepage();
    }
    //return Homepage();
  }
}
