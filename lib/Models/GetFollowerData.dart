class GetFollowerData {
  bool? status;
  List<FollowerList>? data;

  GetFollowerData({this.status, this.data});

  GetFollowerData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <FollowerList>[];
      json['data'].forEach((v) {
        data!.add(new FollowerList.fromJson(v));
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

class FollowerList {
  int? id;
  String? name;
  String? image;
  bool? isFollow;
  bool? followed;
  String? createdAt;

  FollowerList(
      {this.id,
        this.name,
        this.image,
        this.isFollow,
        this.followed,
        this.createdAt});

  FollowerList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    isFollow = json['is_follow'];
    followed = json['followed'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['is_follow'] = this.isFollow;
    data['followed'] = this.followed;
    data['created_at'] = this.createdAt;
    return data;
  }
}