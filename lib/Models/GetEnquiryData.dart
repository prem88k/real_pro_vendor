class GetEnquiryData {
  bool? success;
  List<EnquiryList>? data;

  GetEnquiryData({this.success, this.data});

  GetEnquiryData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <EnquiryList>[];
      json['data'].forEach((v) {
        data!.add(new EnquiryList.fromJson(v));
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

class EnquiryList {
  String? type;
  List<User>? user;

  EnquiryList({this.type, this.user});

  EnquiryList.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? location;
  String? mobileNumber;
  String? image;
  Null? coverPhoto;
  String? description;
  String? uid;

  User(
      {this.id,
        this.name,
        this.email,
        this.location,
        this.mobileNumber,
        this.image,
        this.coverPhoto,
        this.description,
        this.uid});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    location = json['location'];
    mobileNumber = json['mobile_number'];
    image = json['image'];
    coverPhoto = json['cover_photo'];
    description = json['description'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['location'] = this.location;
    data['mobile_number'] = this.mobileNumber;
    data['image'] = this.image;
    data['cover_photo'] = this.coverPhoto;
    data['description'] = this.description;
    data['uid'] = this.uid;
    return data;
  }
}