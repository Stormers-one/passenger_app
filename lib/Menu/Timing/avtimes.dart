import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:passenger_app/shared/constants.dart';

class Aanavandi extends StatefulWidget {
  @override
  _AanavandiState createState() => _AanavandiState();
}

class _AanavandiState extends State<Aanavandi> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String from = selectedTimingFrom.replaceAll(' ', '-').toLowerCase();
  String to = selectedTimingTo.replaceAll(' ', '-').toLowerCase();
  String time;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'Quicksand-Medium'),
        title: 'Bus Timings',
        home: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text('Bus Timing'),
              backgroundColor: red,
            ),
            drawer: Drawer(),
            body: WebView(
              initialUrl: inUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            )));
  }
}
