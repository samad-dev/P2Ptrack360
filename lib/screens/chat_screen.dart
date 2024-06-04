import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hascol_dealer/screens/home.dart';
import 'package:hascol_dealer/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class Chat extends StatefulWidget {
  // final dynamic ticket;
  // Chat(this.ticket);
  @override
  _ChatScreen createState() => _ChatScreen();
}

class _ChatScreen extends State<Chat> {
  late final WebViewController controller;
  WebViewController? _webViewController;
  late String email,pass;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email").toString();
    pass = prefs.getString("pass").toString();
    print(email);
    print(pass);
  }

  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM kk:mm:ss').format(now);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          //replace with our own icon data.
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Chat',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              color: Color(0xff12283D),
              fontSize: 16),
        ),
      ),
      body: WebView(
        initialUrl: 'http://demo.p2ptrack360.com:8088/login',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },
        onProgress: (int i){

        },
        onPageFinished: (String url) {
          // Once the page is finished loading, run the JavaScript
          _webViewController?.evaluateJavascript('''
            console.log("Samad321:");
            var email = document.getElementById("email");
            var password = document.getElementById("password");
            // console.log(email);
            email.value = "$email";
            password.value = "$pass";
            console.log(email);
            document.getElementById('loginForm').submit();
          ''').then((result) {
            print("Email value: $result");

            // Here you can handle the email value retrieved from JavaScript
          });
        },
      ),
    );
  }
}
