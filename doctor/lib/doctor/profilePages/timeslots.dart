import 'dart:convert';
import 'package:doctor/database/apis.dart';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TimeSlots extends StatefulWidget {
  final String mID;
  TimeSlots(this.mID, {Key key}) : super(key: key);
  @override
  _TimeSlotsState createState() => _TimeSlotsState();
}

class _TimeSlotsState extends State<TimeSlots> {
  final days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
  final number = ['1', '2', '3', '4', '5', '6', '7'];
  List<String> selectedDays = [];
  List<String> selectedNumber = [];
  List<String> selectedTime = [];
  List<String> timeSlots = [];
  bool isDaySelected = false;
  bool isLoading = false;
  final startTime = TimeOfDay(hour: 9, minute: 0);
  final endTime = TimeOfDay(hour: 22, minute: 0);
  final step = Duration(minutes: 60);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Days & Time Slots"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isDaySelected
              ? _mTimeSlots()
              : ListView.builder(
                  itemCount: days.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new CheckboxListTile(
                      title: new Text(days[index]),
                      onChanged: (bool value) {
                        setState(() {
                          if (value) {
                            selectedDays.add(days[index]);
                            selectedNumber.add(number[index]);
                          } else {
                            selectedDays.remove(days[index]);
                            selectedNumber.remove(number[index]);
                          }
                        });
                      },
                      value: selectedDays.contains(days[index]),
                    );
                  },
                ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () async {
            if (isDaySelected) {
              if (selectedTime.length > 0) {
                setState(() {
                  isLoading = true;
                });
                _submitTime(selectedTime, widget.mID);
              }
            } else {
              print(selectedNumber);
              if (selectedDays.length != 0) {
                setState(() {
                  isLoading = true;
                });
                _submitDays(selectedDays, selectedNumber, widget.mID);
              }
            }
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: isDaySelected
              ? Text("Submit".toUpperCase())
              : Text('Create Time slots'.toUpperCase()),
        ),
      ),
    );
  }

  void _submitTime(List time, String id) async {
    Map<String, dynamic> jsondat = {"time": time, "doctor_id": id};
    print(jsondat.toString());
    Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.post(Apis().mSubmitTime,
        headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (!body['error']) {
        SharedDatabase().setSlots(true);
        Navigator.of(context).pop(true);
      } else {}
      setState(() {
        isLoading = false;
      });
    }
  }

  void _submitDays(List day, List numb, String id) async {
    Map<String, dynamic> jsondat = {
      "day_name": days,
      "day_id": numb,
      "doctor_id": id
    };
    print(jsondat.toString());
    Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.post(Apis().mSubmitDays,
        headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (!body['error']) {
        final times = getTimes(startTime, endTime, step)
            .map((tod) => tod.format(context))
            .toList();
        setState(() {
          timeSlots = times;
        });
        setState(() {
          isDaySelected = true;
        });
      } else {}

      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _mTimeSlots() {
    return ListView.builder(
      itemCount: timeSlots.length,
      itemBuilder: (BuildContext context, int index) {
        return new CheckboxListTile(
          title: new Text(timeSlots[index]),
          onChanged: (bool value) {
            setState(() {
              if (value) {
                selectedTime.add(timeSlots[index]);
              } else {
                selectedTime.remove(timeSlots[index]);
              }
            });
          },
          value: selectedTime.contains(timeSlots[index]),
        );
      },
    );
  }

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }
}
