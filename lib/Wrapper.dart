import 'package:flutter/material.dart';
import 'package:passenger_app/Shared/services/firebaseServices/Signing_and_Auth/loginPage.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:passenger_app/homepage.dart';
import 'package:passenger_app/shared/model/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

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
