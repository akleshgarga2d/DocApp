class DoctorRequestsPojo {
  int id;
  String date;
  String time;
  String status;
  String comments;
  String pname;
  String age;
  String gender;
  String name;
  String mobile;
  String image;
  String token;

  DoctorRequestsPojo(
      {this.id,
      this.date,
      this.time,
      this.status,
      this.comments,
      this.pname,
      this.age,
      this.gender,
      this.name,
      this.mobile,
      this.image,
      this.token});

  DoctorRequestsPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    comments = json['comments'];
    pname = json['pname'];
    age = json['age'];
    gender = json['gender'];
    name = json['name'];
    mobile = json['mobile'];
    image = json['image'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['comments'] = this.comments;
    data['pname'] = this.pname;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['image'] = this.image;
    data['token'] = this.token;
    return data;
  }
}
