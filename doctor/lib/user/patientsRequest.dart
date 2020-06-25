import 'dart:convert';

import 'package:doctor/database/apis.dart';
import 'package:doctor/pojo/MyPatients.dart';
import 'package:doctor/pojo/PatientsRequestPojo.dart';
import 'package:doctor/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PatientsRequest extends StatefulWidget {
  final MyPatients patient;
  PatientsRequest(this.patient, {Key key}) : super(key: key);
  @override
  _PatientsRequestState createState() => _PatientsRequestState();
}

class _PatientsRequestState extends State<PatientsRequest> {
  bool isLoading = true;
  bool isFound = false;
  var requests = List<PatientsRequestPojo>();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient.name + " Requests"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isFound
              ? Center(
                  child: Text(
                    "Requests not found \n".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: SubsetFonts().titleFont),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            requests[index].name,
                            style:
                                TextStyle(fontFamily: SubsetFonts().titleFont),
                          ),
                          subtitle:
                              Text("Appointments on :" + requests[index].date),
                          /* onTap: () async {
                             final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPateints(userID)),
                            );
                            if (result != null) {
                              if (result) {
                                _refresh();
                              }
                            }
                          },*/
                          trailing: requests[index].status == 'P'
                              ? Text("Pending")
                              : requests[index].status == 'B'
                                  ? Text("BOOKED")
                                  : requests[index].status == 'D'
                                      ? Text("Completed")
                                      : requests[index].status == 'R'
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
      requests.clear();
    });
    fetchData();
  }

  fetchData() async {
    Map<String, dynamic> jsondat = {"id": widget.patient.id};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Apis().mPatientsAppointments,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        requests = (json.decode(response.body) as List)
            .map((data) => new PatientsRequestPojo.fromJson(data))
            .toList();
        if (requests.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }
}
