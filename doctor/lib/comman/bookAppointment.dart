import 'dart:convert';
import 'package:doctor/anim/scale_anim.dart';
import 'package:doctor/comman/choosePatient.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:doctor/database/apis.dart';
import 'package:doctor/pojo/Doctor.dart';
import 'package:doctor/pojo/daysPojo.dart';
import 'package:doctor/pojo/mDoctorTime.dart';
import 'package:doctor/style/style.dart';
import 'package:flutter/material.dart';
import 'package:doctor/style/colors.dart' as CustomColors;
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';

class BookApointment extends StatefulWidget {
  final DoctorPojo doctorPojo;
  BookApointment(this.doctorPojo, {Key key}) : super(key: key);

  @override
  _BookApointmentState createState() => _BookApointmentState();
}

class _BookApointmentState extends State<BookApointment> {
  DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();
  var dayFormat = DateFormat('dd/MM/yyyy');
  var timeSlots = List<TimePojo>();
  var dayList = List<DayPojo>();
  bool isLoading = true;
  bool isFound = false;
  int _selection = 100;

  selectTime(int timeSelected) {
    setState(() {
      _selection = timeSelected;
    });
  }

  @override
  void initState() {
    _fetchDayList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 5.0, top: 10.0),
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundColor: CustomColors.Colors.primaryColor,
                    backgroundImage: NetworkImage(
                      Apis().imagesUrl + widget.doctorPojo.image,
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          widget.doctorPojo.name,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19.0),
                        ),
                      ),
                      Container(
                          child: widget.doctorPojo.availability == 'A'
                              ? Text(
                                  "Available",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: CustomColors.Colors.primaryColor),
                                )
                              : Text("Not available")),
                      Container(
                          child: Text(
                        "Appointment Charges : " +
                            "₹ " +
                            widget.doctorPojo.normalCharges,
                        maxLines: 1,
                        style: TextStyle(
                            color: CustomColors.Colors.primaryColor,
                            fontWeight: FontWeight.bold),
                      )),
                      /* Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(child: _openDesign()),
                            Expanded(child: _submitDesign(doctorList[index]))
                          ],
                        ),
                      )*/
                    ],
                  ),
                ))
              ],
            ),
          ),
          Style().spacer(),
          _specialist(),
          Style().spacer(),
          _calendar(),
          Container(
            height: 15.0,
          ),
          Style().spacer(),
          isLoading
              ? Container(
                  padding: EdgeInsets.all(30.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : isFound
                  ? Container(
                      padding: EdgeInsets.all(30.0),
                      child: Center(
                        child: Text(
                            "Time Slots Not available on ${dayFormat.format(_selectedValue.toLocal())}"),
                      ),
                    )
                  : _fetchTimeList(),
        ],
      ),
    );
  }

  Widget _specialist() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(left: 12.0, top: 7.0, bottom: 7.0, right: 12.0),
            child: Text(
              "Specialist",
              style: _headingStyle(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 15.0),
            child: _buildGenreSection(),
          )
        ],
      ),
    );
  }

  _headingStyle() {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0);
  }

  _buildGenreSection() {
    return Container(
      height: 50.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          scrollDirection: Axis.horizontal,
          itemCount: widget.doctorPojo.category.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                  onTap: () async {},
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '${widget.doctorPojo.category[index].categoryName}',
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

  _calendar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(left: 12.0, top: 7.0, bottom: 3.0, right: 12.0),
          child: Text(
            "Appointment",
            style: _headingStyle(),
          ),
        ),
        Container(
            padding: EdgeInsets.only(left: 12.0, bottom: 7.0, right: 12.0),
            child: Text(
                "Date : " + "${dayFormat.format(_selectedValue.toLocal())}")),
        Container(
          padding:
              EdgeInsets.only(left: 12.0, top: 7.0, bottom: 3.0, right: 12.0),
          child: DatePicker(
            DateTime.now().add(Duration(days: 0)),
            width: 60,
            height: 80,
            controller: _controller,
            daysCount: 7,
            dateTextStyle: TextStyle(fontSize: 15.0),
            dayTextStyle: TextStyle(fontSize: 10.0),
            monthTextStyle: TextStyle(fontSize: 10.0),
            initialSelectedDate: DateTime.now(),
            selectionColor: Colors.blue,
            selectedTextColor: Colors.white,
            onDateChange: (date) {
              setState(() {
                _selectedValue = date;
                isLoading = true;
                _selection = 100;
              });
              if (dayList.length > 0) {
                for (int i = 0; i < dayList.length; i++) {
                  if (dayList[i].dayName == dateFormatter(date)) {
                    _fetchTimeSlots();
                    break;
                  }
                  if (i + 1 == dayList.length) {
                    setState(() {
                      isLoading = false;
                      isFound = true;
                    });
                  }
                  print(dayList[i].dayName.toString() + dateFormatter(date));
                }
              }
              print(dateFormatter(date));
            },
          ),
        ),
      ],
    );
  }

  _fetchTimeList() {
    return Container(
      margin: EdgeInsets.all(12.0),
      child: Tags(
        alignment: WrapAlignment.start,
        columns: 4,
        itemCount: timeSlots.length,
        itemBuilder: (int index) {
          return Container(
            color: _selection == index ? Colors.blue : Colors.white70,
            child: InkWell(
              onTap: () {
                selectTime(index);
                Navigator.of(context).push(FadeRouteBuilder(
                    page: ChoosePatientAppointment(
                        "${dayFormat.format(_selectedValue.toLocal())}",
                        timeSlots[index].time,
                        widget.doctorPojo.doctorId)));
                //     Navigator.of(context)
                //         .push(FadeRouteBuilder(page: DoctorProfile(doctor)));
              },
              child: Container(
                padding: EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 15.0, bottom: 15.0),
                child: Text(timeSlots[index].time,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: _selection == index
                            ? CustomColors.Colors.white
                            : CustomColors.Colors.primaryColor)),
              ),
            ),
          );
        },
      ),
    );
  }

  String dateFormatter(DateTime date) {
    dynamic dayData =
        '{ "1" : "Mon", "2" : "Tue", "3" : "Wed", "4" : "Thur", "5" : "Fri", "6" : "Sat", "7" : "Sun" }';

    return json.decode(dayData)['${date.weekday}'];
  }

  _fetchDayList() async {
    Map<String, dynamic> jsondat = {"doctor_id": widget.doctorPojo.doctorId};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Apis().mFetchDayList,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        dayList = (json.decode(response.body) as List)
            .map((data) => new DayPojo.fromJson(data))
            .toList();
        print(dayList.length);
        if (dayList.length > 0) {
          isLoading = false;
          isFound = false;
          if (dayList.length > 0) {
            for (int i = 0; i < dayList.length; i++) {
              if (dayList[i].dayName == dateFormatter(DateTime.now())) {
                _fetchTimeSlots();
                break;
              }
              if (i + 1 == dayList.length) {
                setState(() {
                  isLoading = false;
                  isFound = true;
                });
              }
              //   print(dayList[i].dayName.toString() + dateFormatter(date));
            }
          }
        } else {
          isFound = true;
          isLoading = false;
        }
      });
    }
  }

  _fetchTimeSlots() async {
    timeSlots.clear();
    Map<String, dynamic> jsondat = {
      "date": "${dayFormat.format(_selectedValue.toLocal())}",
      "doctor_id": widget.doctorPojo.doctorId
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Apis().mFetchTimeSlots,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        timeSlots = (json.decode(response.body) as List)
            .map((data) => new TimePojo.fromJson(data))
            .toList();
        if (timeSlots.length > 0) {
          isLoading = false;
          isFound = false;
        } else {
          isFound = true;
          isLoading = false;
        }
      });
    }
  }
}
