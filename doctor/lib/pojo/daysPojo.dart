class DayPojo {
  String dayName;
  String dayId;

  DayPojo({this.dayName, this.dayId});

  DayPojo.fromJson(Map<String, dynamic> json) {
    dayName = json['day_name'];
    dayId = json['day_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day_name'] = this.dayName;
    data['day_id'] = this.dayId;
    return data;
  }
}