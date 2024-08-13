import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hascol_dealer/screens/create_order.dart';
import 'package:hascol_dealer/screens/home.dart';
import 'package:hascol_dealer/screens/profile.dart';
import 'package:hascol_dealer/screens/ticket_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Orders extends StatefulWidget {
  static const Color contentColorOrange = Color(0xFF00705B);
  final Color leftBarColor = Color(0xFFCB6600);
  final Color rightBarColor = Color(0xFF5BECD2);
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<dynamic> allTickets = [];
  List<dynamic> filteredTickets = [];
  List<String> statusOptions = [];
  List<String> impactOptions = [];
  List<String> priorityOptions = [];
  List<String> buOptions = [];
  List<String> reportedByOptions = [];

  String? selectedStatus;
  String? selectedImpact;
  String? selectedPriority;
  String? selectedBU;
  String? selectedReportedBy;

  List<String> _getDistinctValues(List<dynamic> data, String key) {
    return data.map((e) => e[key]).toSet().toList().cast<String>();
  }
  @override
  void initState() {
    super.initState();
    getData().then((data) {
      setState(() {
        allTickets = data;
        filteredTickets = data;
        statusOptions = _getDistinctValues(data, 'status_title');
        impactOptions = _getDistinctValues(data, 'impact_title');
        priorityOptions = _getDistinctValues(data, 'priority_title');
        buOptions = _getDistinctValues(data, 'bu_name');
        reportedByOptions = _getDistinctValues(data, 'reported_by_name');
      });
    });

  }

  void filterTicketsbyq(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredTickets = allTickets;
      });
    } else {
      setState(() {
        filteredTickets = allTickets.where((ticket) {
          return ticket['title'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }
  Future<List<dynamic>> getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String company_id = prefs.getString("company_id") ?? "";
      String bu_id = prefs.getString("bu_id") ?? "";
      String id = prefs.getString("id") ?? "";

      var request = http.Request(
          'GET',
          Uri.parse(
              'http://3.137.76.254/api/dashboard/index/$company_id/Manager/$bu_id/$id'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(await response.stream.bytesToString());

        return data;
      } else {
        print('Failed to fetch data: ${response.reasonPhrase}');
        // You can throw an exception here or return an empty list based on your requirement
        throw Exception('Failed to fetch data: ${response.reasonPhrase}');
        // return []; // Return an empty list if you don't want to throw an exception
      }
    } catch (e) {
      print('Error: $e');
      // You can throw an exception here or return an empty list based on your requirement
      throw Exception('Error: $e');
      // return []; // Return an empty list if you don't want to throw an exception
    }
  }

  void filterTickets() {
    setState(() {
      filteredTickets = allTickets.where((ticket) {
        final statusMatch = selectedStatus == null || ticket['status_title'] == selectedStatus;
        final impactMatch = selectedImpact == null || ticket['impact_title'] == selectedImpact;
        final priorityMatch = selectedPriority == null || ticket['priority_title'] == selectedPriority;
        final buMatch = selectedBU == null || ticket['bu_name'] == selectedBU;
        final reportedByMatch = selectedReportedBy == null || ticket['reported_by_name'] == selectedReportedBy;

        return statusMatch && impactMatch && priorityMatch && buMatch && reportedByMatch;
      }).toList();
    });
  }



  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM kk:mm:ss').format(now);
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 1,

          title: Text(
            'Tickets',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                color: Color(0xff12283D),
                fontSize: 16),
          ),
          actions: [
            IconButton(
              icon: Icon(FluentIcons.filter_dismiss_16_filled,color: Color(0xff12283D),),
              onPressed: () {
                setState(() {
                  selectedStatus = null;
                  selectedImpact = null;
                  selectedPriority = null;
                  selectedBU = null;
                  selectedReportedBy = null;
                  filterTickets();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Create_Order()),
                  );
                },
                icon: Icon(
                  // <-- Icon
                  Icons.add,
                  size: 24.0,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff3B8D5A), // Background color
                ),
                label: Text(
                  'Create Tickets',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ), // <-- Text
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(18),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          hint: Text('Select Status'),
                          value: selectedStatus,
                          items: statusOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value;
                              filterTickets();
                            });
                          },
                        ),
                        DropdownButton<String>(
                          hint: Text('Select Impact'),
                          value: selectedImpact,
                          items: impactOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedImpact = value;
                              filterTickets();
                            });
                          },
                        ),
                        DropdownButton<String>(
                          hint: Text('Select Priority'),
                          value: selectedPriority,
                          items: priorityOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPriority = value;
                              filterTickets();
                            });
                          },
                        ),
                        DropdownButton<String>(
                          hint: Text('Select Business Unit'),
                          value: selectedBU,

                          items: buOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBU = value;
                              filterTickets();
                            });
                          },
                        ),
                        DropdownButton<String>(
                          hint: Text('Reported By'),
                          value: selectedReportedBy,
                          items: reportedByOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedReportedBy = value;
                              filterTickets();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    elevation: 5,
                    child: TextField(
                      onChanged: (query) {
                        filterTicketsbyq(query);
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(FluentIcons.search_12_regular,
                              color: Color(0xff8d8d8d)),
                          hintText: 'Search Tickets',
                          hintStyle: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              color: Color(0xff12283D),
                              fontSize: 16),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: getData(),
                    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error fetching data'),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: filteredTickets.length,
                          itemBuilder: (BuildContext context, int index) {
                            var Ticket = filteredTickets[index];
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Tickets(Ticket)),
                                );
                              },
                              child: Card(
                                elevation: 10,
                                color: Color(0xffF0F0F0),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Ticket #: 00${Ticket['company_id']}-00${Ticket['business_unit_id']}-${Ticket['id']}',
                                                    style: GoogleFonts.montserrat(
                                                        fontWeight: FontWeight.w600,
                                                        fontStyle: FontStyle.normal,
                                                        color: Color(0xff12283D),
                                                        fontSize: 16),
                                                  ),
                                                  Card(
                                                    color: Color(0xffFFF3D4),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Text(
                                                        Ticket['status_title'],
                                                        style: GoogleFonts.poppins(
                                                            fontWeight: FontWeight.w500,
                                                            fontStyle: FontStyle.normal,
                                                            color: Color(0xffE7AD18),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    Ticket['title'],
                                                    style: GoogleFonts.montserrat(
                                                        fontWeight: FontWeight.w200,
                                                        fontStyle: FontStyle.normal,
                                                        color: Color(0xff737373),
                                                        fontSize: 18),
                                                  ),
                                                  Text(
                                                    'Due Date: ${Ticket['due_date']}',
                                                    style: GoogleFonts.montserrat(
                                                        fontWeight: FontWeight.w300,
                                                        fontStyle: FontStyle.normal,
                                                        color: Color(0xff9b9b9b),
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                'Reported By: ${Ticket['reported_by_name']}',
                                                style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FontStyle.normal,
                                                    color: Color(0xff3B8D5A),
                                                    fontSize: 12),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 4),
                                                child: Divider(),
                                              ),
                                              Text(
                                                Ticket['created_at'],
                                                style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    color: Color(0xff9b9b9b),
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text('No data available'),
                        );
                      }
                    },
                  ),
                ],
              ),
        )),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(0x8ca9a9a9),
                blurRadius: 20,
              ),
            ],
          ),
          child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              unselectedItemColor: Color(0xff8d8d8d),
              unselectedLabelStyle:
                  const TextStyle(color: Color(0xff8d8d8d), fontSize: 14),
              unselectedFontSize: 14,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              selectedIconTheme: IconThemeData(
                color: Color(0xff12283D),
              ),
              type: BottomNavigationBarType.shifting,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      FluentIcons.home_32_regular,
                      size: 20,
                    ),
                    label: 'Home',
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(
                      FluentIcons.ticket_horizontal_24_regular,
                      size: 20,
                    ),
                    label: 'Tickets',
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                  icon: Icon(
                    FluentIcons.inprivate_account_16_regular,
                    size: 20,
                  ),
                  label: 'Profile',
                  backgroundColor: Colors.white,
                ),
              ],
              selectedItemColor: Color(0xff12283D),
              iconSize: 40,
              onTap: _onItemTapped,
              elevation: 15),
        ),
      );
    });
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // if (_selectedIndex == 1) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => Orders()),
    //   );
    // }
    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
    if (_selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );
    }
  }
}

