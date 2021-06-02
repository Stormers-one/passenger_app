import 'package:flutter/material.dart';
import 'package:passenger_app/shared/drawer.dart';
import 'package:passenger_app/shared/Styling/colors.dart';

// class Buses {
//   final String time;
//   final String route;
//   Buses({this.time, this.route});
// }

class Times extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand-Medium'),
      debugShowCheckedModeBanner: false,
      title: 'Timings',
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Timings'),
          backgroundColor: red,
        ),
        drawer: DrawerBuild(),
        body: BodyLayout(),
      ),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

// replace this function with the code in the examples
Widget _myListView(BuildContext context) {
  final List<String> busList = [
    'Pullikkanam - Kottayam (via Vagamon - Erattupetta)',
    'Chovoor - Alappuzha (via Pala - Changanassery)',
    'Erattupetta - Kottayam (via Pala)',
    'Poonjar - Kottayam (via Erattupetta - Pala',
    'Monkompu - Kottayam (via Erattupetta - Pala)',
    'Mundakkayam - Kottayam (via Chennad - Pala)',
    'Poonjar - Kottayam (via Erattupetta - Pala)',
    'Kalathwa - Kottayam (via Erattupetta - Pala)',
    'Mundakkayam - Kottayam (via Poonjar - Pala)',
    'Poonjar - Kottayam (via Erattupetta - Pala)',
  ];
  final List<String> time = [
    '8:15 am',
    '8:30am',
    '8:50 am',
    '9:00 am',
    '9:15 am',
    '9:15 am',
    '9:25 am',
    '9:45 am',
    '11:00 am',
    '11:25 am',
  ];
  return ListView.builder(
      itemCount: busList.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.all(6),
          child: ListTile(
            title: Text(busList[index]),
            subtitle: Text(time[index]),
          ),
        );
      });
}

//   @override
//   Widget build(BuildContext context) {
//     // void _showSettengsPanel() {
//     //   showModalBottomSheet(
//     //       context: context,
//     //       builder: (context) {
//     //         return Container(
//     //           padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
//     //         );
//     //       });
//     // }
//     return
//     <List<String>>.busList(
//       value: buses,
//       child: MaterialApp(
//         title: 'Homepage',
//         home: Scaffold(
//           backgroundColor: Colors.orange[100],
//           appBar: AppBar(
//               title: Text('Users List'),
//               backgroundColor: red,
//   ),
//           drawer: DrawerBuild(),
//           body: BusList(),
//         ),
//       ),
//     );
//   }
// }
// class BusList extends StatefulWidget {
//   @override
//   _BusListState createState() => _BusListState();
// }
// class _BusListState extends State<BusList> {
//   @override
//   Widget build(BuildContext context) {
//     final buses = Provider.of<List<Buses>>(context) ?? [];
//     return ListView.builder(
//       itemCount: busList.length,
//       itemBuilder: (context, index) {
//         return BusesTile(bus: buses[index]);
//       },
//     );
//   }
// }
// class BusesTile extends StatelessWidget {
//   final Buses bus;
//   BusesTile({this.bus});
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.only(top: 10.0),
//         child: Card(
//           color: Colors.orange[200],
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15.0),
//           ),
//           margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
//           child: ListTile(
//             leading: Text(bus.time),
//             title: Text(bus.route),
//           ),
//         ));
//   }
// }
