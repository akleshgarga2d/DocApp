class MyPatients {
  String id;
  String name;
  String age;
  String gender;
  int requests;

  MyPatients({this.id, this.name, this.age, this.gender, this.requests});

  MyPatients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    gender = json['gender'];
    requests = json['requests'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['requests'] = this.requests;
    return data;
  }
}