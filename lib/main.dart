import 'package:flutter/material.dart';
import 'package:passenger_app/Shared/services/mapServices/mapState.dart';
import 'package:passenger_app/shared/model/user.dart';
import 'package:passenger_app/Shared/services/firebaseServices/auth.dart';
import 'package:passenger_app/shared/spashScreen.dart';
import 'package:provider/provider.dart';
import 'Shared/services/mapServices/mapState.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    // ChangeNotifierProvider<MapState>(
    //   // value: MapState(),
    //   create: (context) => MapState(),
    // ),
    StreamProvider<User>.value(
      initialData: User(),
      value: Authservice().user,
    )
  ], child: Odukomban()));
}

class Odukomban extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final appState = Provider.of<MapState>(context);
    // print('Odukomban: ' + appState.initialPosition.toString());
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand-Medium'),
      home: SplashScreen(),
    );
  }
}
