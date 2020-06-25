import 'dart:convert';
import 'dart:io';
import 'package:doctor/anim/scale_anim.dart';
import 'package:doctor/comman/area.dart';
import 'package:doctor/database/apis.dart';
import 'package:doctor/pojo/District.dart';
import 'package:doctor/style/fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:doctor/style/colors.dart' as CustomColors;

class DistrictScreen extends StatefulWidget {
  final String userID;
  final String stateID;
  final int i;
  DistrictScreen(this.userID, this.stateID, this.i, {Key key})
      : super(key: key);

  @override
  _DistrictScreenState createState() => _DistrictScreenState();
}

class _DistrictScreenState extends State<DistrictScreen> {
  bool isLoading = true;
  bool isFound = false;

  var districtList = List<District>();
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
          title: Text("Choose city",
              style: new TextStyle(
                  fontFamily: SubsetFonts().toolbarFonts,
                  color: CustomColors.Colors.primaryColor))),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isFound
              ? Center(
                  child: Text(
                    "Districts not available yet\nWe will be there soon"
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: SubsetFonts().titleFont),
                  ),
                )
              : ListView.builder(
                  itemCount: districtList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        districtList[index].districtName,
                        style: TextStyle(fontFamily: SubsetFonts().titleFont),
                      ),
                      onTap: () {
                        Navigator.of(context).push(FadeRouteBuilder(
                            page: AreaScreen(
                                widget.userID,
                                districtList[index].districtId.toString(),
                                widget.i)));
                      },
                    );
                  }),
    );
  }

  fetchData() async {
    Map<String, dynamic> jsondat = {"state_id": widget.stateID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Apis().fetchDistrict,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        districtList = (json.decode(response.body) as List)
            .map((data) => new District.fromJson(data))
            .toList();
        if (districtList.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }
}
