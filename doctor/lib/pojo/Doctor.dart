class DoctorPojo {
  String doctorId;
  String availability;
  String normalCharges;
  String image;
  String name;
  String details;
  List<Category> category;

  DoctorPojo(
      {this.doctorId,
      this.availability,
      this.normalCharges,
      this.image,
      this.name,
      this.details,
      this.category});

  DoctorPojo.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'];
    availability = json['availability'];
    normalCharges = json['normal_charges'];
    image = json['image'];
    name = json['name'];
    details = json['details'];
    if (json['category'] != null) {
      category = new List<Category>();
      json['category'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_id'] = this.doctorId;
    data['availability'] = this.availability;
    data['normal_charges'] = this.normalCharges;
    data['image'] = this.image;
    data['name'] = this.name;
    data['details'] = this.details;
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String categoryName;
  String categoryId;

  Category({this.categoryName, this.categoryId});

  Category.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_name'] = this.categoryName;
    data['category_id'] = this.categoryId;
    return data;
  }
}
