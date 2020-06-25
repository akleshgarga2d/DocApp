import 'package:doctor/anim/scale_anim.dart';
import 'package:doctor/comman/mobileVerification.dart';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:doctor/style/fonts.dart';
import 'package:doctor/style/string.dart';
import 'package:flutter/material.dart';
import 'package:doctor/style/colors.dart' as CustomColors;

class ChooseScreen extends StatefulWidget {
  @override
  _ChooseScreenState createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  _textStyle() {
    return TextStyle(
        fontSize: 15.0,
        color: CustomColors.Colors.primaryColor,
        fontFamily: SubsetFonts().descriptionFont);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                  child: Container(
                    height: 200.0,
                    child: Image.asset("assets/icons/image.jpg"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    StringData().chooseroleText.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                        fontFamily: SubsetFonts().titleFont),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              SharedDatabase().setType("D");
                              Navigator.of(context).push(
                                  FadeRouteBuilder(page: MobileVerification("D")));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 65.0,
                                    padding: EdgeInsets.all(10.0),
                                    child:
                                        Image.asset("assets/icons/doctor.png"),
                                  ),
                                  Container(
                                    child: Text(
                                      "Doctor".toUpperCase(),
                                      style: _textStyle(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              SharedDatabase().setType("P");
                              Navigator.of(context).push(
                                  FadeRouteBuilder(page: MobileVerification("P")));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 65.0,
                                    padding: EdgeInsets.all(10.0),
                                    child:
                                        Image.asset("assets/icons/patient.png"),
                                  ),
                                  Container(
                                    child: Text(
                                      "Patient".toUpperCase(),
                                      style: _textStyle(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
