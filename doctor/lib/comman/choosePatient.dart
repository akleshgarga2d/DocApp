import 'dart:convert';
import 'package:doctor/anim/scale_anim.dart';
import 'package:doctor/user/bottombarViews/userHome.dart';
import 'package:doctor/user/userFrist.dart';
import 'package:http/http.dart' as http;
import 'package:doctor/database/apis.dart';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:doctor/pojo/MyPatients.dart';
import 'package:doctor/style/fonts.dart';
import 'package:doctor/user/addPateints.dart';
import 'package:flutter/material.dart';
import 'package:doctor/style/colors.dart' as CustomColors;
import 'package:uuid/uuid.dart';

class ChoosePatientAppointment extends StatefulWidget {
  final String date;
  final String time;
  final String doctorID;
  ChoosePatientAppointment(this.date, this.time, this.doctorID, {Key key})
      : super(key: key);
  @override
  _ChoosePatientAppointmentState createState() =>
      _ChoosePatientAppointmentState();
}

class _ChoosePatientAppointmentState extends State<ChoosePatientAppointment> {
  bool isLoading = true;
  bool isFound = false;
  bool isVerifing = false;
  String _comment = "";
  var uuid = Uuid();
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
        title: Text("Choose Patient"),
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
                          subtitle: Text(
                              "Age :" + patientsList[index].age.toString()),
                          onTap: () async {
                            smsCodeDialog(context, patientsList[index].id);
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

  smsCodeDialog(BuildContext context, String id) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setBottomState) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(5.0),
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  tooltip: "Close",
                                  padding: EdgeInsets.only(bottom: 5.0),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: CustomColors.Colors.primaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(19.0),
                                topRight: Radius.circular(19.0)),
                          )),
                      isVerifing
                          ? Container(
                              margin: EdgeInsets.all(50.0),
                              child: Center(child: CircularProgressIndicator()))
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    child: Text(
                                      "REASON FOR APPOINTMENT".toUpperCase(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                    ),
                                    child: TextField(
                                      minLines: 1,
                                      maxLines: 3,
                                      autofocus: false,
                                      obscureText: false,
                                      onChanged: (String value) {
                                        if (value.length > 0) {
                                          
                                          setBottomState(() {
                                            this._comment = value;
                                          });
                                        } else {}
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        hintText: 'Describe problem',
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 2.0, 20.0, 2.0),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    alignment: Alignment.center,
                                    child: RaisedButton(
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (_comment.length > 0) {
                                          setBottomState(() {
                                            isVerifing = true;
                                          });
                                          addAppointment(
                                              id,
                                              widget.date,
                                              widget.time,
                                              widget.doctorID,
                                              _comment);
                                        }
                                      },
                                      color: CustomColors.Colors.primaryColor,
                                      child: Text(
                                        "BOOK APPOINTMENT",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void addAppointment(String id, String date, String time, String doctorID,
      String comment) async {
    Map<String, dynamic> jsondat = {
      "user_id": id,
      "date": date,
      "time": time,
      "doctor_id": doctorID,
      "comments": comment
    };
    print(jsondat.toString());
    Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.post(Apis().mBookAppointment,
        headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (!body['error']) {
        Navigator.of(context)
            .pushReplacement(FadeRouteBuilder(page: UserMainScreen()));
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
