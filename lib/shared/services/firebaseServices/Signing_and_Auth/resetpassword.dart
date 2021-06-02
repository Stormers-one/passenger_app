import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passenger_app/Shared/services/firebaseServices/auth.dart';
import 'package:passenger_app/shared/Styling/buttonStyles.dart';
import 'package:passenger_app/shared/services/firebaseServices/Signing_and_Auth/background_login.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:passenger_app/shared/loading.dart';
import 'package:passenger_app/shared/Styling/colors.dart';

class ResetPage extends StatefulWidget {
  final Function toggleView;
  ResetPage({this.toggleView});

  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<ResetPage> {
  final Authservice _auth = new Authservice();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
// text file state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.orange[300],
            body: Stack(children: <Widget>[
              Background(),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Center(
                  child: Container(
                    child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(20.0),
                        children: <Widget>[
                          new Theme(
                            data: new ThemeData(
                                fontFamily: 'Quicksand-Medium',
                                brightness: Brightness.dark,
                                inputDecorationTheme: new InputDecorationTheme(
                                  // hintStyle: new TextStyle(color: Colors.blue, fontSize: 20.0),
                                  labelStyle: new TextStyle(
                                      color: Colors.redAccent, fontSize: 25.0),
                                )),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Hero(
                                  tag: 'imageHero',
                                  child: new Container(
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                    ),
                                    height: 200,
                                    width: 200,
                                  ),
                                ),
                                new Container(
                                  decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      gradient: new LinearGradient(
                                          colors: [
                                            Colors.orange[600],
                                            Colors.red[300]
                                          ],
                                          begin:
                                              const FractionalOffset(0.5, 0.0),
                                          end: const FractionalOffset(0.0, 0.5),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withAlpha(60),
                                            blurRadius: 5,
                                            offset: Offset(0, 8),
                                            spreadRadius: 2)
                                      ]),
                                  padding: const EdgeInsets.all(20.0),
                                  child: new Form(
                                    key: _formkey,
                                    autovalidateMode: AutovalidateMode.always,
                                    child: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        //SizedBox(height: 10),
                                        Text(
                                          error,
                                          style: TextStyle(
                                              color: red, fontSize: 14.0),
                                        ),
                                        new Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                        ),
                                        new TextFormField(
                                          initialValue: email,
                                          style: new TextStyle(
                                              color: Colors.orange),
                                          decoration:
                                              textInputDecoration("Email"),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          onChanged: (val) {
                                            setState(() => email = val);
                                          },
                                          validator: (val) =>
                                              val.isEmpty && clickStatLogin
                                                  ? 'Enter an Email'
                                                  : null,
                                        ),
                                        new Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          width: 200,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              if (_formkey.currentState
                                                  .validate()) {
                                                setState(() => loading = true);
                                                dynamic result = await _auth
                                                    .sendPasswordResetEmail(
                                                        email);
                                                if (result == null) {
                                                  setState(() {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Password Reset Link Sent Successfully');
                                                    loading = false;
                                                  });
                                                }
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text('Reset',
                                                style: TextStyle(fontSize: 20)),
                                            style: raisedButtonStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ]),
          );
  }
}
