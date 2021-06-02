import 'package:flutter/material.dart';
import 'package:passenger_app/User/users_fetch.dart';

class UsersTile extends StatelessWidget {
  final Users user;
  UsersTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Card(
          color: Colors.orange[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: Image.asset(
              'assets/profile-icon.png',
            ),
            //  CircleAvatar(
            //    radius: 50.0,
            //    backgroundColor: red,
            //  ),
            title: Text(user.fname),
          ),
        ));
  }
}
