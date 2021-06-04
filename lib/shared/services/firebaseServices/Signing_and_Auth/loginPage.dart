import 'package:flutter/material.dart';
import 'package:passenger_app/Shared/services/firebaseServices/Signing_and_Auth/resetpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:passenger_app/Shared/services/firebaseServices/auth.dart';
import 'package:passenger_app/shared/Styling/buttonStyles.dart';
import 'package:passenger_app/shared/services/firebaseServices/Signing_and_Auth/register.dart';
import 'package:passenger_app/shared/services/firebaseServices/Signing_and_Auth/background_login.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:passenger_app/shared/loading.dart';
import 'package:passenger_app/shared/Styling/colors.dart';

class LoginPage extends StatefulWidget {
  // final Function toggleView;
  // LoginPage({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final Authservice _auth = new Authservice();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
// text file state
  String email = "";
  String password = "";
  String error = "";

  User? user;
  void initState() {
    super.initState();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text("Exit Diaglog"),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Text("Do You Really want to Exit?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 5),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : WillPopScope(
            onWillPop: _onBackPressed,
            child: Scaffold(
              backgroundColor: Colors.orange[300],
              body: Stack(children: <Widget>[
                Background(),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: SafeArea(
                    child: Center(
                      child: Container(
                        // decoration: new BoxDecoration(
                        //   color: Colors.orange[300],
                        // ),
                        child: ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20),
                            children: <Widget>[
                              new Theme(
                                data: new ThemeData(
                                    fontFamily: 'Quicksand-Medium',
                                    brightness: Brightness.dark,
                                    inputDecorationTheme:
                                        new InputDecorationTheme(
                                      // hintStyle: new TextStyle(color: Colors.blue, fontSize: 20.0),
                                      labelStyle: new TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 25.0),
                                    )),
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
                                    ),
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
                                                Colors.orange.shade600,
                                                Colors.red.shade300
                                              ],
                                              begin: const FractionalOffset(
                                                  0.5, 0.0),
                                              end: const FractionalOffset(
                                                  0.0, 0.5),
                                              stops: [0.0, 1.0],
                                              tileMode: TileMode.clamp),
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                    Colors.black.withAlpha(60),
                                                blurRadius: 5,
                                                offset: Offset(0, 8),
                                                spreadRadius: 2)
                                          ]),
                                      padding: const EdgeInsets.all(20.0),
                                      child: new Form(
                                        key: _formkey,
                                        autovalidateMode:
                                            AutovalidateMode.always,
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
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
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
                                                  val!.isEmpty && clickStatLogin
                                                      ? 'Enter an Email'
                                                      : null,
                                            ),
                                            new Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                            ),
                                            new TextFormField(
                                              style: new TextStyle(
                                                  color: Colors.orange),
                                              decoration: textInputDecoration(
                                                  "Password"),
                                              obscureText: true,
                                              keyboardType: TextInputType.text,
                                              onChanged: (val) {
                                                setState(() => password = val);
                                              },
                                              validator: (val) =>
                                                  val!.isEmpty && clickStatLogin
                                                      ? 'Enter password'
                                                      : null,
                                            ),
                                            new Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 200,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  if (_formkey.currentState!
                                                      .validate()) {
                                                    setState(
                                                        () => loading = true);

                                                    dynamic result = await _auth
                                                        .signInWithEmailAndPassword(
                                                            email, password);
                                                    if (result == null) {
                                                      setState(() {
                                                        error =
                                                            'Incorrect Email or Password';
                                                        loading = false;
                                                      });
                                                    }
                                                  }
                                                },
                                                child: const Text('Login',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white)),
                                                style: raisedButtonStyle,
                                              ),
                                            ),
                                            new Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ResetPage()));
                                              },
                                              child: Text(
                                                'Forgot Password?',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Don\'t have an account ?',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RegisterPage()));
                                            },
                                            child: Text(
                                              'Register',
                                              style: TextStyle(
                                                  color: Color(0xfff79c4f),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
