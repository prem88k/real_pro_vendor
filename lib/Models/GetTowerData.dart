class GetTowerData {
  bool? success;
  List<TowerList>? data;

  GetTowerData({this.success, this.data});

  GetTowerData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <TowerList>[];
      json['data'].forEach((v) {
        data!.add(new TowerList.fromJson(v));
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

class TowerList {
  int? id;
  int? areaId;
  String? towerName;
  String? createdAt;
  String? updatedAt;

  TowerList({this.id, this.areaId, this.towerName, this.createdAt, this.updatedAt});

  TowerList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    areaId = json['area_id'];
    towerName = json['tower_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['area_id'] = this.areaId;
    data['tower_name'] = this.towerName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}