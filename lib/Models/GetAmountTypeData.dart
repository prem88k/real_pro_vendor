class GetAmountTypeData {
  bool? status;
  List<AmountTypeList>? data;

  GetAmountTypeData({this.status, this.data});

  GetAmountTypeData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <AmountTypeList>[];
      json['data'].forEach((v) {
        data!.add(new AmountTypeList.fromJson(v));
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

class AmountTypeList {
  int? id;
  String? name;

  AmountTypeList({this.id, this.name});

  AmountTypeList.fromJson(Map<String, dynamic> json) {
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