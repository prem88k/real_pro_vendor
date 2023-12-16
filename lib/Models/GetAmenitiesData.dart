class GetAmenitiesData {
  bool? status;
  List<AmenitiesList>? data;

  GetAmenitiesData({this.status, this.data});

  GetAmenitiesData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <AmenitiesList>[];
      json['data'].forEach((v) {
        data!.add(new AmenitiesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AmenitiesList {
  int? id;
  String? name;

  AmenitiesList({this.id, this.name});

  AmenitiesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}