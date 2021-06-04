import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passenger_app/Menu/Booking/Ticket.dart';
import 'package:passenger_app/shared/Styling/buttonStyles.dart';
import 'package:passenger_app/shared/Styling/homepageButtons/button.dart';
import 'package:passenger_app/shared/Styling/homepageButtons/data.dart';
import 'package:passenger_app/shared/model/user.dart';
import 'package:passenger_app/Shared/services/firebaseServices/database.dart';
import 'package:passenger_app/shared/constants.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'package:passenger_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BookingConfirm extends StatefulWidget {
  final fare;
  BookingConfirm({required this.fare});
  _BookingConfirm createState() => _BookingConfirm(fare: fare);
}

class _BookingConfirm extends State<BookingConfirm> {
  Razorpay? _razorpay;
  var fare;
  _BookingConfirm({required this.fare});
  bool loading = false;
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSucess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void dispose() {
    super.dispose();
    _razorpay!.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_XJNlckGyObxbKr',
      'amount': fare * 100,
      'name': 'Odu Komban',
      'description': 'Unreserved Ticket Booking',
      'prefill': {'contact': '', 'email': ''},
    };
    try {
      _razorpay!.open(options);
      loading = false;
    } catch (e) {
      print(e);
    }
  }

  void _handlePaymentSucess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS" + response.paymentId!);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TicketDisplay()));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "PAYMENT ERROR" +
            " " +
            response.code.toString() +
            " " +
            response.message!);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final buttonHome = Buttons.fetchAll();

    print(user.uid);
    print(user.uid!);
    return loading
        ? Loading()
        : Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid!).userData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserData userData = snapshot.data!;
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
                                  labelText: userData.fname,
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  icon: Icon(Icons.account_box),
                                  fillColor: Colors.grey[300],
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                              ),
                              new TextField(
                                enabled: false,
                                decoration: new InputDecoration(
                                  labelText: selectedBookingFrom,
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  icon: Icon(Icons.person_pin), //directions_bus
                                  fillColor: Colors.grey[300],
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                              ),
                              new TextField(
                                enabled: false,
                                decoration: new InputDecoration(
                                  labelText: selectedBookingTo,
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  icon: Icon(Icons.pin_drop),
                                  fillColor: Colors.grey[300],
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                              ),
                              new TextField(
                                enabled: false,
                                decoration: new InputDecoration(
                                  labelText: fare.toString(),
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                  icon: Icon(MdiIcons.currencyInr),
                                  fillColor: Colors.grey[300],
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                              ),
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    loading = true;
                                    openCheckout();
                                  },
                                  child: const Text(
                                    'Proceed To Payment',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: raisedButtonStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Loading();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Button(
                          image: buttonHome[1].image,
                          route: buttonHome[1].route,
                          text: buttonHome[1].text,
                          context: context)
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
