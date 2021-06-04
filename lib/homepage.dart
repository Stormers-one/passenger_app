import 'package:flutter/material.dart';
import 'package:passenger_app/Menu/selection.dart';
import 'package:passenger_app/Wrapper.dart';
import 'package:passenger_app/Shared/services/firebaseServices/auth.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:passenger_app/shared/model/user.dart';
import 'package:passenger_app/shared/services/mapServices/mapState.dart';
import 'package:provider/provider.dart';
import 'shared/Styling/homepageButtons/data.dart';
import 'package:passenger_app/shared/Styling/homepageButtons/button.dart';
import 'package:passenger_app/shared/Styling/homepageButtons/data.dart';
import 'package:passenger_app/shared/services/firebaseServices/database.dart';
import 'package:passenger_app/shared/loading.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);
  State<StatefulWidget> createState() {
    return _HomepageState();
  }
}

class _HomepageState extends State<Homepage> {
  final Authservice _auth = new Authservice();
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    getim();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<User>(context);
    final List<Widget> _children = [Home(), Profile()];
    // final appState = Provider.of<MapState>(context);
    // print('Homepage: ' + appState.initialPosition.toString());
    return ChangeNotifierProvider(
      create: (context) => MapState(),
      builder: (context, child) => MaterialApp(
        home: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            elevation: 0,
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
                  Navigator.pop(
                    context,
                    MaterialPageRoute(builder: (context) => Wrapper()),
                  );
                },
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.school),
              //   label: 'School',
              // ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber.shade800,
            onTap: _onItemTapped,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SizedBox.expand(
                  child: _children[_selectedIndex],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    final buttonHome = Buttons.fetchAll();
    final userID = context.watch<User>();
    return ListView(
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 380,
                      color: Colors.amber,
                      width: MediaQuery.of(context).size.width,
                      child: Selection(),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Button(
                              image: buttonHome[2].image,
                              route: buttonHome[2].route,
                              text: buttonHome[2].text,
                              context: context),
                        ],
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ],
    );
  }
}

class Profile extends StatelessWidget {
  @override
  Widget build(context) {
    final userID = Provider.of<User>(context);

    final buttonHome = Buttons.fetchAll();
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: userID.uid!).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.black,
                        child: ClipOval(
                          child: SizedBox(
                            width: 170,
                            height: 170,
                            child: FadeInImage.assetNetwork(
                              fadeInCurve: Curves.bounceIn,
                              placeholder: 'assets/images/loading.gif',
                              image: downURL,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Form(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                        ),
                        new TextField(
                          enabled: false,
                          decoration: new InputDecoration(
                            labelText: userData.fname,
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            icon: Icon(Icons.account_box),
                            fillColor: Colors.grey.shade300,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                        ),
                        new TextField(
                          enabled: false,
                          decoration: new InputDecoration(
                            labelText: userData.email,
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            icon: Icon(Icons.email),
                            fillColor: Colors.grey[300],
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                        ),
                        new TextField(
                          enabled: false,
                          decoration: new InputDecoration(
                            labelText: userData.phno,
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            icon: Icon(Icons.phone),
                            fillColor: Colors.grey[300],
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Button(
                      image: buttonHome[4].image,
                      text: buttonHome[4].text,
                      route: buttonHome[4].route,
                      context: context,
                    ),
                    Button(
                      image: buttonHome[5].image,
                      text: buttonHome[5].text,
                      route: buttonHome[5].route,
                      context: context,
                    ),
                  ],
                )
              ],
            );
          } else {
            return Loading();
          }
        });
  }
}
