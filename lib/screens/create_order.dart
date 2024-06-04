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

class Create_Order extends StatefulWidget {
  static const Color contentColorOrange = Color(0xFF00705B);
  final Color leftBarColor = Color(0xFFCB6600);
  final Color rightBarColor = Color(0xFF5BECD2);
  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<Create_Order> {
  int selectedOptionIndex = 0;
  TextEditingController ticketNumberController = TextEditingController();
  TextEditingController createdByController = TextEditingController();
  TextEditingController taskAssignedController = TextEditingController();
  TextEditingController reportedByController = TextEditingController();
  TextEditingController problemController = TextEditingController();
  TextEditingController complaintModeController = TextEditingController();
  TextEditingController issueTypeController = TextEditingController();
  TextEditingController resolvedByController = TextEditingController();
  TextEditingController issueSubTypeController = TextEditingController();
  TextEditingController resolvedDateController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController buStoreNameController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController storeInfoController = TextEditingController();
  TextEditingController impactController = TextEditingController();
  // TextEditingController storeManagerController = TextEditingController();
  // TextEditingController marketingManagerController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<dynamic> ticket_status = [];
  List<dynamic> task_reported = [];
  List<dynamic> issue_type = [];
  List<dynamic> issue_sub_type = [];
  List<dynamic> priority = [];
  List<dynamic> BU_Name = [];
  List<dynamic> Impact = [];

  List<String> options = ['Individual', 'Group'];
  String selectedOption = 'Individual';

  late DateTime ticketDueDate;
  late DateTime ticketResolvedDate;
  late File image;

  Future<List<dynamic>> fetchData() async {
    print('hitting');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String companyId = prefs.getString("company_id").toString();

    var request = http.Request(
        'GET', Uri.parse('http://3.137.76.254/api/status/company/$companyId'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var json = await response.stream.bytesToString();
      print(json);
      var jsons = jsonDecode(json);
      print(jsons.length);
      ticket_status = jsons;
      return jsons;
    } else {
      return [];
    }
  }
  Future<List<dynamic>> fetchUsers() async {
    print('hitting');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String companyId = prefs.getString("company_id").toString();
    String buId = prefs.getString("bu_id").toString();
    String id = prefs.getString("id").toString();

    var request = http.Request(
        'GET', Uri.parse('http://3.137.76.254/api/users/company/$companyId'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var json = await response.stream.bytesToString();
      print(json);
      List<dynamic> jsons = jsonDecode(json);
      print(jsons.length);
      task_reported = jsons;
      return jsons;
    } else {
      return [];
    }
  }
  Future<List<dynamic>> fetchType() async {
    print('hitting');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String companyId = prefs.getString("company_id").toString();
    String buId = prefs.getString("bu_id").toString();
    String id = prefs.getString("id").toString();

    var request = http.Request(
        'GET', Uri.parse('http://3.137.76.254/api/companytype/$companyId'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var json = await response.stream.bytesToString();
      print(json);
      List<dynamic> jsons = jsonDecode(json);
      print(jsons.length);
      setState(() {
        issue_type = jsons;
      });
      return jsons;
    } else {
      return [];
    }
  }
  Future<List<dynamic>> fetchSubType(id) async {
    var request = http.Request(
        'GET', Uri.parse('http://3.137.76.254/api/types/parent/$id'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var json = await response.stream.bytesToString();
      print(json);
      List<dynamic> jsons = jsonDecode(json);
      print(jsons.length);
      setState(() {
        issue_sub_type = jsons;
      });
      return jsons;
    } else {
      return [];
    }
  }
  Future<List<dynamic>> fetchPriority() async {
    print('hitting');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String companyId = prefs.getString("company_id").toString();
    String buId = prefs.getString("bu_id").toString();
    String id = prefs.getString("id").toString();

    var request = http.Request('GET',
        Uri.parse('http://3.137.76.254/api/priority/company/$companyId'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var json = await response.stream.bytesToString();
      print(json);
      List<dynamic> jsons = jsonDecode(json);
      print(jsons.length);
      priority = jsons;
      /*for(int i=0;i<jsons.length;i++)
      {
        // print(jsons[i]['id']);
        setState(() {
          priority.add(jsons[i]['title']);
        });
      }*/
      return jsons;
    } else {
      return [];
    }
  }
  Future<List<dynamic>> fetchBusinessUnits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String companyId = prefs.getString("company_id").toString();
    var request = http.Request('GET',
        Uri.parse('http://3.137.76.254/api/business_units/$companyId'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var json = await response.stream.bytesToString();
      print(json);
      List<dynamic> jsons = jsonDecode(json);
      print(jsons.length);
      BU_Name = jsons;
      /*for(int i=0;i<jsons.length;i++)
      {
        // print(jsons[i]['id']);
        setState(() {
          priority.add(jsons[i]['title']);
        });
      }*/
      return jsons;
    } else {
      return [];
    }
  }
  Future<List<dynamic>> fetchImpact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String companyId = prefs.getString("company_id").toString();
    var request = http.Request('GET',
        Uri.parse('http://3.137.76.254/api/impacts/$companyId'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var json = await response.stream.bytesToString();
      print(json);
      List<dynamic> jsons = jsonDecode(json);
      print(jsons.length);
      Impact = jsons;
      print("Here are Imapact $Impact");
      /*for(int i=0;i<jsons.length;i++)
      {
        // print(jsons[i]['id']);
        setState(() {
          priority.add(jsons[i]['title']);
        });
      }*/
      return jsons;
    } else {
      return [];
    }
  }
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != dueDateController.text) {
      setState(() {
        dueDateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }
  Future<void> _selectResolvedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != resolvedDateController.text) {
      setState(() {
        resolvedDateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }
  Future<void> _getImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              child: const Icon(Icons.collections),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              child: const Icon(Icons.camera_alt),
            ),
          ],
        );
      },
    );

    if (pickedSource != null) {
      final pickedImage = await picker.getImage(
        source: pickedSource,
      );

      if (pickedImage != null) {
        setState(() {
          image = File(pickedImage.path);
        });
      }
    }
  }

  Future<void> CreateTickets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String companyId = prefs.getString("company_id").toString();
    String id = prefs.getString("id").toString();
    try {
      var request = http.MultipartRequest('POST', Uri.parse('http://3.137.76.254/api/tickets'));
      request.fields.addAll({
        'title': ticketNumberController.text,
        'description': descriptionController.text,
        'completed_date': resolvedDateController.text,
        'due_date': dueDateController.text,
        'company_id': companyId,
        'completed_by': resolvedByController.text,
        'business_unit_id': buStoreNameController.text,
        'vendor_id': '7',
        'vendor_type_id': '8',
        'reported_by':  reportedByController.text,
        'assigned_to': taskAssignedController.text,
        'mode_of_complaint': complaintModeController.text,
        'sub_type_id': issueSubTypeController.text,
        'priority_id': priorityController.text,
        'impact_id': impactController.text,
        'status_id': statusController.text,
        'store_contact': storeInfoController.text,
        'created_by': id,
        'email_status': '18',
        'assigned_type': selectedOption,
        'customer_id': '1'
      });
      request.files.add(await http.MultipartFile.fromPath('profile', image.path));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        print("work Done part 1");
      } else {
        print('Request failed with status: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void initState() {
    setState(() {
      fetchData();
      fetchUsers();
      fetchType();
      fetchPriority();
      fetchBusinessUnits();
      fetchImpact();
    });
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
          'Create Order',
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: ticketNumberController,
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Ticket#'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: createdByController,
                      decoration:
                      InputDecoration(labelText: 'Ticket Created By'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Second Row - Toggle Button
              ToggleButtons(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Individual'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Group'),
                  ),
                ],
                isSelected: [
                  selectedOption == 'Individual',
                  selectedOption == 'Group'
                ],
                onPressed: (index) {
                  setState(() {
                    selectedOption = options[index];
                    // Now selectedOption holds the text of the selected option
                    // You can add your logic for individual and group based on the value of selectedOption
                  });
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: task_reported
                          .map<DropdownMenuItem<String>>((dynamic option) {
                        return DropdownMenuItem<String>(
                          value: option['id'],
                          child: Text("${option['first_name']}-${option['last_name']}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // TODO: Handle dropdown value change
                        taskAssignedController.text = value!;
                      },
                      decoration: InputDecoration(labelText: 'Task Assigned'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: task_reported
                          .map<DropdownMenuItem<String>>((dynamic option) {
                        return DropdownMenuItem<String>(
                          value: option['id'],
                          child: Text("${option['first_name']}-${option['last_name']}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // TODO: Handle dropdown value change
                        reportedByController.text = value!;
                      },
                      decoration:
                      InputDecoration(labelText: 'Ticket Reported By'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: problemController,
                      decoration: InputDecoration(labelText: 'Problem'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: complaintModeController,
                      decoration:
                      InputDecoration(labelText: 'Mode of Complaint'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: issue_type
                          .map<DropdownMenuItem<String>>((dynamic option) {
                        return DropdownMenuItem<String>(
                          value: option['id'],
                          child: Text(option['title']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // TODO: Handle dropdown value change
                        issueTypeController.text = value!;
                        print(value);
                        fetchSubType(value);
                      },
                      decoration: InputDecoration(labelText: 'Issue Type'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: task_reported
                          .map<DropdownMenuItem<String>>((dynamic option) {
                        return DropdownMenuItem<String>(
                          value: option['id'],
                          child: Text("${option['first_name']}-${option['last_name']}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // TODO: Handle dropdown value change
                        resolvedByController.text = value!;
                      },
                      decoration:
                      InputDecoration(labelText: 'Ticket Resolved By'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: issue_sub_type
                          .map<DropdownMenuItem<String>>((dynamic option) {
                        return DropdownMenuItem<String>(
                          value: option['id'],
                          child: Text(option['title']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // TODO: Handle dropdown value change
                        issueSubTypeController.text = value!;
                      },
                      decoration: InputDecoration(labelText: 'Issue Sub Type'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectResolvedDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: resolvedDateController,
                          decoration: InputDecoration(
                              labelText: 'Ticket Resolved Date'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: ticket_status
                          .map<DropdownMenuItem<String>>((dynamic option) {
                        return DropdownMenuItem<String>(
                          value: option['id'],
                          child: Text(option['title']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // TODO: Handle dropdown value change
                        statusController.text=value!;
                      },
                      decoration: InputDecoration(labelText: 'Status'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: priority
                          .map<DropdownMenuItem<String>>((dynamic option) {
                        return DropdownMenuItem<String>(
                          value: option['id'],
                          child: Text(option['title']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                        // TODO: Handle dropdown value change
                        priorityController.text=value!;
                      },
                      decoration: InputDecoration(labelText: 'Priority'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true, // Ensures the dropdown button expands to fit the available space
                      isDense: false, // Allows text wrapping
                      items: BU_Name.map<DropdownMenuItem<String>>((dynamic option) {
                        return DropdownMenuItem<String>(
                          value: option['id'],
                          child: Text("${option['name']}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // TODO: Handle dropdown value change
                        buStoreNameController.text = value!;
                      },
                      decoration: InputDecoration(labelText: 'BU/Store Name'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDueDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: dueDateController,
                          decoration:
                          InputDecoration(labelText: 'Ticket Due Date'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: storeInfoController,
                      decoration: InputDecoration(labelText: 'Store Info'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: Impact.map<DropdownMenuItem<String>>((dynamic option) {
                        return DropdownMenuItem<String>(
                          value: option['id'],
                          child: Text("${option["title"]}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // TODO: Handle dropdown value change
                        impactController.text = value!;
                      },
                      decoration: InputDecoration(labelText: 'Impact'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              /*
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: ['Manager 1', 'Manager 2', 'Manager 3']
                          .map((manager) => DropdownMenuItem<String>(
                        value: manager,
                        child: Text(manager),
                      ))
                          .toList(),
                      onChanged: (value) {
                        // TODO: Handle dropdown value change
                      },
                      decoration: InputDecoration(labelText: 'Store Manager'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: ['Manager 1', 'Manager 2', 'Manager 3']
                          .map((manager) => DropdownMenuItem<String>(
                        value: manager,
                        child: Text(manager),
                      ))
                          .toList(),
                      onChanged: (value) {
                        // TODO: Handle dropdown value change
                      },
                      decoration:
                      InputDecoration(labelText: 'Marketing Manager'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              */
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              ElevatedButton(

                onPressed: () => _getImage(context),
                child: Text('Upload Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff12283D),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  CreateTickets();
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff12283D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
