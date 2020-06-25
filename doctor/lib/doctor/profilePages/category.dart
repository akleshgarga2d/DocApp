import 'dart:convert';
import 'package:doctor/database/apis.dart';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:doctor/pojo/Category.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChooseCategory extends StatefulWidget {
  final String mID;
  ChooseCategory(this.mID, {Key key}) : super(key: key);
  @override
  _ChooseCategoryState createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  bool isLoading = false;
  var catList = new List<Categories>();
  List<String> selectedList = [];

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Apis().fetchCategory);
    if (response.statusCode == 200) {
      catList = (json.decode(response.body) as List)
          .map((data) => new Categories.fromJson(data))
          .toList();

      setState(() {
        isLoading = false;
      });
      print(response.body);
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: catList.length,
              itemBuilder: (BuildContext context, int index) {
                return new CheckboxListTile(
                  title: new Text(catList[index].categoryName),
                  onChanged: (bool value) {
                    setState(() {
                      if (value) {
                        selectedList.add(catList[index].categoryId);
                      } else {
                        selectedList.remove(catList[index].categoryId);
                      }
                    });
                  },
                  value: selectedList.contains(catList[index].categoryId),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () async {
            print(selectedList);
            if (selectedList.length != 0) {
              _submitCategory(selectedList, widget.mID);
            }
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Text('Lets get started'),
        ),
      ),
    );
  }

  void _submitCategory(List category, String id) async {
    Map<String, dynamic> jsondat = {"value": category, "doctor_id": id};
    print(jsondat.toString());
    Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.post(Apis().mSubmitCategory,
        headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (!body['error']) {
        SharedDatabase().setDoctorCategory(true);
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
