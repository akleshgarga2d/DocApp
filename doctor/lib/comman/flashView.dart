import 'dart:async';
import 'package:doctor/style/colors.dart' as CustomColors;
import 'package:doctor/comman/chooseScreen.dart';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:doctor/doctor/docFrist.dart';
import 'package:doctor/doctor/progressProfile.dart';
import 'package:doctor/user/userFrist.dart';
import 'package:doctor/user/userProfile.dart';
import 'package:flutter/material.dart';

class FlashScreen extends StatefulWidget {
  @override
  _FlashScreenState createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  bool isLogin;
  String userType;
  bool mDone;
  bool mCategory;
  bool mLocation;
  bool mTimeSlots;
  bool isProfile;
  String mobile;
  //---------GET ALL USERS INFO FUNCTION -------------------------
  fetchInfo() async {
    String type = await SharedDatabase().getType();
    bool logIn = await SharedDatabase().isLogin();
    bool don = await SharedDatabase().isDdon();
    String mob = await SharedDatabase().getMobile();
    if (type == 'D') {
      bool loc = await SharedDatabase().getLocation();
      bool slot = await SharedDatabase().getSlots();
      bool cat = await SharedDatabase().getDoctorCategory();
      bool prof = await SharedDatabase().isProfile();

      setState(() {
        isProfile = prof;
        mCategory = cat;
        mTimeSlots = slot;
        mLocation = loc;
      });
    }
    setState(() {
      isLogin = logIn;
      userType = type;
      mDone = don;
      mobile = mob;
    });

    if (isLogin != null) {
      if (isLogin) {
        if (type != null) {
          if (type == 'D') {
            if (mDone != null) {
              if (mDone) {
                Timer(
                    Duration(seconds: 1),
                    () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DoctorMainScreen())));
              } else {
                Timer(
                    Duration(seconds: 1),
                    () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (BuildContext context) => ProgressProfile(
                                isProfile, mCategory, mLocation, mTimeSlots))));
              }
            } else {
              Timer(
                  Duration(seconds: 1),
                  () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => ProgressProfile(
                          isProfile, mCategory, mLocation, mTimeSlots))));
            }
            /*   Timer(
                Duration(seconds: 1),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => DoctorMainScreen())));
         */
          } else {
            if (mDone != null) {
              if (mDone) {
                Timer(
                    Duration(seconds: 1),
                    () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                UserMainScreen())));
              } else {
                Timer(
                    Duration(seconds: 1),
                    () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                UserProfileScreen(mobile))));
              }
            } else {
              Timer(
                  Duration(seconds: 1),
                  () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => UserProfileScreen(mobile))));
            }
            /*   Timer(
                Duration(seconds: 1),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => UserMainScreen())));
          */
          }
        } else {
          Timer(
              Duration(seconds: 1),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => ChooseScreen())));
        }
      } else {
        Timer(
            Duration(seconds: 1),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => ChooseScreen())));
      }
    } else {
      Timer(
          Duration(seconds: 1),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => ChooseScreen())));
    }
  }
  //---------*-------------------------

  @override
  void initState() {
    fetchInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              height: 100.0,
              width: 100.0,
              child: Image.asset(
                "assets/icons/doctor.png",
              ),
            ),
            Container(
              child: Text(
                "A2D Technosoft",
                style: TextStyle(
                    textBaseline: TextBaseline.alphabetic,
                    color: CustomColors.Colors.primaryColor,
                    fontSize: 20.0,
                    fontFamily: 'RobotoMedium'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
