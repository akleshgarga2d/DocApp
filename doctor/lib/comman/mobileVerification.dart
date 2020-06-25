import 'dart:convert';

import 'package:doctor/anim/scale_anim.dart';
import 'package:doctor/database/apis.dart';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:doctor/doctor/docFrist.dart';
import 'package:doctor/doctor/progressProfile.dart';
import 'package:doctor/style/fonts.dart';
import 'package:doctor/user/userFrist.dart';
import 'package:doctor/user/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:doctor/style/colors.dart' as CustomColors;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class MobileVerification extends StatefulWidget {
  final String mType;
  MobileVerification(this.mType, {Key key}) : super(key: key);
  @override
  _MobileVerificationState createState() => _MobileVerificationState();
}

class _MobileVerificationState extends State<MobileVerification> {
  TextEditingController phoneNumber = new TextEditingController();
  bool isLoading = false;
/*
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;
  */
  String statusMessage = "";
  String _smsCode;
  String dialogSms = "Please check your phone for the verification code.";
  bool isVerifing = false;
  bool isSending = false;
  String verifyStatus = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 1,
        backgroundColor: CustomColors.Colors.white,
        title: Text("Verify",
            style: new TextStyle(
                fontFamily: SubsetFonts().toolbarFonts,
                color: CustomColors.Colors.primaryColor)),
      ),
      body: isLoading
          ? Center(
              child: SpinKitDoubleBounce(
              color: CustomColors.Colors.primaryColor,
            ))
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin:
                          EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      child: Text(
                        "Anekant store will send you an OTP after you enter your phone number. OTP is only valide for 15 sec. Please do not use (+91) as it is by default.",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Colors.black54,
                            fontSize: 15.0,
                            fontFamily: SubsetFonts().titleFont),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(0.0),
                      margin:
                          EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                      child: TextField(
                        cursorColor: CustomColors.Colors.primaryColor,
                        maxLength: 10,
                        autofocus: true,
                        controller: phoneNumber,
                        keyboardType: TextInputType.phone,
                        onChanged: (String value) {
                          setState(() {
                            verifyStatus = "";
                          });
                        },
                        decoration: new InputDecoration(
                            hintText: "  Mobile Number",
                            icon: Icon(
                              Icons.keyboard,
                              color: CustomColors.Colors.primaryColor,
                            )),
                      ),
                    ),
                    isSending
                        ? Container(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            margin: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10.0),
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              child: Text(
                                "VERIFY MOBILE NUMBER",
                                style: new TextStyle(
                                    color: CustomColors.Colors.white),
                              ),
                              color: CustomColors.Colors.primaryColor,
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                setState(() {
                                  isSending = true;
                                });
                                smsCodeDialog(context);
                                //  _verifyPhoneNumber();
                              },
                            ),
                          ),
                    Container(
                      margin:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 7.0),
                      child: Text(
                        verifyStatus,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  smsCodeDialog(BuildContext context) {
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
                                    setBottomState(() {
                                      isVerifing = false;
                                      dialogSms =
                                          "Please check your phone for the verification code.";
                                    });
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
                                      dialogSms.toUpperCase(),
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
                                      maxLines: 1,
                                      autofocus: false,
                                      maxLength: 6,
                                      obscureText: false,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        if (value.length > 0) {
                                          setBottomState(() {
                                            this._smsCode = value;
                                          });
                                        } else {}
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        hintText: 'Enter 6 digit OTP',
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
                                        /*
                                        setBottomState(() {
                                          isVerifing = true;
                                        });
                                        FirebaseAuth.instance
                                            .currentUser()
                                            .then((user) {
                                          if (user != null) {
                                            Navigator.of(context).pop();
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    FadeRouteBuilder(
                                                        page: MainScreen()));
                                          } else {
                                         //   _signInWithPhoneNumber();
                                          }
                                        });
                                        */
                                        if (widget.mType == 'D') {
                                          doctorVerification();
                                        } else {
                                          userVerification();
                                        }
                                      },
                                      color: CustomColors.Colors.primaryColor,
                                      child: Text(
                                        "SUBMIT OTP",
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

  void userVerification() async {
    Map<String, dynamic> jsondat = {"mobile": phoneNumber.text.toString()};
    print(jsondat.toString());
    Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.post(Apis().mUserLogin,
        headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (!body['error']) {
        SharedDatabase().setLogin(true);
        SharedDatabase().setType("P");
        SharedDatabase().setDdone(true);
        SharedDatabase().setUserData(body['id']);
        SharedDatabase().setMobile(phoneNumber.text.toString());
        SharedDatabase().setCatID("1");
        SharedDatabase().setAreaID("1");
        Navigator.of(context)
            .pushReplacement(FadeRouteBuilder(page: UserMainScreen()));
      } else {
        SharedDatabase().setLogin(true);
        SharedDatabase().setProfile(false);
        SharedDatabase().setDdone(false);
        Navigator.of(context).pushReplacement(FadeRouteBuilder(
            page: UserProfileScreen(phoneNumber.text.toString())));
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void doctorVerification() async {
    Map<String, dynamic> jsondat = {"mobile": phoneNumber.text.toString()};
    print(jsondat.toString());
    Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.post(Apis().mDoctorLogin,
        headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (!body['error']) {
        SharedDatabase().setLogin(true);
        SharedDatabase().setType("D");
        SharedDatabase().setUserData(body['id']);
        SharedDatabase().setDoctorCategory(body['category']);
        SharedDatabase().setLoaction(body['location']);
        SharedDatabase().setSlots(body['time']);
        SharedDatabase().setProfile(true);
        SharedDatabase().setMobile(phoneNumber.text.toString());
        if (body['category'] && body['location'] && body['time']) {
          SharedDatabase().setDdone(true);
          Navigator.of(context)
              .pushReplacement(FadeRouteBuilder(page: DoctorMainScreen()));
        } else {
          Navigator.of(context).pushReplacement(FadeRouteBuilder(
              page: ProgressProfile(
                  true, body['category'], body['location'], body['time'])));
        }
      } else {
        SharedDatabase().setType("D");
        SharedDatabase().setMobile(phoneNumber.text.toString());
        SharedDatabase().setDoctorCategory(false);
        SharedDatabase().setLoaction(false);
        SharedDatabase().setSlots(false);
        SharedDatabase().setProfile(false);
        SharedDatabase().setLogin(true);
        Navigator.of(context).pushReplacement(FadeRouteBuilder(
            page: ProgressProfile(false, false, false, false)));
        setState(() {
          isLoading = false;
        });
      }
    }
  }
/*
  void _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: _smsCode,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user; // ...
      final FirebaseUser currentUser = await _auth.currentUser();
      if (user.uid == currentUser.uid) {
        assert(user.uid == currentUser.uid);
        setState(() {
          if (user != null) {
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacement(FadeRouteBuilder(page: MainScreen()));
          } else {
            setState(() {
              this.verifyStatus = "Invailed OTP";
              isVerifing = false;
            });
          }
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        this.verifyStatus = "Invalid OTP";
        isVerifing = false;
      });
    }
  }

  //  code of  verify phone number
  void _verifyPhoneNumber() async {
    setState(() {});
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        isSending = false;
        this.verifyStatus = "Invalide phone number";
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      setState(() {
        isSending = false;
        smsCodeDialog(context);
      });

      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: '+91' + phoneNumber.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
  */
}
