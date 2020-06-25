class Area {
  int id;
  String areaName;

  Area({this.id, this.areaName});

  Area.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    areaName = json['area_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['area_name'] = this.areaName;
    return data;
  }
}