import 'dart:convert';
import 'dart:io';
import 'package:doctor/anim/scale_anim.dart';
import 'package:doctor/comman/bookAppointment.dart';
import 'package:doctor/comman/doctorProfile.dart';
import 'package:doctor/database/apis.dart';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:doctor/pojo/Category.dart';
import 'package:doctor/pojo/Doctor.dart';
import 'package:doctor/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctor/style/colors.dart' as CustomColors;

class UserHomeScreen extends StatefulWidget {
  UserHomeScreen({Key key}) : super(key: key);
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  bool isLoading = true;
  bool isCatLoading = true;
  var catList = new List<Categories>();
  var doctorList = new List<DoctorPojo>();
  bool isFound = false;
  String catID;
  String areaID;
  _submitDesign(DoctorPojo doctor) {
    return Container(
      margin: EdgeInsets.only(top: 7.0, bottom: 5.0, right: 5.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: CustomColors.Colors.primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          )),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(FadeRouteBuilder(page: DoctorProfile(doctor)));
        },
        child: Container(
          padding:
              EdgeInsets.only(left: 12.0, right: 12.0, top: 5.0, bottom: 5.0),
          child: Text("PROFILE",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12.0, color: CustomColors.Colors.primaryColor)),
        ),
      ),
    );
  }

  _openDesign(DoctorPojo doctorPojo) {
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
          Navigator.of(context)
              .push(FadeRouteBuilder(page: BookApointment(doctorPojo)));
        },
        child: Container(
          padding:
              EdgeInsets.only(left: 12.0, right: 12.0, top: 5.0, bottom: 5.0),
          child: Text("BOOK ",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 12.0, color: CustomColors.Colors.white)),
        ),
      ),
    );
  }

  _getData() async {
    String area = await SharedDatabase().getAreaID();
    String catid = await SharedDatabase().getCatID();
    setState(() {
      areaID = area;
      catID = catid;
    });
    print(areaID + catID);

    _fetchData();
    fetchDoctorList();
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
        title: Text("Home"),
        actions: <Widget>[
          //  IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.location_searching), onPressed: () {}),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isFound
              ? Center(
                  child: Text(
                    "doctors not found".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: SubsetFonts().notfoundFont),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                      itemCount: doctorList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    bottom: 5.0,
                                    top: 10.0),
                                child: CircleAvatar(
                                  radius: 40.0,
                                  backgroundColor:
                                      Colors.grey,
                                  backgroundImage: NetworkImage(
                                    Apis().imagesUrl +
                                        doctorList[index].image,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        doctorList[index].name,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19.0),
                                      ),
                                    ),
                                    Container(
                                        child:
                                            doctorList[index].availability ==
                                                    'A'
                                                ? Text(
                                                    "Available",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: CustomColors
                                                            .Colors
                                                            .primaryColor),
                                                  )
                                                : Text("Not available")),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: _openDesign(
                                                  doctorList[index])),
                                          Expanded(
                                              child: _submitDesign(
                                                  doctorList[index]))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ),
                        );
                      }),
                ),
      bottomNavigationBar: isCatLoading ? Container() : _buildGenreSection(),
    );
  }

  Future<void> _refresh() async {
    //  _fetchData();
    setState(() {
      isLoading = true;
      isFound = false;
      doctorList.clear();
    });
    fetchDoctorList();
  }

  _buildGenreSection() {
    return Container(
      height: 50.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: catList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: catID == catList[index].categoryId
                      ? Colors.blueGrey
                      : Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  onTap: () async {
                    SharedDatabase().setCatID(catList[index].categoryId);
                    String catid = await SharedDatabase().getCatID();
                    setState(() {
                      catID = catid;
                      print(catID);
                    });
                    _refresh();
                  },
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '${catList[index].categoryName}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  fetchDoctorList() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> jsondat = {"area_id": areaID, "cat_id": catID};
    print(jsondat.toString());
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Apis().mFetchDoctorList,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        doctorList = (json.decode(response.body) as List)
            .map((data) => new DoctorPojo.fromJson(data))
            .toList();
        if (doctorList.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }

  _fetchData() async {
    final response = await http.get(Apis().fetchCategory);
    if (response.statusCode == 200) {
      setState(() {
        catList = (json.decode(response.body) as List)
            .map((data) => new Categories.fromJson(data))
            .toList();
        isCatLoading = false;
      });
      print(response.body);
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
