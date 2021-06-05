import 'package:flutter/material.dart';
import 'package:passenger_app/Menu/landing.dart';
import 'package:passenger_app/User/profile_settings.dart';
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
  final Authservice auth = new Authservice();
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

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text("Exit Diaglog"),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
    final userID = Provider.of<User>(context);
    print('[Homepage] User: ' + userID.uid.toString());
    final List<Widget> _children = [
      Home(),
      Profile(
        auth: auth,
      )
    ];
    // final List<List<Widget>> _appBarChildren = [
    //   [Logout(auth: auth)],
    //   [ProfileSettings()]
    // ];
    // final appState = Provider.of<MapState>(context);
    // print('Homepage: ' + appState.initialPosition.toString());
    return ChangeNotifierProvider(
      create: (context) => MapState(),
      builder: (context, child) => MaterialApp(
        home: WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            backgroundColor: bgColor,
            // appBar: AppBar(
            //   elevation: 0,
            //   backgroundColor: appBarColor,
            //   actions: _appBarChildren[_selectedIndex],
            // ),
            bottomNavigationBar: BottomNavigationBar(
              // backgroundColor: appBarColor,
              backgroundColor: Colors.transparent,

              elevation: 0,
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
              selectedItemColor: raspberryColor,
              unselectedItemColor: lavender,
              selectedFontSize: 15,
              selectedIconTheme: IconThemeData(size: 26),
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
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    final buttonHome = Buttons.fetchAll();
    final userID = context.watch<User>();
    print('[Homepage]->[Home] User: ' + userID.uid.toString());

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 9.0),
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              width: MediaQuery.of(context).size.width,
              //height:
              child: Column(
                children: [
                  Landing(),
                  SizedBox(
                    height: 20,
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
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Profile extends StatelessWidget {
  final auth;
  Profile({this.auth});
  @override
  Widget build(context) {
    final userID = Provider.of<User>(context);

    final buttonHome = Buttons.fetchAll();
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        shrinkWrap: true,
        children: [
          StreamBuilder<UserData>(
              stream: DatabaseService(uid: userID.uid!).userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserData userData = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // SizedBox(
                      //   height: 30,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: ProfileSettings(),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Logout(auth: auth),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Form(
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
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                    icon: Icon(Icons.account_box),
                                    fillColor: Colors.grey.shade300,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                      borderRadius:
                                          new BorderRadius.circular(10),
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
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                    icon: Icon(Icons.email),
                                    fillColor: Colors.grey[300],
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                      borderRadius:
                                          new BorderRadius.circular(10),
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
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                    icon: Icon(Icons.phone),
                                    fillColor: Colors.grey[300],
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                } else {
                  return Loading();
                }
              }),
        ],
      ),
    );
  }
}

class ProfileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _showSettengsPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: SettingsForm(),
          );
        },
      );
    }

    return Container(
      // margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: appBarColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: TextButton.icon(
        onPressed: () => _showSettengsPanel(),
        icon: Icon(
          Icons.settings,
          color: Colors.black,
        ),
        label: Text(
          'Edit',
          style: TextStyle(color: Colors.black),
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}

class Logout extends StatelessWidget {
  final auth;
  Logout({this.auth});
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: appBarColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: TextButton.icon(
        icon: Icon(
          Icons.person,
          color: Colors.black,
        ),
        label: Text(
          'Logout',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        onPressed: () async {
          clickStatLogin = false;
          clickStatRegister = false;
          await auth.signOut();
          // Navigator.pop(context);
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => Wrapper()),
          );
        },
      ),
    );
  }
}
