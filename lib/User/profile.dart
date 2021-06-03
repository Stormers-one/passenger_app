// import 'package:flutter/material.dart';
// import 'package:passenger_app/User/profile_settings.dart';
// import 'package:passenger_app/shared/model/user.dart';
// import 'package:passenger_app/Shared/services/firebaseServices/database.dart';
// import 'package:passenger_app/shared/constants.dart';
// import 'package:passenger_app/shared/drawer.dart';
// import 'package:passenger_app/shared/loading.dart';
// import 'package:provider/provider.dart';
// import 'package:passenger_app/shared/Styling/colors.dart';

// class Profile extends StatefulWidget {
//   _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   @override
//   Widget build(BuildContext context) {
//     void _showSettengsPanel() {
//       showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return Container(
//             padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
//             child: SettingsForm(),
//           );
//         },
//       );
//     }

//     final userID = Provider.of<User>(context);
//     return /*profrefresher? Loading():*/ MaterialApp(
//       title: 'Profile',
//       home: Scaffold(
//         backgroundColor: bgColor,
//         appBar: AppBar(
//             elevation: 0,
//             title: Text('Profile'),
//             backgroundColor: appBarColor,
//             actions: <Widget>[
//               TextButton.icon(
//                 onPressed: () => _showSettengsPanel(),
//                 icon: Icon(
//                   Icons.settings,
//                   color: Colors.white,
//                 ),
//                 label: Text(
//                   'Edit Profile',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               )
//             ]),
//         drawer: DrawerBuild(),
//         body: Builder(
//           builder: (context) {
//             return Container(
//               child: ListView(
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                 children: <Widget>[
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       SizedBox(height: 50),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Align(
//                             alignment: Alignment.center,
//                             child: CircleAvatar(
//                               radius: 90,
//                               backgroundColor: Colors.black,
//                               child: ClipOval(
//                                 child: SizedBox(
//                                   width: 170,
//                                   height: 170,
//                                   child: FadeInImage.assetNetwork(
//                                     fadeInCurve: Curves.bounceIn,
//                                     placeholder: 'assets/images/loading.gif',
//                                     image: downURL,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       StreamBuilder<UserData>(
//                         stream: DatabaseService(uid: userID.uid!).userData,
//                         builder: (context, snapshot) {
//                           if (snapshot.hasData) {
//                             UserData userData = snapshot.data!;
//                             return Form(
//                               child: Container(
//                                 padding: EdgeInsets.all(20.0),
//                                 child: new Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: <Widget>[
//                                     new Padding(
//                                       padding: const EdgeInsets.only(top: 10.0),
//                                     ),
//                                     new TextField(
//                                       enabled: false,
//                                       decoration: new InputDecoration(
//                                         labelText: userData.fname,
//                                         labelStyle: TextStyle(
//                                             fontSize: 15, color: Colors.black),
//                                         icon: Icon(Icons.account_box),
//                                         fillColor: Colors.grey[300],
//                                         filled: true,
//                                         border: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: Colors.transparent),
//                                           borderRadius:
//                                               new BorderRadius.circular(10),
//                                         ),
//                                       ),
//                                     ),
//                                     new Padding(
//                                       padding: const EdgeInsets.only(top: 10.0),
//                                     ),
//                                     new TextField(
//                                       enabled: false,
//                                       decoration: new InputDecoration(
//                                         labelText: userData.email,
//                                         labelStyle: TextStyle(
//                                             fontSize: 15, color: Colors.black),
//                                         icon: Icon(Icons.email),
//                                         fillColor: Colors.grey[300],
//                                         filled: true,
//                                         border: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: Colors.transparent),
//                                           borderRadius:
//                                               new BorderRadius.circular(10),
//                                         ),
//                                       ),
//                                     ),
//                                     new Padding(
//                                       padding: const EdgeInsets.only(top: 10.0),
//                                     ),
//                                     new TextField(
//                                       enabled: false,
//                                       decoration: new InputDecoration(
//                                         labelText: userData.phno,
//                                         labelStyle: TextStyle(
//                                             fontSize: 15, color: Colors.black),
//                                         icon: Icon(Icons.phone),
//                                         fillColor: Colors.grey[300],
//                                         filled: true,
//                                         border: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: Colors.transparent),
//                                           borderRadius:
//                                               new BorderRadius.circular(10),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return Loading();
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
