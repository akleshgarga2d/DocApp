import 'dart:convert';

import 'package:doctor/anim/scale_anim.dart';
import 'package:doctor/database/apis.dart';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:doctor/pojo/MyPatients.dart';
import 'package:doctor/style/fonts.dart';
import 'package:doctor/user/addPateints.dart';
import 'package:doctor/user/patientsRequest.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PatientScreen extends StatefulWidget {
  PatientScreen({Key key}) : super(key: key);
  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  bool isLoading = true;
  bool isFound = false;
  var patientsList = List<MyPatients>();
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
        title: Text("Patients"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isFound
              ? Center(
                  child: Text(
                    "No patients added\nPlease add patients".toUpperCase(),
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
                            patientsList[index].name,
                            style:
                                TextStyle(fontFamily: SubsetFonts().titleFont),
                          ),
                          subtitle: Text("Total appointments :" +
                              patientsList[index].requests.toString()),
                          onTap: () async {
                            Navigator.of(context).push(
                                FadeRouteBuilder(
                                    page:
                                        PatientsRequest(patientsList[index])));
                          },
                        );
                      }),
                ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPateints(userID)),
            );
            if (result != null) {
              if (result) {
                _refresh();
              }
            }
          }),
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
    final response = await http.post(Apis().mFetchMyPatientsList,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        patientsList = (json.decode(response.body) as List)
            .map((data) => new MyPatients.fromJson(data))
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
