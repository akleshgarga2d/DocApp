import 'dart:convert';
import 'package:doctor/anim/scale_anim.dart';
import 'package:doctor/comman/district.dart';
import 'package:doctor/database/apis.dart';
import 'package:doctor/pojo/State.dart';
import 'package:doctor/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctor/style/colors.dart' as CustomColors;

class StateListScreen extends StatefulWidget {
  final String userID;
  final int i;
  StateListScreen(this.userID, this.i, {Key key}) : super(key: key);

  @override
  _StateListScreenState createState() => _StateListScreenState();
}

class _StateListScreenState extends State<StateListScreen> {
  bool isLoading = true;
  bool isFound = false;
  var stateList = List<StatePojo>();

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
        title: Text("Choose State",
            style: new TextStyle(
              fontFamily: SubsetFonts().toolbarFonts,
              color: CustomColors.Colors.primaryColor,
            )),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isFound
              ? Center(
                  child: Text(
                    "States not found yet\nWe will there soon".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: SubsetFonts().notfoundFont),
                  ),
                )
              : ListView.builder(
                  itemCount: stateList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        stateList[index].stateName,
                        style: TextStyle(fontFamily: SubsetFonts().titleFont),
                      ),
                      onTap: () {
                        Navigator.of(context).push(FadeRouteBuilder(
                            page: DistrictScreen(widget.userID,
                                stateList[index].id.toString(), widget.i)));
                      },
                    );
                  }),
    );
  }

  fetchData() async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.get(
      Apis().fetchState,
      headers: headers,
    );
    if (response.statusCode == 200) {
      setState(() {
        stateList = (json.decode(response.body) as List)
            .map((data) => new StatePojo.fromJson(data))
            .toList();
        if (stateList.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }
}
