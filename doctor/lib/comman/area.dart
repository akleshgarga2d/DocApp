import 'dart:convert';
import 'dart:io';
import 'package:doctor/anim/scale_anim.dart';
import 'package:doctor/database/apis.dart';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:doctor/doctor/progressProfile.dart';
import 'package:doctor/pojo/Area.dart';
import 'package:doctor/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctor/style/colors.dart' as CustomColors;

class AreaScreen extends StatefulWidget {
  final String userID;
  final String districtID;
  final int i;
  AreaScreen(this.userID, this.districtID, this.i, {Key key}) : super(key: key);

  @override
  _AreaScreenState createState() => _AreaScreenState();
}

class _AreaScreenState extends State<AreaScreen> {
  bool isLoading = true;
  bool isFound = false;
  var areaList = List<Area>();

  @override
  void initState() {
    this.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text("Choose Area",
            style: new TextStyle(
                fontFamily: SubsetFonts().toolbarFonts,
                color: CustomColors.Colors.primaryColor)),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isFound
              ? Center(
                  child: Text(
                    "Area not available yet\nWe will be there soon"
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: SubsetFonts().notfoundFont),
                  ),
                )
              : ListView.builder(
                  itemCount: areaList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        areaList[index].areaName,
                        style: TextStyle(fontFamily: SubsetFonts().titleFont),
                      ),
                      onTap: () {
                        if (widget.i == 1) {
                          setState(() {
                            isLoading = true;
                          });
                          submitToDatabase(
                              areaList[index].id.toString(), widget.userID);
                        }
                      },
                    );
                  }),
    );
  }

  submitToDatabase(String id, String uID) async {
    Map<String, dynamic> jsondat = {"id": id, "doctor_id": uID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Apis().mSubmitArea,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body.toString());
      if (!body['error']) {
        SharedDatabase().setLoaction(true);
        Navigator.of(context).push(
            FadeRouteBuilder(page: ProgressProfile(true, true, true, false)));
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  fetchData() async {
    Map<String, dynamic> jsondat = {"district_id": widget.districtID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Apis().fetchArea,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        areaList = (json.decode(response.body) as List)
            .map((data) => new Area.fromJson(data))
            .toList();
        if (areaList.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }
}
