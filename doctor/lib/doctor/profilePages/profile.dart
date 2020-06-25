import 'dart:convert';
import 'dart:io';
import 'package:doctor/database/apis.dart';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:http/http.dart' as http;
import 'package:doctor/helper/ImageHelper.dart';
import 'package:doctor/validation/formValidation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class DoctorProfile extends StatefulWidget {
  DoctorProfile({Key key}) : super(key: key);
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  var uuid = Uuid();
  TextEditingController _name = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _details = new TextEditingController();
  TextEditingController _normal_charges = new TextEditingController();
  TextEditingController _emergency_charges = new TextEditingController();
  String hasSubcategory = "1";
  File _imageFile;
  bool isLoading = false;
  String mobile;
//  bool isChecked = false;

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = selected;
    });
  }

  void fetchMobile() async {
    String mob = await SharedDatabase().getMobile();
    setState(() {
      mobile = mob;
    });
  }

  @override
  void initState() {
    fetchMobile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          hintText: "Doctor name",
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
                          hintText: "Doctor address",
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
                        controller: _details,
                        decoration: InputDecoration(
                          hintText: "Doctor about",
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
                        controller: _normal_charges,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Normal charges",
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
                        controller: _emergency_charges,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Emergency charges",
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                          filled: true,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
                      child: RaisedButton(
                          onPressed: () async {
                            List<int> imageBytesorg = await ImageHelper()
                                .compressImage(_imageFile.readAsBytesSync());
                            String userImage = base64Encode(imageBytesorg);
                            if (_name.text.length > 0 &&
                                userImage.length > 0 &&
                                _details.text.length > 0 &&
                                _address.text.length > 0 &&
                                _normal_charges.text.length > 0 &&
                                _emergency_charges.text.length > 0) {
                              setState(() {
                                isLoading = true;
                              });
                              completeProfile(
                                  uuid.v1().toString(),
                                  _name.text.toString(),
                                  _address.text.toString(),
                                  mobile,
                                  _details.text.toString(),
                                  _normal_charges.text.toString(),
                                  _emergency_charges.text.toString(),
                                  userImage);
                            }
                          },
                          child: Text("COMPLETE PROFILE NOW")),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void completeProfile(String id, String name, String address, String mobile,
      String details, String normal, String emer, String image) async {
    Map<String, dynamic> jsondat = {
      "doctor_id": id,
      "name": name,
      "address": address,
      "mobile": mobile,
      "details": details,
      "availability": "N",
      "normal_charges": normal,
      "emergency_charges": emer,
      "image": image,
      "token": "99261311131478596321"
    };
    print(jsondat.toString());
    Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.post(Apis().mDoctorProfile,
        headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body.toString());
      if (!body['error']) {
        SharedDatabase().setType("D");
        SharedDatabase().setUserData(id);
        SharedDatabase().setProfile(true);
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
