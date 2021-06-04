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
  String? time;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
      initialUrl: inUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
    ));
  }
}
