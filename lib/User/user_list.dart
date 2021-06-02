import 'package:flutter/material.dart';
import 'package:passenger_app/User/Users_tile.dart';
import 'package:passenger_app/User/users_fetch.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<Users>>(context);
    //users.forEach((user) {
    //  print(user.fname);
    //  print(user.email);
    //  print(user.phno);
    //});
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UsersTile(user: users[index]);
      },
    );
  }
}
