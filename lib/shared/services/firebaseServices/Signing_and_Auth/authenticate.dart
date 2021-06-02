import 'package:flutter/material.dart';

import 'package:passenger_app/Shared/services/firebaseServices/Signing_and_Auth/loginPage.dart';
import 'package:passenger_app/Shared/services/firebaseServices/Signing_and_Auth/register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginPage();
    } else {
      return RegisterPage();
    }
  }
}
