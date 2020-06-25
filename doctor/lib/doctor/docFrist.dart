import 'dart:io';

import 'package:doctor/doctor/tabs/allRequest.dart';
import 'package:doctor/doctor/tabs/pending.dart';
import 'package:doctor/doctor/tabs/today.dart';
import 'package:flutter/material.dart';

class DoctorMainScreen extends StatefulWidget {
  @override
  _DoctorMainScreenState createState() => _DoctorMainScreenState();
}

class _DoctorMainScreenState extends State<DoctorMainScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
        return true;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Today",
                ),
                Tab(
                  text: "Pending",
                ),
                Tab(
                  text: "All requests",
                ),
              ],
            ),
            title: Text("A2D Doctor"),
          ),
          body: TabBarView(
            children: <Widget>[
              TodayDoctor(
                key: PageStorageKey("p1"),
              ),
              PendingDoctor(
                key: PageStorageKey("p2"),
              ),
              RequestsDoctor(
                key: PageStorageKey("p3"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
