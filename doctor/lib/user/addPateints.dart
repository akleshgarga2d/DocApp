import 'dart:convert';

import 'package:doctor/database/apis.dart';
import 'package:doctor/validation/formValidation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class AddPateints extends StatefulWidget {
  final String userID;
  AddPateints(this.userID, {Key key}) : super(key: key);
  @override
  _AddPateintsState createState() => _AddPateintsState();
}

class _AddPateintsState extends State<AddPateints> {
  var uuid = Uuid();
  bool isLoading = false;
  TextEditingController _name = new TextEditingController();
  TextEditingController _age = new TextEditingController();
  String gender;
  var genderList = ['Male', 'Female', 'Other'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Pateints"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_name.text.length > 0 && _age.text.length > 0 && gender.length>0) {
              setState(() {
                isLoading = true;
              });
              _uploadPatient(uuid.v1().toString(), _name.text.toString(),
                  _age.text.toString(), gender, widget.userID);
            }
          },
          label: Text("ADD NOW")),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    child: TextFormField(
                      validator: Validate().validateStringText,
                      controller: _name,
                      decoration: InputDecoration(
                        hintText: "Patient Name",
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
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    child: TextFormField(
                      validator: Validate().validateStringText,
                      controller: _age,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Patient Age",
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: InputBorder.none,
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                    child: Text("Select Gender"),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 5.0, bottom: 10.0, left: 10.0, right: 10.0),
                    child: DropdownButton(
                      hint: Text(
                        "Select Gender",
                        style: TextStyle(color: Colors.grey),
                      ),
                      items: genderList.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item),
                          value: item.toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          gender = newVal;
                        });
                      },
                      value: gender,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _uploadPatient(
      String id, String name, String age, String gender, String uid) async {
    Map<String, dynamic> jsondat = {
      "id": id,
      "name": name,
      "age": age,
      "gender": gender,
      "user_id": uid
    };
    print(jsondat.toString());
    Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.post(Apis().mAddPatients,
        headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (!body['error']) {
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
