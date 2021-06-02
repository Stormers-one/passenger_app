import 'package:flutter/material.dart';
import 'package:passenger_app/shared/drawer.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search',
      theme: ThemeData(fontFamily: 'Quicksand-Medium'),
      home: Scaffold(
        drawer: DrawerBuild(),
        backgroundColor: Colors.orange[100],
        appBar: AppBar(
          elevation: 0,
          title: Text('Search'),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                constraints: BoxConstraints.expand(
                  height:
                      Theme.of(context).textTheme.headline4!.fontSize! * 1.1 +
                          200.0,
                ),
                padding: const EdgeInsets.all(8.0),
                color: Colors.blue[600],
                alignment: Alignment.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
