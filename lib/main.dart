import 'package:flutter/material.dart';
import 'package:passenger_app/Menu/Booking/bookingList.dart';
import 'package:passenger_app/Menu/dashboard.dart';
import 'package:passenger_app/Shared/services/mapServices/mapState.dart';
import 'package:passenger_app/Wrapper.dart';
import 'package:passenger_app/homepage.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:passenger_app/shared/model/user.dart';
import 'package:passenger_app/Shared/services/firebaseServices/auth.dart';
import 'package:passenger_app/shared/routes.dart';
import 'package:passenger_app/shared/services/firebaseServices/Signing_and_Auth/loginPage.dart';
import 'package:provider/provider.dart';
import 'Shared/services/mapServices/mapState.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: MapState(),
          // create: (context) => MapState(),
          // child: Odukomban(),
        ),
        StreamProvider<User>.value(
          initialData: User(),
          value: Authservice().user,
        )
      ],
      child: Odukomban(),
    ),
  );
}

class Odukomban extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final appState = Provider.of<MapState>(context);
    // print('Odukomban: ' + appState.initialPosition.toString());
    final user = Provider.of<User>(context);

    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand-Medium'),
      home: Builder(builder: (context) {
        if (user.uid == null) {
          return LoginPage();
        } else {
          userID = user.uid;
          print("[Wrapper] User is :" + userID.toString());
          return Homepage();
        }
      }),
      routes: <String, WidgetBuilder>{
        HOMEPAGE: (context) => Homepage(),
        // CREDITS: (context) => Credit(),
        WRAPPER: (context) => Wrapper(),
        BOOKINGS: (context) => BookingList(),
        DASHBOARD: (context) => Dashboard(),
        TICKET: (context) => Wrapper(),
      },
    );
  }
}
