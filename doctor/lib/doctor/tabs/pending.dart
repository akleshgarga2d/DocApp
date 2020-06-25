import 'dart:convert';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:doctor/style/style.dart';
import 'package:http/http.dart' as http;
import 'package:doctor/database/apis.dart';
import 'package:doctor/pojo/DoctorRequestsPojo.dart';
import 'package:doctor/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:doctor/style/colors.dart' as CustomColors;
import 'package:url_launcher/url_launcher.dart';

class PendingDoctor extends StatefulWidget {
  PendingDoctor({Key key}) : super(key: key);
  @override
  _PendingDoctorState createState() => _PendingDoctorState();
}

class _PendingDoctorState extends State<PendingDoctor> {
  bool isLoading = true;
  bool isFound = false;
  bool isSubmitting = false;
  DateTime _selectedValue = DateTime.now();
  String docID;
  var requests = List<DoctorRequestsPojo>();

  _fetchData() async {
    String id = await SharedDatabase().getUserID();

    setState(() {
      docID = id;
    });
    fetchData();
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isFound
              ? Center(
                  child: Text(
                    "No request Found".toUpperCase(),
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
                            requests[index].pname,
                            style:
                                TextStyle(fontFamily: SubsetFonts().titleFont),
                          ),
                          subtitle:
                              Text("Appointment at :" + requests[index].time),
                          trailing: requests[index].status == 'P'
                              ? Text("Pending")
                              : requests[index].status == 'B'
                                  ? Text("Booked")
                                  : Text(""),
                          onTap: () {
                            _writeAnswerBottomSheet(requests[index]);
                          },
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
    Map<String, dynamic> jsondat = {"id": docID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Apis().mAllPendingRequests,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        requests = (json.decode(response.body) as List)
            .map((data) => new DoctorRequestsPojo.fromJson(data))
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

  _writeAnswerBottomSheet(DoctorRequestsPojo doctorRequestsPojo) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (contex) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: isSubmitting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            children: <Widget>[
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Container(
                                      child: Wrap(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 10.0,
                                            left: 15.0,
                                            right: 15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 10.0, bottom: 5.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            doctorRequestsPojo
                                                                .name,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 19.0),
                                                          ),
                                                        ),
                                                        Container(
                                                            child: Text("Age : " +
                                                                doctorRequestsPojo
                                                                    .age)),
                                                        Container(
                                                            child: Text("Gender : " +
                                                                doctorRequestsPojo
                                                                    .gender)),
                                                      ],
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                            Style().spacer(),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 10.0, bottom: 10.0),
                                              child: Text(
                                                doctorRequestsPojo.comments,
                                                style: new TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16.0,
                                                    fontFamily: SubsetFonts()
                                                        .titleFont),
                                              ),
                                            ),
                                            doctorRequestsPojo.status == 'P'
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10.0,
                                                        bottom: 10.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                            child: _phoneDesign(
                                                                doctorRequestsPojo
                                                                    .mobile)),
                                                        Expanded(
                                                            child: _deleteDesign(
                                                                doctorRequestsPojo
                                                                    .id
                                                                    .toString())),
                                                        Expanded(
                                                            child: _acceptDesign(
                                                                doctorRequestsPojo
                                                                    .id
                                                                    .toString()))
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10.0,
                                                        bottom: 10.0),
                                                    child: _phoneDesign(
                                                        doctorRequestsPojo
                                                            .mobile),
                                                  )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 10.0,
                                      )
                                    ],
                                  )),
                                ),
                              )
                            ],
                          ),
                  ));
            },
          );
        });
  }

  _deleteDesign(String id) {
    return Container(
      margin: EdgeInsets.only(top: 7.0, bottom: 5.0, right: 5.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: CustomColors.Colors.primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          )),
      child: InkWell(
        onTap: () {
          setState(() {
            isSubmitting = true;
          });
          updateRequest("R", id);
        },
        child: Container(
          padding:
              EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0, bottom: 10.0),
          child: Text("DELETE",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12.0, color: CustomColors.Colors.primaryColor)),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _phoneDesign(String phone) {
    return Container(
      margin: EdgeInsets.only(top: 7.0, bottom: 5.0, right: 5.0),
      decoration: BoxDecoration(
          color: CustomColors.Colors.primaryColor,
          border: Border.all(width: 1, color: CustomColors.Colors.primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          )),
      child: InkWell(
        onTap: () {
          _makePhoneCall('tel:$phone');
        },
        child: Container(
          padding:
              EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0, bottom: 10.0),
          child: Text("CALL NOW ",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 12.0, color: CustomColors.Colors.white)),
        ),
      ),
    );
  }

  _acceptDesign(String id) {
    return Container(
      margin: EdgeInsets.only(top: 7.0, bottom: 5.0, right: 5.0),
      decoration: BoxDecoration(
          color: CustomColors.Colors.primaryColor,
          border: Border.all(width: 1, color: CustomColors.Colors.primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          )),
      child: InkWell(
        onTap: () {
          setState(() {
            isSubmitting = true;
          });
          updateRequest("B", id);
        },
        child: Container(
          padding:
              EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0, bottom: 10.0),
          child: Text("ACCEPT ",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 12.0, color: CustomColors.Colors.white)),
        ),
      ),
    );
  }

  void updateRequest(String value, String id) async {
    Map<String, dynamic> jsondat = {"id": id, "value": value};
    print(jsondat.toString());
    Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.post(Apis().updateRequest,
        headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (!body['error']) {
        Navigator.of(context).pop();
        _refresh();
      } else {}
      setState(() {
        isSubmitting = false;
      });
    }
  }
}
