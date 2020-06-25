class TimePojo {
  int id;
  String time;
  String doctorId;

  TimePojo({this.id, this.time, this.doctorId});

  TimePojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    doctorId = json['doctor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['doctor_id'] = this.doctorId;
    return data;
  }
}