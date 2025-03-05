import 'package:fl_chart/fl_chart.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hascol_dealer/screens/complaint.dart';
import 'package:hascol_dealer/screens/home.dart';
import 'package:hascol_dealer/screens/login.dart';
import 'package:hascol_dealer/screens/order_list.dart';
import 'package:hascol_dealer/screens/profile.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'chat_screen.dart';
import 'create_order.dart';
import 'home.dart';

class Home extends StatefulWidget {
  static const Color contentColorOrange = Color(0xFF00705B);
  final Color leftBarColor = Color(0xFFCB6600);
  final Color rightBarColor = Color(0xFF5BECD2);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  final List<chartdata> ChartData = [
    chartdata("Jan", 07),

  ];
  late List<chartdata> ChartData2 = [];
  final List<chartdata> ChartData3 = [];
  final List<chartdata> ChartData4 = [];
  final double width = 7;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  int _selectedIndex = 0;
  int touchedGroupIndex = -1;
  late List open = [];
  late List closed =[];
  late List pending = [];
  late List total = [];
  String fname ='';
  String lname ='';
  String newname ='';



  @override
  void initState() {
    super.initState();
    getData();
    get_detail();

    final barGroup1 = makeGroupData(1, 5, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);
    final barGroup5 = makeGroupData(4, 17, 6);
    final barGroup6 = makeGroupData(5, 19, 1.5);
    final barGroup8 = makeGroupData(7, 24, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
      barGroup8
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
    // getValue();
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '5K';
    } else if (value == 19) {
      text = '10K';
    } else if (value == 25) {
      text = '15K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug'
    ];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String company_id = prefs.getString("company_id").toString();
    String bu_id = prefs.getString("bu_id").toString();
    String id = prefs.getString("id").toString();


    var request = http.Request('GET', Uri.parse('http://3.137.76.254:8080/Service-Manager-main-Work/public/api/dashboard/index/$company_id/Manager/$bu_id/$id'));
    print('http://3.137.76.254:8080/Service-Manager-main-Work/public/api/dashboard/index/$company_id/Manager/$bu_id/$id');
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var json = await response.stream.bytesToString();
      List<dynamic> jsons = jsonDecode(json);
      print("Samad" + jsons.length.toString());
      setState(() {
        open = jsons.where((person) => person['status_title'] == 'Open').toList();
        closed = jsons.where((person) => person['status_title'] == 'Close').toList();
        pending = jsons.where((person) => person['status_title'] == 'Pending').toList();
        total = jsons;
        get_ChartData2(json,'status_title',ChartData2);
        get_ChartData2(json,'priority_title',ChartData3);
        get_ChartData2(json,'impact_title',ChartData4);
      });

      print('${open.length}+${closed.length}+${pending.length}=${jsons.length}');
    } else {
      print(response.reasonPhrase);
    }
  }
  get_detail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fname  = prefs.getString('first_name').toString();
    lname  = prefs.getString('last_name').toString();
    String firstInitial = fname.isNotEmpty ? fname.substring(0, 1) : '';
    String lastInitial = lname.isNotEmpty ? lname.substring(0, 1) : '';
    newname = '$firstInitial$lastInitial';
  }
  get_ChartData2(json, String title, List<chartdata> chartData) async {
    List<dynamic> parsedJson = jsonDecode(json);
    Map<String, int> statusOccurrences = {};
    parsedJson.forEach((item) {
      String statusTitle = item[title];
      statusOccurrences[statusTitle] = (statusOccurrences[statusTitle] ?? 0) + 1;
    });
    // Populate chartData2 list
    statusOccurrences.forEach((title, occurrence) {
      setState(() {
        chartData.add(chartdata(title, occurrence));
      });
      print(chartData);
    });
  }
  Future<void> selectCustomDate(BuildContext context,DateController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateController.text) {
      setState(() {
        DateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM kk:mm:ss').format(now);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 48.0, left: 5, right: 5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xff12283D),
                          radius: 30,
                          child: Text(
                            '$newname',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ), //Text
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome,',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Color(0xff8A8A8A),
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                '$fname $lname',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: (){
                              String? selectedDate = 'Date Range';
                              String selectedAssignee = '';
                              bool showCustomDateTextField = false;
                              TextEditingController DateController = TextEditingController();

                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext bc) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return Container(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            DropdownButtonFormField<String>(
                                              value: selectedDate,
                                              style: TextStyle(fontSize: 16.0, color: Colors.black),
                                              icon: Icon(Icons.arrow_drop_down),
                                              iconSize: 30.0,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder( // Customize the border
                                                  borderSide: BorderSide(color: Colors.grey), // Set border color
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                                focusedBorder: OutlineInputBorder( // Customize focused border
                                                  borderSide: BorderSide(color: Colors.grey), // Set border color
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                                hintText: 'Date Range', // Add hint text
                                              ),
                                              items: <String>[
                                                'Date Range',
                                                'Today',
                                                'Yesterday',
                                                'Last two days',
                                                'Last week',
                                                'Last month',
                                                'Custom date'
                                              ].map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedDate = newValue;
                                                  if (newValue == 'Custom date') {
                                                    showCustomDateTextField = true;
                                                  } else {
                                                    showCustomDateTextField = false;
                                                  }
                                                });
                                              },
                                              isExpanded: true,
                                            ),
                                            SizedBox(height: 5,),
                                            if (showCustomDateTextField)
                                              GestureDetector(
                                                onTap: () => selectCustomDate(context, DateController),
                                                child: AbsorbPointer(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey, // Set the color of the border
                                                        width: 1.0, // Set the width of the border
                                                      ),
                                                      borderRadius: BorderRadius.circular(8.0), // Set the border radius to achieve squared corners
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add padding to the TextFormField
                                                      child: TextFormField(
                                                        controller: DateController,
                                                        decoration: InputDecoration(
                                                          labelText: 'Ticket Resolved Date',
                                                          border: InputBorder.none, // Remove the default border of TextFormField
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            SizedBox(height: 20.0),
                                            Text(
                                              'Assignee:',
                                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                            ),
                                            ListTile(
                                              title: Text('Assign to me'),
                                              onTap: () {
                                                setState(() {
                                                  selectedAssignee = 'Assign to me';
                                                });
                                              },
                                              selected: selectedAssignee == 'Assign to me',
                                              selectedTileColor: Colors.grey[200],
                                            ),
                                            ListTile(
                                              title: Text('Created by me'),
                                              onTap: () {
                                                setState(() {
                                                  selectedAssignee = 'Created by me';
                                                });
                                              },
                                              selected: selectedAssignee == 'Created by me',
                                              selectedTileColor: Colors.grey[200],
                                            ),
                                            ListTile(
                                              title: Text('Both'),
                                              onTap: () {
                                                setState(() {
                                                  selectedAssignee = 'Both';
                                                });
                                              },
                                              selected: selectedAssignee == 'Both',
                                              selectedTileColor: Colors.grey[200],
                                            ),
                                            SizedBox(height: 20.0),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Apply Filters'),
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(Color(0xff12283D))
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              FluentIcons.filter_28_filled,
                              color: Colors.black54,
                              size: 35,
                            )
                        ),
                        IconButton(
                            // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                            icon: Icon(
                              Icons.add_box_rounded,
                              color: Color(0xff12283D),
                              size: 35,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Create_Order()),
                              );
                              print("Pressed");
                            }),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(
                            color: Color(0xffEBEBEB),
                          ),
                        ),
                        color: Color(0xff12283D),
                        child: SizedBox(
                          width: 165,
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${total.length}',
                                          style: GoogleFonts.workSans(
                                            color: Color(0xffffffff),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 26,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        Text(
                                          'Total Tickets',
                                          style: GoogleFonts.workSans(
                                            color: Color(0xffc7c7c7),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Card(
                                      color: Color(0xffF0F0FA),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Icon(
                                          FluentIcons
                                              .ticket_diagonal_28_regular,
                                          color: Color(0xff586776),
                                        ),
                                      ),
                                    ),
                                  ],
                                ), //Text
                                const SizedBox(
                                  height: 5,
                                ),

                                //SizedBox
                                //T //SizedBox
                                //SizedBox
                              ],
                            ), //Column
                          ), //Padding
                        ), //SizedBox,
                      ),
                    ),
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(
                            color: Color(0xffEBEBEB),
                          ),
                        ),
                        color: Color(0xffffffff),
                        child: SizedBox(
                          width: 165,
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${closed.length}',
                                          style: GoogleFonts.workSans(
                                            color: Color(0xff106db6),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 26,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        Text(
                                          'Completed Tickets',
                                          style: GoogleFonts.workSans(
                                            color: Color(0xff12283D),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Card(
                                      color: Color(0xffF0F0FA),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Icon(
                                          FluentIcons
                                              .ticket_diagonal_28_regular,
                                          color: Color(0xff586776),
                                        ),
                                      ),
                                    ),
                                  ],
                                ), //Text
                                const SizedBox(
                                  height: 5,
                                ),

                                //SizedBox
                                //T //SizedBox
                                //SizedBox
                              ],
                            ), //Column
                          ), //Padding
                        ), //SizedBox,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(
                            color: Color(0xffEBEBEB),
                          ),
                        ),
                        color: Color(0xffffffff),
                        child: SizedBox(
                          width: 165,
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${pending.length}',
                                          style: GoogleFonts.workSans(
                                            color: Color(0xff106db6),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 26,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        Text(
                                          'Pending Tickets',
                                          style: GoogleFonts.workSans(
                                            color: Color(0xff12283D),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Card(
                                      color: Color(0xffF0F0FA),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Icon(
                                          FluentIcons
                                              .ticket_diagonal_28_regular,
                                          color: Color(0xff586776),
                                        ),
                                      ),
                                    ),
                                  ],
                                ), //Text
                                const SizedBox(
                                  height: 5,
                                ),

                                //SizedBox
                                //T //SizedBox
                                //SizedBox
                              ],
                            ), //Column
                          ), //Padding
                        ), //SizedBox,
                      ),
                    ),
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(
                            color: Color(0xffEBEBEB),
                          ),
                        ),
                        color: Color(0xff12283D),
                        child: SizedBox(
                          width: 165,
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${open.length}',
                                          style: GoogleFonts.workSans(
                                            color: Color(0xffffffff),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 26,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        Text(
                                          'In Progress Tickets',
                                          style: GoogleFonts.workSans(
                                            color: Color(0xffc7c7c7),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Card(
                                      color: Color(0xffF0F0FA),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Icon(
                                          FluentIcons
                                              .ticket_diagonal_28_regular,
                                          color: Color(0xff586776),
                                        ),
                                      ),
                                    ),
                                  ],
                                ), //Text
                                const SizedBox(
                                  height: 5,
                                ),

                                //SizedBox
                                //T //SizedBox
                                //SizedBox
                              ],
                            ), //Column
                          ), //Padding
                        ), //SizedBox,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 20,
                  color: Color(0xffffffff),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Ticket History",
                            style: GoogleFonts.outfit(
                                color: Color(0xff12283D),
                                fontSize: 24,
                                fontWeight: FontWeight.w300)),
                      ),
                      Container(
                        child: SfCartesianChart(
                          plotAreaBorderWidth: 0, // Remove plot area border
                          plotAreaBorderColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          primaryYAxis: NumericAxis(
                              labelStyle: TextStyle(
                                color: Color(0xff12283D),
                              ),
                              majorGridLines: MajorGridLines(width: 1),
                              minorGridLines: MinorGridLines(width: 0),
                              majorTickLines: MajorTickLines(width: 0)),
                          primaryXAxis: CategoryAxis(
                              labelStyle: TextStyle(
                                color: Color(0xff12283D),
                              ),
                              labelPlacement: LabelPlacement.onTicks,
                              majorGridLines: MajorGridLines(width: 0),
                              majorTickLines: MajorTickLines(width: 0),
                              minorTickLines: MinorTickLines(width: 0)),

                          legend: Legend(
                            // Enable the legend
                            textStyle: TextStyle(color:Color(0xff12283D),),
                            position: LegendPosition.top,
                            isVisible: true,
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries>[
                            ColumnSeries<chartdata, String>(

                              dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  color: Colors.white,
                                  textStyle: GoogleFonts.workSans(
                                      color: Color(0xff12283D),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500)),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              dataSource: ChartData,
                              xValueMapper: (chartdata ch, _) => ch.x,
                              yValueMapper: (chartdata ch, _) => ch.y1,
                              xAxisName: 'Month Name',
                              name: 'Tickets', // Legend label
                              color: Color(0xff12283D), // Change the color of the bars
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("Tickets By Status",
                          style: GoogleFonts.workSans(
                              color: Color(0xff106db6),
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                    ),
                    Container(
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0, // Remove plot area border
                        plotAreaBorderColor: Colors.transparent,
                        borderColor: Colors.transparent,
                        primaryYAxis: NumericAxis(
                            labelStyle: TextStyle(
                              color: Color(0xff6C757D),
                            ),
                            majorTickLines: MajorTickLines(width: 0)),
                        primaryXAxis: CategoryAxis(
                            labelStyle: TextStyle(
                              color: Color(0xff6C757D),
                            ),
                            labelPlacement: LabelPlacement.onTicks,
                            majorGridLines: MajorGridLines(width: 0),
                            majorTickLines: MajorTickLines(width: 0),
                            minorTickLines: MinorTickLines(width: 0)),

                        legend: Legend(
                          // Enable the legend
                          textStyle: TextStyle(color: Color(0xff106db6)),
                          position: LegendPosition.top,
                          // isVisible: true,
                        ),

                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ChartSeries>[
                          ColumnSeries<chartdata, String>(
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                color: Colors.grey.shade700,
                                textStyle: GoogleFonts.workSans(
                                    color: Color(0xffffffff),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500)),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                            dataSource: ChartData2,
                            xValueMapper: (chartdata ch, _) => ch.x,
                            yValueMapper: (chartdata ch, _) => ch.y1,
                            xAxisName: 'Month Name',
                            name: 'Status', // Legend label
                            color: Color(
                                0xff106db6), // Change the color of the bars
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 20,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Tickets By Priority",
                            style: GoogleFonts.workSans(
                                color: Color(0xff106db6),
                                fontSize: 24,
                                fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        child: SfCircularChart(
                          borderColor: Colors.transparent,
                          legend: Legend(
                            textStyle: TextStyle(color: Color(0xff106db6)),
                            position: LegendPosition.top,
                            isVisible: true,
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CircularSeries>[
                            PieSeries<chartdata, String>(
                              dataSource: ChartData3,
                              xValueMapper: (chartdata ch, _) => ch.x,
                              yValueMapper: (chartdata ch, _) => ch.y1,
                              dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  color: Colors.white,
                                  textStyle: GoogleFonts.workSans(
                                      color: Color(0xff106db6),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500)),
                              name: 'Priority', // Legend label
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("Tickets By Impacts",
                          style: GoogleFonts.workSans(
                              color: Color(0xff106db6),
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                    ),
                    Container(
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0, // Remove plot area border
                        plotAreaBorderColor: Colors.transparent,
                        borderColor: Colors.transparent,
                        primaryYAxis: NumericAxis(
                            labelStyle: TextStyle(
                              color: Color(0xff6C757D),
                            ),
                            majorTickLines: MajorTickLines(width: 0)),
                        primaryXAxis: CategoryAxis(
                            labelStyle: TextStyle(
                              color: Color(0xff6C757D),
                            ),
                            labelPlacement: LabelPlacement.onTicks,
                            majorGridLines: MajorGridLines(width: 0),
                            majorTickLines: MajorTickLines(width: 0),
                            minorTickLines: MinorTickLines(width: 0)),

                        legend: Legend(
                          // Enable the legend
                          textStyle: TextStyle(color: Color(0xff106db6)),
                          position: LegendPosition.top,
                          isVisible: true,
                        ),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ChartSeries>[

                          BarSeries<chartdata, String>(
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                color: Colors.grey.shade700,
                                textStyle: GoogleFonts.workSans(
                                    color: Color(0xffffffff),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500)),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                                topRight: Radius.circular(5)),
                            dataSource: ChartData4,
                            xValueMapper: (chartdata ch, _) => ch.x,
                            yValueMapper: (chartdata ch, _) => ch.y1,
                            xAxisName: 'Month Name',
                            name: 'Impacts', // Legend label
                            color: Color(
                                0xff106db6), // Change the color of the bars
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // practise material.
            ],
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor:  Color(0xff12283D),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Chat()),
            );
          },
          label: const Text('Chat'),
          icon: const Icon(Icons.chat_bubble_outlined, color: Colors.white, size: 25),
        ),
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
              color: Color(0xff106db6),
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
            selectedItemColor: Color(0xff106db6),
            iconSize: 40,
            onTap: _onItemTapped,
            elevation: 15),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Orders()),
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

class chartdata {
  final String x;
  final int y1;
  chartdata(this.x, this.y1);
}
