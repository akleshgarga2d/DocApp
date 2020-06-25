import 'package:doctor/anim/scale_anim.dart';
import 'package:doctor/comman/bookAppointment.dart';
import 'package:doctor/database/apis.dart';
import 'package:doctor/doctor/profilePages/profile.dart';
import 'package:doctor/pojo/Doctor.dart';
import 'package:doctor/style/style.dart';
import 'package:flutter/material.dart';
import 'package:doctor/style/colors.dart' as CustomColors;

class DoctorProfile extends StatefulWidget {
  final DoctorPojo doctorPojo;
  DoctorProfile(this.doctorPojo, {Key key}) : super(key: key);
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
                FadeRouteBuilder(page: BookApointment(widget.doctorPojo)));
          },
          icon: Icon(Icons.schedule),
          label: Text("BOOK APPOINTMENT")),
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
          _about(),
          Style().spacer(),
          _specialist(),
          Style().spacer(),
          _address()
        ],
      ),
    );
  }

  Widget _about() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(left: 12.0, top: 7.0, bottom: 7.0, right: 12.0),
            child: Text(
              "Doctor Details",
              style: _headingStyle(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 12.0, bottom: 15.0, right: 12.0),
            child: Text(
              widget.doctorPojo.details,
              style: TextStyle(fontSize: 15.0),
            ),
          )
        ],
      ),
    );
  }

  _headingStyle() {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0);
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

  Widget _address() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(left: 12.0, top: 7.0, bottom: 7.0, right: 12.0),
            child: Text(
              "Doctor Address",
              style: _headingStyle(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 12.0, bottom: 15.0, right: 12.0),
            child: Text(
              widget.doctorPojo.details,
              style: TextStyle(fontSize: 15.0),
            ),
          )
        ],
      ),
    );
  }
}
