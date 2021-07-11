import 'package:flutter/material.dart';
import 'package:passenger_app/shared/model/ticketmodel.dart';
import 'package:passenger_app/shared/model/user.dart';
import 'package:passenger_app/Shared/services/firebaseServices/database.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:passenger_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookedTicket extends StatelessWidget {
  final TicketData book;
  BookedTicket({required this.book});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
          elevation: 0,
          title: Text('Your Ticket'),
          backgroundColor: red,
          actions: <Widget>[]),
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder<UserData>(
                      stream: DatabaseService(uid: user.uid!).userData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          UserData userData = snapshot.data!;
                          username = userData.fname;
                          useremail = userData.email;
                          userphno = userData.phno;
                          userID = userData.uid;
                          return Form(
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
                                      labelText: book.bookid,
                                      labelStyle: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      icon: Icon(Icons.vpn_key),
                                      fillColor: Colors.grey[300],
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
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
                                      labelText: userData.fname,
                                      labelStyle: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      icon: Icon(Icons.account_box),
                                      fillColor: Colors.grey[300],
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
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
                                      labelText: book.bookfrom,
                                      labelStyle: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      icon: Icon(Icons.play_circle_outline),
                                      fillColor: Colors.grey[300],
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
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
                                      labelText: book.bookto,
                                      labelStyle: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      icon: Icon(Icons.stop),
                                      fillColor: Colors.grey[300],
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
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
                                      labelText: book.bookfare,
                                      labelStyle: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      icon: Icon(Icons.stop),
                                      fillColor: Colors.grey[300],
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
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
                                      labelText: book.bookbustype,
                                      labelStyle: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      icon: Icon(Icons.stop),
                                      fillColor: Colors.grey[300],
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  QrImage(
                                    data: qrDataProvider(
                                        qrdata,
                                        book.bookid.toString(),
                                        qrdata['Name'],
                                        qrdata['Email'],
                                        book.bookphno.toString(),
                                        userData.uid ?? ""),
                                    // data: qrdata.toString(),
                                    version: QrVersions.auto,
                                    size: 200.0,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Loading();
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String qrDataProvider(Map<String, dynamic> qrdata, String bid, String name,
      String email, String phone, String uid) {
    String from, to, fare;
    from = book.bookfrom.toString();
    to = book.bookto.toString();
    fare = book.bookfare.toString();
    String data =
        "{ \"from\" : \"$from\" , \"to\" : \"$to\" , \"bookID\" : \"$bid\" , \"name\" : \"$name\" , \"email\" : \"$email\" , \"phno\" : \"$phone\" , \"fare\" : \"$fare\" , \"uid\" : \"$uid\"}";
    print(data);
    return data;
  }
}
