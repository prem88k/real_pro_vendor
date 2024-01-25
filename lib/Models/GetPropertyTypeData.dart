class GetPropertyTypeData {
  bool? success;
  List<PropertyTypeList>? data;

  GetPropertyTypeData({this.success, this.data});

  GetPropertyTypeData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <PropertyTypeList>[];
      json['data'].forEach((v) {
        data!.add(new PropertyTypeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropertyTypeList {
  int? id;
  String? propertyName;
  String? createdAt;
  String? updatedAt;

  PropertyTypeList({this.id, this.propertyName, this.createdAt, this.updatedAt});

  PropertyTypeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyName = json['property_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_name'] = this.propertyName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}