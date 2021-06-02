import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passenger_app/Menu/Booking/bookings_list.dart';
import 'package:passenger_app/Menu/help.dart';
import 'package:passenger_app/User/profile.dart';
import 'package:passenger_app/shared/loading.dart';
import 'constants.dart';
import 'package:passenger_app/homepage.dart';
import 'package:passenger_app/shared/Styling/colors.dart';

class DrawerBuild extends StatefulWidget {
  _DrawerBuild createState() => _DrawerBuild();
}

class _DrawerBuild extends State<DrawerBuild> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: red,
            ),
            child: Text(
              'Odu Komban',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Quicksand-Bold',
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home',
                style: TextStyle(
                  fontFamily: 'Quicksand-Bold',
                )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homepage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile',
                style: TextStyle(
                  fontFamily: 'Quicksand-Bold',
                )),
            onTap: () async {
              setState(() {
                Loading();
              });
              await getim();
              // setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
              // });
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.ticket),
            title: Text('My Bookings',
                style: TextStyle(
                  fontFamily: 'Quicksand-Bold',
                )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingList()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help',
                style: TextStyle(
                  fontFamily: 'Quicksand-Bold',
                )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Help()),
              );
            },
          ),
        ],
      ),
    );
  }
}
