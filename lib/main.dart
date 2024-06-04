import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hascol_dealer/screens/home.dart';
import 'package:hascol_dealer/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sales Bridge',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //checkLoginStatus();
    getValue();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Navigate to the appropriate screen based on the login status
    if(isLoggedIn)
    {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Home(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(children: [
                  Positioned(
                      top: 0,
                      right: -100,
                      child: Image.asset('assets/images/circle.png')),
                  Positioned(
                    child: SvgPicture.asset(
                      'assets/images/welcome image.svg',
                      width: MediaQuery.of(context).size.width / 1.1,
                    ),
                  ),
                ]),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 14,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    'Get Your Work',
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 28,
                      color: Color(0xff1F41BB),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'On Your FingerTips',
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 28,
                      color: Color(0xff1F41BB),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 18,
            ),
            /*
            Image.asset(
              'assets/images/hascol_logo.png',
              width: 200,
            ),
             */
            Container(
              child: Text(
                'P2PTrack360',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 24,
                  color: Color(0xff1F41BB),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),

            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 80, right: 80,top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff12283D),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              Login(),
                        ),
                      );
                    },
                  ),
                  /*TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Color(0xff0A0A0A)),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Register',
                      style: GoogleFonts.poppins(
                        color: Color(0xff0A0A0A),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  )*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  void getValue() async {
    var prefs = await SharedPreferences.getInstance();
    var getName = (prefs.getString("first_name") ?? "");
    // nameValue = getName != null ? getName : "No Value Saved ";
    if (getName == "") {
      Timer(Duration(seconds: 5), () {

        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                Login(),
          ),
        );
      });
    } else {
      Timer(Duration(seconds: 0), () {

        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                Home(),
          ),
        );
      });

    }
    setState(() {

    });
  }
}
