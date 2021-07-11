import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger_app/Menu/Timing/schedule.dart';
import 'package:passenger_app/shared/model/busStatic.dart';
import 'package:passenger_app/shared/model/busStop.dart';
import 'package:passenger_app/shared/model/stopSchedule.dart';
import 'package:passenger_app/shared/model/ticketmodel.dart';
import 'package:passenger_app/shared/model/user.dart';
import 'package:passenger_app/User/users_fetch.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //////////////////////////////////////////////////////////////////////////////
  ///////////////////          Booking Collection          /////////////////////
  //////////////////////////////////////////////////////////////////////////////
  final CollectionReference userCollecation =
      FirebaseFirestore.instance.collection('Users');

  Future updateUserData(String fname, String email, String phno) async {
    return await userCollecation.doc(uid).set({
      'Full Name': fname,
      'Email': email,
      'Phone Number': phno,
    });
  }

  //user list from snapshot
  List<Users> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Users(
        fname: doc['Full Name'],
        email: doc['Email'],
        phno: doc['Phone Number'],
      );
    }).toList();
  }

  //userdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      fname: snapshot['Full Name'],
      email: snapshot['Email'],
      phno: snapshot['Phone Number'],
    );
  }

  //get user stream
  Stream<List<Users>> get users {
    return userCollecation.snapshots().map(_userListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollecation.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // Get user bookings
  Stream<List<TicketData>> get getUserBookings {
    return userCollecation
        .doc(uid)
        .collection('Bookings')
        .snapshots()
        .map(_bookingList);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///////////////////          Booking Collection          /////////////////////
  //////////////////////////////////////////////////////////////////////////////
  final CollectionReference ticketsCollection =
      FirebaseFirestore.instance.collection('Bookings');
  Future addBooking(String uid, var fare, String bID, String phno, String from,
      String to, String busType) async {
    await ticketsCollection.doc(bID).set({
      'UID': uid,
      'Fare': fare,
      'Booking ID': bID,
      'From': from,
      'To': to,
      'Booking Time': DateTime.now(),
      'Phone Number': phno,
      'Bus Type': busType,
    });
    await userCollecation.doc(uid).collection("Bookings").add({
      'UID': uid,
      'Fare': fare,
      'Booking ID': bID,
      'From': from,
      'To': to,
      'Booking Time': DateTime.now(),
      'Phone Number': phno,
      'Bus Type': busType,
    });
  }

  List<TicketData> _bookingList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TicketData(
        bookid: doc['Booking ID'],
        booktime: doc['Booking Time'].toString(),
        bookfare: doc['Fare'].toString(),
        bookfrom: doc['From'],
        bookto: doc['To'],
        bookphno: doc['Phone Number'],
        bookuid: doc['UID'],
        bookbustype: doc['Bus Type'],
      );
    }).toList();
  }

  Stream<List<TicketData>> get ticketdata {
    return ticketsCollection
        .where('UID', isEqualTo: uid)
        .snapshots()
        .map(_bookingList);
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////          Feedbacks Collection          ////////////////////
  //////////////////////////////////////////////////////////////////////////////

  final CollectionReference feedbacksCollecation =
      FirebaseFirestore.instance.collection('Support Feedback');

  Future appFeedbackSubmit(
      String uid, String text, String time, String route) async {
    print("Test submit feedback");
    return await feedbacksCollecation.doc().set({
      'UID': uid,
      'Feedback': text,
      'Time': DateTime.now(),
    });
  }
}

class MapDatabaseService {
  final String routeName;
  MapDatabaseService({required this.routeName});
  //////////////////////////////////////////////////////////////////////////////
  /////////////          Bus Static Location Collection          ///////////////
  //////////////////////////////////////////////////////////////////////////////

  final CollectionReference busStaticCollection =
      FirebaseFirestore.instance.collection('Bus Static Locations');

  List<BusStatic> _busStaticDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return BusStatic(
          busID: doc['Bus_ID'] ?? "",
          direction: doc['Direction'] ?? "",
          latitude: doc['Latitude'] ?? "",
          location: doc['Location'] ?? "",
          longitude: doc['Longitude'] ?? "",
          routeId: doc['Route_ID'] ?? "",
          count: doc['count'] ?? "");
    }).toList();
  }

  //get user stream
  Stream<List<BusStatic>> get busStaticData {
    return busStaticCollection
        .where('Route_Name', isEqualTo: routeName)
        .snapshots()
        .map(_busStaticDataFromSnapshot);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///////////////////          Schedule Collection          ////////////////////
  //////////////////////////////////////////////////////////////////////////////

  final CollectionReference scheduleCollection =
      FirebaseFirestore.instance.collection('Routes');

  Future<List<StopSchduleDataList>> get scheduleData async {
    List<String> schdDataIDs = [];
    List<StopSchduleDataList> schdData = [];
    await scheduleCollection
        .where('route_name', isEqualTo: routeName)
        .get()
        .then((value) {
      for (var element in value.docs) {
        schdDataIDs.add(element.id);
      }
    });
    for (var docID in schdDataIDs) {
      StopSchduleDataList tmp = new StopSchduleDataList();
      await scheduleCollection
          .doc(docID)
          .collection('stops')
          .get()
          .then((value) {
        for (var element in value.docs) {
          var tmpData = StopSchduleData(
              name: element.data()['name'] ?? "",
              stopNo: element.data()['stopNo'] ?? "",
              time: element.data()['time'] ?? "");
          tmp.addSchedule(tmpData);
        }
      });
      schdData.add(tmp);
    }
    // busStaticCollection.where('route_name', isEqualTo: routeName).get().then(
    //       (value) => value.docs.forEach(
    //         (element) {
    //           busStaticCollection
    //               .doc(element.id)
    //               .collection('Routes')
    //               .snapshots()
    //               .map(_scheduleDataFromSnapshot);
    //         },
    //       ),
    //     );
    // return busStaticCollection
    //     .where('route_name', isEqualTo: routeName)
    //     .snapshots()
    //     .map(_scheduleDataFromSnapshot);
    print(schdData.length);
    print(schdData[14]);
    return schdData;
  }
}

//////////////////////////////////////////////////////////////////////////////
//////////////////          Bus Stops Collection          ////////////////////
//////////////////////////////////////////////////////////////////////////////

class BusListService {
  getBusStopList(String query) {
    return FirebaseFirestore.instance
        .collection("Bus Stops")
        .where("Case Search", arrayContains: query)
        .get();
  }

  List<BusStopData> _busStopListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return BusStopData(
        stopName: doc['Stop Name'],
      );
    }).toList();
  }

  Stream<List<BusStopData>> get busStopData {
    return busStopCollection.snapshots().map(_busStopListFromSnapshot);
  }

  final CollectionReference busStopCollection =
      FirebaseFirestore.instance.collection('Bus Stops');
  Future updateBusStopData(String stopName, List<String> caseSearch) async {
    return await busStopCollection.doc().set(
      {
        'Stop Name': stopName,
        'Case Search': caseSearch,
      },
    );
  }
}
