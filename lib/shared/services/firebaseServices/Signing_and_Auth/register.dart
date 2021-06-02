import 'package:flutter/material.dart';
import 'package:passenger_app/Wrapper.dart';
import 'package:passenger_app/Shared/services/firebaseServices/auth.dart';
import 'package:passenger_app/shared/Styling/buttonStyles.dart';
import 'package:passenger_app/shared/services/firebaseServices/Signing_and_Auth/background_login.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:passenger_app/shared/loading.dart';
import 'package:passenger_app/shared/Styling/colors.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;
  RegisterPage({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final Authservice _auth = new Authservice();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

// text fiel state
  String fname = "";
  String email = "";
  String password = "";
  String cfpassword = "";
  String error = "";
  String phno = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
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
                                  labelStyle: new TextStyle(
                                      color: Colors.redAccent, fontSize: 25.0),
                                )),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(
                                              90.0), //REMOVED CONTAINER BORDER RADIUS
                                          topRight: const Radius.circular(90.0),
                                          bottomLeft:
                                              const Radius.circular(90.0),
                                          bottomRight:
                                              const Radius.circular(90.0)),
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
                                      ]
                                      // color: Colors.orange[300],
                                      ),
                                  padding: const EdgeInsets.all(40.0),
                                  child: new Form(
                                    key: _formkey,
                                    autovalidateMode: AutovalidateMode.always,
                                    child: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        Text(
                                          error,
                                          style: TextStyle(
                                              color: red, fontSize: 14.0),
                                        ),
                                        //FULL NAME INPUT
                                        new Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                        ),
                                        new TextFormField(
                                          initialValue: fname,
                                          style: new TextStyle(
                                              color: Colors.orange),
                                          decoration:
                                              textInputDecoration("Full Name"),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          onChanged: (val) {
                                            setState(() => fname = val);
                                          },
                                          validator: (val) =>
                                              val!.isEmpty && clickStatRegister
                                                  ? 'Enter Full Name'
                                                  : null,
                                        ),
                                        //EMAIL INPUT
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
                                              val!.isEmpty && clickStatRegister
                                                  ? 'Enter a valid Email'
                                                  : null,
                                        ),
                                        // PASSWORD INPUT
                                        new Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                        ),
                                        new TextFormField(
                                          style: new TextStyle(
                                              color: Colors.orange),
                                          decoration: textInputDecoration(
                                              "Password > 8 Characters"),
                                          obscureText: true,
                                          keyboardType: TextInputType.text,
                                          onChanged: (val) {
                                            setState(() => password = val);
                                          },
                                          validator: (val) => val!.length < 8 &&
                                                  clickStatRegister
                                              ? 'Password should consist of\natleast 8 Characters'
                                              : null,
                                        ),

                                        new Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                        ),
                                        new TextFormField(
                                          style: new TextStyle(
                                              color: Colors.orange),
                                          decoration: textInputDecoration(
                                              "Confirm Password"),
                                          obscureText: true,
                                          keyboardType: TextInputType.text,
                                          onChanged: (val) {
                                            setState(() => cfpassword = val);
                                          },
                                          validator: (val) => val != password &&
                                                  clickStatRegister
                                              ? 'Both Password should be same '
                                              : null,
                                        ),
                                        //PHONE NUMBER INPUT
                                        new Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                        ),
                                        new TextFormField(
                                          initialValue: phno,
                                          style: new TextStyle(
                                              color: Colors.orange),
                                          decoration: textInputDecoration(
                                              "Phone Number"),
                                          keyboardType: TextInputType.number,
                                          onChanged: (val) {
                                            setState(() => phno = val);
                                          },
                                          validator: (val) => val!.length !=
                                                      10 &&
                                                  clickStatRegister
                                              ? 'Enter a valid 10 Digit phone number'
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
                                              clickStatRegister = true;
                                              if (_formkey.currentState
                                                  .validate()) {
                                                setState(() => loading = true);
                                                dynamic result = await _auth
                                                    .registerWithEmailAndPassword(
                                                        fname,
                                                        email,
                                                        password,
                                                        phno);
                                                if (result == null) {
                                                  setState(() {
                                                    error =
                                                        'Please enter a valid email and password';
                                                    loading = false;
                                                  });
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Wrapper()),
                                                  );
                                                }
                                              }
                                            },
                                            child: const Text('Register',
                                                style: TextStyle(fontSize: 20)),
                                            style: raisedButtonStyle,
                                          ),
                                        ),
                                        new Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
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
