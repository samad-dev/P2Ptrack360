import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  user? _user;
  bool _isLoading = false;


  Future<void> _login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    if (_passwordController.text.toString() != '' &&
        _passwordController.text.toString() != '') {
      print('here');
      var request = http.Request('GET', Uri.parse(
          'http://151.106.17.246:8000/api/login/${email}/${password}'));
      http.StreamedResponse response = await request.send();
      final json = await response.stream.bytesToString();

      Map<String, dynamic> jsons = jsonDecode(json);
      print("Samad" + jsons.length.toString());
      if (jsons.length > 0) {
        if (jsons["role"] == 'Inspector') {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);
          print(jsons['id']);
          prefs.setString("userId", jsons["id"].toString());
          prefs.setString("username", jsons["name"].toString());
          prefs.setString("email", jsons["email"].toString());
          prefs.setString("role", jsons["role"].toString());
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => Home(),
            ),
          );
          // Navigator.pushNamed(context, 'Dashboard');
        }
        else {
          Fluttertoast.showToast(
              msg: "You are not Allowed to Login here",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: "Incorrect Credentials Please Try Again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
    else {
      Fluttertoast.showToast(
          msg: "Please Fill Credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Center(
        child: _isLoading
        ? CircularProgressIndicator() // Show loader if _isLoading is true
        : SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo.jpg',width: MediaQuery.of(context).size.height/3,height: MediaQuery.of(context).size.width*0.4,),
                      Container(
                        child: Text(
                          'Login Here',
                          style: GoogleFonts.poppins(
                            textStyle: Theme
                                .of(context)
                                .textTheme
                                .displayLarge,
                            fontSize: 22,
                            color: Color(0xff1F41BB),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          'Welcome Back You`ve',
                          style: GoogleFonts.poppins(
                            textStyle: Theme
                                .of(context)
                                .textTheme
                                .displayLarge,
                            fontSize: 14,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'been missed!',
                          style: GoogleFonts.poppins(
                            textStyle: Theme
                                .of(context)
                                .textTheme
                                .displayLarge,
                            fontSize: 14,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 38, right: 38),
                        child: TextField(
                          controller: _emailController,
                          style: GoogleFonts.poppins(
                            color: Color(0xffa8a8a8),
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                          ),
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.poppins(
                              color: Color(0xffa8a8a8),
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                            ),
                            labelStyle: GoogleFonts.poppins(
                              color: Color(0xffa8a8a8),
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                            ),
                            filled: true,
                            fillColor: Color(0xffF1F4FF),
                            hintText: 'Enter Email',
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2, color: Color(
                                    0xff1F41BB)),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xffF1F4FF)),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 38, right: 38),
                        child: TextField(
                          controller: _passwordController,
                          style: GoogleFonts.poppins(
                            color: Color(0xffa8a8a8),
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                          ),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.poppins(
                              color: Color(0xffa8a8a8),
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                            ),
                            labelStyle: GoogleFonts.poppins(
                              color: Color(0xffa8a8a8),
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                            ),
                            filled: true,
                            fillColor: Color(0xffF1F4FF),
                            hintText: 'Enter Password',
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2, color: Color(
                                    0xff1F41BB)),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xffF1F4FF)),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 40),
                        child: Text(
                          'Forget Password?',
                          style: GoogleFonts.poppins(
                            textStyle: Theme
                                .of(context)
                                .textTheme
                                .displayLarge,
                            fontSize: 14,
                            color: Color(0xff1F41BB),
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: ElevatedButton(
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
                            primary: Color(0xff1F41BB),

                          ),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true; // Set isLoading to true to show loader
                            });

                            // Perform login action
                            await login();

                            // After login action is completed, set isLoading to false to hide loader
                            setState(() {
                              _isLoading = false;
                            });

                            print('Hello world');
                            // Navigate to the next screen if necessary
                            // Navigator.pushReplacement<void, void>(
                            //   context,
                            //   MaterialPageRoute<void>(builder: (BuildContext context) => Home()),
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 18,
                  ),
                  Container(
                    child: Text(
                      'P2PTrack 360',
                      style: GoogleFonts.poppins(
                        textStyle: Theme
                            .of(context)
                            .textTheme
                            .displayLarge,
                        fontSize: 18,
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ), // Show your other UI elements when _isLoading is false
    ),
    );
  }
  login() async {
    var headers = {'Content-Type': 'application/json'};
    var request =
    http.Request('POST', Uri.parse('http://3.137.76.254/api/login'));
    request.body = json.encode({
      "email": "${_emailController.text.toString()}",
      "password": "${_passwordController.text.toString()}"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var data = await response.stream.bytesToString();
      Map<String,dynamic> data2 = json.decode(data);
      print(data2);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('first_name', data2['first_name']);
      prefs.setString('last_name', data2['last_name']);
      prefs.setString('company_id', data2['company_id']);
      prefs.setString('designation_id', data2['designation_id']);
      prefs.setString('email', data2['email']);
      prefs.setString('pass', _passwordController.text.toString());
      prefs.setString('bu_id', data2['bu_id']);
      prefs.setString('id', data2['id']);
      // print(data2['bu_id']);

      final response2  = await http.get(Uri.parse('http://3.137.76.254/api/users2/${data2['bu_id']}/${data2['designation_id']}'));


      if (response2.statusCode == 200) {
        List<dynamic> jsons = jsonDecode(response2.body);
        // json.decode(response2.body);
        print(jsons[0]['group_id']);
        prefs.setString('title', jsons[0]['title']);
      }
      else {
        print(response2.reasonPhrase);
      }

      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => Home(),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      final snackBar = SnackBar(
        backgroundColor: Colors.redAccent,
        content: const Text(
          'Login Failed Please Try Again',
          style: TextStyle(color: Colors.white),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(response.reasonPhrase);
    }
  }
}