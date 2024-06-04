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

class Tickets extends StatefulWidget {
  final dynamic ticket;
  Tickets(this.ticket);
  @override
  _TicketsView createState() => _TicketsView();
}

class _TicketsView extends State<Tickets> {

  @override
  void initState() {
    super.initState();
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
          'Ticket Details',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              color: Color(0xff12283D),
              fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    side: new BorderSide(color: Color(0xff12283D), width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ticket #: 00${widget.ticket['company_id']}-00${widget.ticket['business_unit_id']}-${widget.ticket['id']}',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff12283D),
                                      fontSize: 16),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  widget.ticket['title'],
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w200,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff737373),
                                      fontSize: 18),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  'Due Date: ${widget.ticket['due_date']}',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff9b9b9b),
                                      fontSize: 12),
                                ),
                                SizedBox(height: 5,),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Click here to View Files',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff086cb9),
                                      fontSize: 12),
                                ),
                                Text(
                                  'Ticket Status: ${widget.ticket['status_title']}',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff9b9b9b),
                                      fontSize: 12),
                                ),

                              ],
                            ),


                          ],
                        ),
                        SizedBox(height: 10,),
                        Divider(height: 1,color: Color(0xff12283D),),
                        SizedBox(height: 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reported By: ${widget.ticket['reported_by_name']}',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff12283D),
                                      fontSize: 16),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  'Business Unit: ${widget.ticket['bu_name']}',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff12283D),
                                      fontSize: 10),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Impact: ${widget.ticket['impact_title']}',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff9b9b9b),
                                      fontSize: 12),
                                ),
                                Text(
                                  'Priority: ${widget.ticket['priority_title']}',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff9b9b9b),
                                      fontSize: 12),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text(
                    'Details',
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        color: Color(0xff12283D),
                        fontSize: 26),
                  ),

                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/1.1, // Adjust the width according to your UI design
                    child: Text(
                      widget.ticket['description'],
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: Color(0xff12283D),
                        fontSize: 14,
                      ),
                    ),
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
