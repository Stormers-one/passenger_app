import 'package:flutter/material.dart';
import 'package:passenger_app/Wrapper.dart';
import 'package:passenger_app/Shared/services/firebaseServices/auth.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:passenger_app/shared/drawer.dart';
import 'homepageButtons/data.dart';
import 'homepageButtons/button.dart';

class Homepage extends StatefulWidget {
  // Homepage({Key key}) : super(key: key);
  State<StatefulWidget> createState() {
    return _HomepageState();
  }
}

class _HomepageState extends State<Homepage> {
  final Authservice _auth = new Authservice();
  final buttonHome = Buttons.fetchAll() ?? [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand-Medium'),
      debugShowCheckedModeBanner: false,
      title: 'Homepage',
      home: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          //title: Text('MENU'),
          backgroundColor: appBarColor,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                clickStatLogin = false;
                clickStatRegister = false;
                await _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Wrapper()),
                );
              },
            )
          ],
        ),
        drawer: DrawerBuild(),
        body:
            // DoubleBackToCloseApp(
            //   snackBar: const SnackBar(
            //       content: Text(
            //     'Press Back Again To Exit',
            //     textAlign: TextAlign.center,
            //   )),
            //   child:
            GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 9.0, right: 9.0),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // SizedBox(
                      //   height: 5,
                      // ),
                      Hero(
                        tag: 'imageHero',
                        child: new Container(
                          child: Image.asset(
                            'assets/images/logo.png',
                          ),
                          height: 190,
                          width: 190,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        width: MediaQuery.of(context).size.width,
                        //height:
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            new Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Button(
                                  image: buttonHome[0].image,
                                  text: buttonHome[0].text,
                                  route: buttonHome[0].route,
                                  context: context,
                                ),
                                Button(
                                  image: buttonHome[1].image,
                                  text: buttonHome[1].text,
                                  route: buttonHome[1].route,
                                  context: context,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Button(
                                  image: buttonHome[2].image,
                                  text: buttonHome[2].text,
                                  route: buttonHome[2].route,
                                  context: context,
                                ),
                                Button(
                                  image: buttonHome[3].image,
                                  text: buttonHome[3].text,
                                  route: buttonHome[3].route,
                                  context: context,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
