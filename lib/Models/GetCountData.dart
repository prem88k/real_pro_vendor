class GetCountData {
  bool? status;
  int? like;
  int? following;
  int? collect;
  int? views;
  User? user;

  GetCountData(
      {this.status,
        this.like,
        this.following,
        this.collect,
        this.views,
        this.user});

  GetCountData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    like = json['like'];
    following = json['following'];
    collect = json['collect'];
    views = json['views'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['like'] = this.like;
    data['following'] = this.following;
    data['collect'] = this.collect;
    data['views'] = this.views;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  int? productLike;
  int? newFollowers;
  int? comment;
  String? name;
  String? email;
  String? fcm;
  String? deviceType;
  Null? appleId;
  Null? deviceId;
  Null? platform;
  String? role;
  String? countryCode;
  String? mobileNumber;
  String? image;
  String? coverPhoto;
  String? description;
  int? emailVerify;
  String? uid;
  String? agentRef;
  String? agentBrn;
  String? dldNo;
  String? brokerOrn;
  String? companyName;
  String? companyAddress;
  String? aboutCompany;
  String? language;
  String? experience;
  String? companyLogo;
  String? nationality;
  String? agencyName;
  String? location;
  int? socialLogin;

  User(
      {this.id,
        this.productLike,
        this.newFollowers,
        this.comment,
        this.name,
        this.email,
        this.fcm,
        this.deviceType,
        this.appleId,
        this.deviceId,
        this.platform,
        this.role,
        this.countryCode,
        this.mobileNumber,
        this.image,
        this.coverPhoto,
        this.description,
        this.emailVerify,
        this.uid,
        this.agentRef,
        this.agentBrn,
        this.dldNo,
        this.brokerOrn,
        this.companyName,
        this.companyAddress,
        this.aboutCompany,
        this.language,
        this.experience,
        this.companyLogo,
        this.nationality,
        this.agencyName,
        this.location,
        this.socialLogin});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productLike = json['product_like'];
    newFollowers = json['new_followers'];
    comment = json['comment'];
    name = json['name'];
    email = json['email'];
    fcm = json['fcm'];
    deviceType = json['device_type'];
    appleId = json['apple_id'];
    deviceId = json['device_id'];
    platform = json['platform'];
    role = json['role'];
    countryCode = json['country_code'];
    mobileNumber = json['mobile_number'];
    image = json['image'];
    coverPhoto = json['cover_photo'];
    description = json['description'];
    emailVerify = json['email_verify'];
    uid = json['uid'];
    agentRef = json['agent_ref'];
    agentBrn = json['agent_brn'];
    dldNo = json['dld_no'];
    brokerOrn = json['broker_orn'];
    companyName = json['company_name'];
    companyAddress = json['company_address'];
    aboutCompany = json['about_company'];
    language = json['language'];
    experience = json['experience'];
    companyLogo = json['company_logo'];
    nationality = json['nationality'];
    agencyName = json['agency_name'];
    location = json['location'];
    socialLogin = json['social_login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_like'] = this.productLike;
    data['new_followers'] = this.newFollowers;
    data['comment'] = this.comment;
    data['name'] = this.name;
    data['email'] = this.email;
    data['fcm'] = this.fcm;
    data['device_type'] = this.deviceType;
    data['apple_id'] = this.appleId;
    data['device_id'] = this.deviceId;
    data['platform'] = this.platform;
    data['role'] = this.role;
    data['country_code'] = this.countryCode;
    data['mobile_number'] = this.mobileNumber;
    data['image'] = this.image;
    data['cover_photo'] = this.coverPhoto;
    data['description'] = this.description;
    data['email_verify'] = this.emailVerify;
    data['uid'] = this.uid;
    data['agent_ref'] = this.agentRef;
    data['agent_brn'] = this.agentBrn;
    data['dld_no'] = this.dldNo;
    data['broker_orn'] = this.brokerOrn;
    data['company_name'] = this.companyName;
    data['company_address'] = this.companyAddress;
    data['about_company'] = this.aboutCompany;
    data['language'] = this.language;
    data['experience'] = this.experience;
    data['company_logo'] = this.companyLogo;
    data['nationality'] = this.nationality;
    data['agency_name'] = this.agencyName;
    data['location'] = this.location;
    data['social_login'] = this.socialLogin;
    return data;
  }
}