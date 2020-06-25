import 'dart:convert';

import 'package:doctor/database/apis.dart';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:doctor/pojo/PatientsRequestPojo.dart';
import 'package:doctor/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserRequestScreen extends StatefulWidget {
  UserRequestScreen({Key key}) : super(key: key);
  @override
  _UserRequestScreenState createState() => _UserRequestScreenState();
}

class _UserRequestScreenState extends State<UserRequestScreen> {
  bool isLoading = true;
  bool isFound = false;
  var patientsList = List<PatientsRequestPojo>();
  String userID;
  _getData() async {
    String userid = await SharedDatabase().getUserID();
    setState(() {
      userID = userid;
    });
    fetchData();
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requests"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isFound
              ? Center(
                  child: Text(
                    "No pending requests \n".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: SubsetFonts().titleFont),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                      itemCount: patientsList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            patientsList[index].pname,
                            style:
                                TextStyle(fontFamily: SubsetFonts().titleFont),
                          ),
                          subtitle: Text("Appointments on :" +
                              patientsList[index].date +
                              " At " +
                              patientsList[index].time +
                              " with " +
                              patientsList[index].name),
                          trailing: patientsList[index].status == 'P'
                              ? Text("Pending")
                              : patientsList[index].status == 'B'
                                  ? Text("Booked")
                                  : patientsList[index].status == 'D'
                                      ? Text("Completed")
                                      : patientsList[index].status == 'R'
                                          ? Text("Cancelled")
                                          : Container(),
                        );
                      }),
                ),
    );
  }

  Future<void> _refresh() async {
    //  _fetchData();
    setState(() {
      isLoading = true;
      isFound = false;
      patientsList.clear();
    });
    fetchData();
  }

  fetchData() async {
    Map<String, dynamic> jsondat = {"id": userID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Apis().mAllUserPendingAppointments,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        patientsList = (json.decode(response.body) as List)
            .map((data) => new PatientsRequestPojo.fromJson(data))
            .toList();
        if (patientsList.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }
}
