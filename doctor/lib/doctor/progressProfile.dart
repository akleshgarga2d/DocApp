import 'dart:io';
import 'package:doctor/anim/scale_anim.dart';
import 'package:doctor/comman/state.dart';
import 'package:doctor/database/sharedPreferences.dart';
import 'package:doctor/doctor/docFrist.dart';
import 'package:doctor/doctor/profilePages/category.dart';
import 'package:doctor/doctor/profilePages/profile.dart';
import 'package:doctor/doctor/profilePages/timeslots.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProgressProfile extends StatefulWidget {
  final bool mProfile;
  final bool mcategory;
  final bool mLocation;
  final bool mTime;
  ProgressProfile(this.mProfile, this.mcategory, this.mLocation, this.mTime,
      {Key key})
      : super(key: key);
  @override
  _ProgressProfileState createState() => _ProgressProfileState();
}

class _ProgressProfileState extends State<ProgressProfile> {
  int _currentstep = 0;
  var uuid = Uuid();
  String mID;
  String mobile;
  void _movetonext() async {
    if (_currentstep == 0) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoctorProfile()),
      );
      if (result != null) {
        if (result) {
          setState(() {
            fetchMobile();
            _currentstep++;
            SharedDatabase().setProfile(true);
          });
        }
      }
    } else if (_currentstep == 1) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChooseCategory(mID)),
      );
      if (result != null) {
        if (result) {
          setState(() {
            _currentstep++;
            SharedDatabase().setDoctorCategory(true);
          });
        }
      }
    } else if (_currentstep == 2) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StateListScreen(mID,1)),
      );
      if (result != null) {
        if (result) {
          setState(() {
            _currentstep++;
            SharedDatabase().setLoaction(true);
          });
        }
      }
    } else if (_currentstep == 3) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TimeSlots(mID)),
      );
      if (result != null) {
        if (result) {
          SharedDatabase().setSlots(true);
          SharedDatabase().setDdone(true);
          setState(() {
            Navigator.of(context)
                .push(FadeRouteBuilder(page: DoctorMainScreen()));
          });
        }
      }
    }
  }

  void fetchMobile() async {
    String mob = await SharedDatabase().getMobile();
    String id = await SharedDatabase().getUserID();
    setState(() {
      mobile = mob;
      mID = id;
    });
  }

  void _progress() {
    if (widget.mProfile) {
      _currentstep++;
      if (widget.mcategory) {
        _currentstep++;

        if (widget.mLocation) {
          _currentstep++;
          if (widget.mTime) {
            _currentstep++;
          }
        }
      }
    }
  }

  void _movetostart() {
    _popupDialog(context);
  }

  @override
  void initState() {
    fetchMobile();
    _progress();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
        return true;
      },
      child: Scaffold(
          appBar: new AppBar(
            title: new Text("Complete Profile"),
          ),
          body: SingleChildScrollView(
            child: new Container(
                //  height: MediaQuery.of(context).size.height,
                child: new Stepper(
              steps: _getSteps(context),
              type: StepperType.vertical,
              currentStep: _currentstep,
              onStepContinue: _movetonext,
              onStepCancel: _movetostart,
              //     onStepTapped: _showcontent,
            )),
          )),
    );
  }

  List<Step> spr = <Step>[];
  List<Step> _getSteps(BuildContext context) {
    spr = <Step>[
      Step(
          title: const Text('Complete Profile'),
          subtitle: widget.mProfile ? Text('Completed') : Text("Not completed"),
          content: const Text('Click continue to complete your profile'),
          state: _getState(1),
          isActive: !widget.mProfile),
      Step(
          title: const Text('Select Category'),
          subtitle:
              widget.mcategory ? Text('Completed') : Text("Not completed"),
          content: const Text('Click continue to select category'),
          state: _getState(2),
          isActive: !widget.mcategory),
      Step(
          title: const Text('Select Location'),
          subtitle:
              widget.mLocation ? Text('Completed') : Text("Not completed"),
          content: const Text('Click continue to choose your working areas'),
          state: _getState(3),
          isActive: !widget.mLocation),
      Step(
          title: const Text('Create Time Slots'),
          subtitle: widget.mTime ? Text('Completed') : Text("Not completed"),
          content: const Text('Click continue to create your time slots'),
          state: _getState(4),
          isActive: !widget.mTime),
    ];
    return spr;
  }

  StepState _getState(int i) {
    if (_currentstep >= i)
      return StepState.complete;
    else
      return StepState.indexed;
  }

  void _popupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation '),
            content: Text('Do you really want to go back'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('YES')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('NO')),
            ],
          );
        });
  }
}
