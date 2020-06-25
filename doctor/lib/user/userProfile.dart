import 'dart:convert';
import 'dart:io';
import 'package:doctor/anim/scale_anim.dart';
import 'package:doctor/database/apis.dart';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:doctor/user/userFrist.dart';
import 'package:http/http.dart' as http;
import 'package:doctor/helper/ImageHelper.dart';
import 'package:doctor/validation/formValidation.dart';
import 'package:flutter/material.dart';
import 'package:doctor/style/colors.dart' as CustomColors;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UserProfileScreen extends StatefulWidget {
  final String phoneNumber;
  UserProfileScreen(this.phoneNumber, {Key key}) : super(key: key);
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isLoading = false;
  var uuid = Uuid();
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  File _imageFile;

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Profile"),
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
                      margin: EdgeInsets.only(top: 20.0, bottom: 15.0),
                      child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 50.0,
                          backgroundImage: _imageFile == null
                              ? AssetImage('assets/icons/default.png')
                              : FileImage(_imageFile),
                          child: InkWell(
                              onTap: () => _pickImage(ImageSource.gallery),
                              child: Icon(
                                Icons.camera_alt,
                                size: 30.0,
                                color: Colors.black87,
                              ))),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      child: TextFormField(
                        validator: Validate().validateStringText,
                        controller: _name,
                        decoration: InputDecoration(
                          hintText: "Username",
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                          filled: true,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      child: TextFormField(
                        validator: Validate().validateStringText,
                        controller: _email,
                        decoration: InputDecoration(
                          hintText: "E mail",
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                          filled: true,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      child: TextFormField(
                        validator: Validate().validateStringText,
                        controller: _address,
                        decoration: InputDecoration(
                          hintText: "Complete address",
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                          filled: true,
                        ),
                      ),
                    ),
                    Container(
                        child: RaisedButton(
                      color: CustomColors.Colors.primaryColor,
                      onPressed: () async {
                        List<int> imageBytesorg = await ImageHelper()
                            .compressImage(_imageFile.readAsBytesSync());
                        String userImage = base64Encode(imageBytesorg);
                        if (_name.text.length > 0 &&
                            _address.text.length > 0 &&
                            _email.text.length > 0 &&
                            userImage.length > 0) {
                          setState(() {
                            isLoading = true;
                          });
                          completeProfile(uuid.v1().toString(), _name.text,
                              _address.text, _email.text, userImage);
                        }
                      },
                      child: Text(
                        "COMPLETE NOW",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                  ],
                ),
              ),
            ),
    );
  }

  void completeProfile(String id, String name, String address, String email,
      String image) async {
    Map<String, dynamic> jsondat = {
      "user_id": id,
      "name": name,
      "address": address,
      "mobile": widget.phoneNumber,
      "email": email,
      "image": image,
      "token": "123456789"
    };
    print(jsondat.toString());
    Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.post(Apis().mUserProfile,
        headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (!body['error']) {
        SharedDatabase().setType("P");
        SharedDatabase().setUserData(id);
        SharedDatabase().setProfile(true);
        SharedDatabase().setDdone(true);
        SharedDatabase().setCatID("1");
        SharedDatabase().setAreaID("1");
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

