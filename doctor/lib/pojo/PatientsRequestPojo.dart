class PatientsRequestPojo {
  String date;
  String time;
  String status;
  String comments;
  String name;
  String image;
  String details;
  String pname;
  String age;

  PatientsRequestPojo(
      {this.date,
      this.time,
      this.status,
      this.comments,
      this.name,
      this.image,
      this.details,
      this.pname,
      this.age});

  PatientsRequestPojo.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    status = json['status'];
    comments = json['comments'];
    name = json['name'];
    image = json['image'];
    details = json['details'];
    pname = json['pname'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['comments'] = this.comments;
    data['name'] = this.name;
    data['image'] = this.image;
    data['details'] = this.details;
    data['pname'] = this.pname;
    data['age'] = this.age;
    return data;
  }
}