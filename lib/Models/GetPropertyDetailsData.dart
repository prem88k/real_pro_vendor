class GetPropertyDetails {
  bool? status;
  List<PropertyDetails>? data;

  GetPropertyDetails({this.status, this.data});

  GetPropertyDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PropertyDetails>[];
      json['data'].forEach((v) {
        data!.add(new PropertyDetails.fromJson(v));
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

class PropertyDetails {
  int? id;
  int? userId;
  int? categoryId;
  String? propertyName;
  int? price;
  String? propertyAddress;
  String? location;
  int? bedroomCount;
  int? kitchenCount;
  int? bathroomCount;
  String? description;
  List<String>? vilaFeature;
  String? type;
  int? propertySize;
  String? lat;
  String? lang;
  String? purpose;
  String? refNum;
  String? addon;
  List<Amenities>? amenities;
  String? city;
  String? area;
  String? tower;
  String? propertyType;
  int? cityId;
  int? areaId;
  int? towerId;
  int? propertyTypeId;
  String? floor;
  int? isverified;
  String? thamblain;
  List<ImagesList>? images;
  String? privacyPolicy;
  String? createdAt;
  int? shopId;
  CreatedBy? createdBy;
  Category? category;
  List<Comment>? comment;
  int? totalcomment;
  int? like;
  int? isPost;
  bool? liked;
  int? view;
  int? salePrice;
  bool? collected;

  PropertyDetails(
      {this.id,
        this.userId,
        this.categoryId,
        this.propertyName,
        this.price,
        this.propertyAddress,
        this.location,
        this.bedroomCount,
        this.kitchenCount,
        this.bathroomCount,
        this.description,
        this.vilaFeature,
        this.type,
        this.propertySize,
        this.lat,
        this.lang,
        this.purpose,
        this.refNum,
        this.addon,
        this.amenities,
        this.city,
        this.area,
        this.tower,
        this.propertyType,
        this.cityId,
        this.areaId,
        this.towerId,
        this.propertyTypeId,
        this.floor,
        this.isverified,
        this.thamblain,
        this.images,
        this.privacyPolicy,
        this.createdAt,
        this.shopId,
        this.createdBy,
        this.category,
        this.comment,
        this.totalcomment,
        this.like,
        this.isPost,
        this.liked,
        this.view,
        this.salePrice,
        this.collected});

  PropertyDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    propertyName = json['property_name'];
    price = json['price'];
    propertyAddress = json['property_address'];
    location = json['location'];
    bedroomCount = json['bedroom_count'];
    kitchenCount = json['kitchen_count'];
    bathroomCount = json['bathroom_count'];
    description = json['description'];
    vilaFeature = json['vila_feature'].cast<String>();
    type = json['type'];
    propertySize = json['property_size'];
    lat = json['lat'];
    lang = json['lang'];
    purpose = json['purpose'];
    refNum = json['ref_num'];
    addon = json['addon'];
    if (json['amenities'] != null) {
      amenities = <Amenities>[];
      json['amenities'].forEach((v) {
        amenities!.add(new Amenities.fromJson(v));
      });
    }
    city = json['city'];
    area = json['area'];
    tower = json['tower'];
    propertyType = json['property_type'];
    cityId = json['city_id'];
    areaId = json['area-id'];
    towerId = json['tower_id'];
    propertyTypeId = json['property_type_id'];
    floor = json['floor'];
    isverified = json['isverified'];
    thamblain = json['thamblain'];
    if (json['images'] != null) {
      images = <ImagesList>[];
      json['images'].forEach((v) {
        images!.add(new ImagesList.fromJson(v));
      });
    }
    privacyPolicy = json['privacy_policy'];
    createdAt = json['created_at'];
    shopId = json['shop_id'];
    createdBy = json['created_by'] != null
        ? new CreatedBy.fromJson(json['created_by'])
        : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['comment'] != null) {
      comment = <Comment>[];
      json['comment'].forEach((v) {
        comment!.add(new Comment.fromJson(v));
      });
    }
    totalcomment = json['totalcomment'];
    like = json['like'];
    isPost = json['is_post'];
    liked = json['liked'];
    view = json['view'];
    salePrice = json['sale_price'];
    collected = json['collected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['property_name'] = this.propertyName;
    data['price'] = this.price;
    data['property_address'] = this.propertyAddress;
    data['location'] = this.location;
    data['bedroom_count'] = this.bedroomCount;
    data['kitchen_count'] = this.kitchenCount;
    data['bathroom_count'] = this.bathroomCount;
    data['description'] = this.description;
    data['vila_feature'] = this.vilaFeature;
    data['type'] = this.type;
    data['property_size'] = this.propertySize;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['purpose'] = this.purpose;
    data['ref_num'] = this.refNum;
    data['addon'] = this.addon;
    if (this.amenities != null) {
      data['amenities'] = this.amenities!.map((v) => v.toJson()).toList();
    }
    data['city'] = this.city;
    data['area'] = this.area;
    data['tower'] = this.tower;
    data['property_type'] = this.propertyType;
    data['city_id'] = this.cityId;
    data['area-id'] = this.areaId;
    data['tower_id'] = this.towerId;
    data['property_type_id'] = this.propertyTypeId;
    data['floor'] = this.floor;
    data['isverified'] = this.isverified;
    data['thamblain'] = this.thamblain;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['privacy_policy'] = this.privacyPolicy;
    data['created_at'] = this.createdAt;
    data['shop_id'] = this.shopId;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.comment != null) {
      data['comment'] = this.comment!.map((v) => v.toJson()).toList();
    }
    data['totalcomment'] = this.totalcomment;
    data['like'] = this.like;
    data['is_post'] = this.isPost;
    data['liked'] = this.liked;
    data['view'] = this.view;
    data['sale_price'] = this.salePrice;
    data['collected'] = this.collected;
    return data;
  }
}

class Amenities {
  int? id;
  String? name;

  Amenities({this.id, this.name});

  Amenities.fromJson(Map<String, dynamic> json) {
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

class ImagesList {
  int? id;
  int? productId;
  String? image;

  ImagesList({this.id, this.productId, this.image});

  ImagesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['image'] = this.image;
    return data;
  }
}

class CreatedBy {
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
  Null? coverPhoto;
  Null? description;
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
  Null? companyLogo;
  String? nationality;
  String? agencyName;
  String? location;
  int? socialLogin;

  CreatedBy(
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

  CreatedBy.fromJson(Map<String, dynamic> json) {
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

class Category {
  int? id;
  int? propertyId;
  String? name;

  Category({this.id, this.propertyId, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['name'] = this.name;
    return data;
  }
}

class Comment {
  int? id;
  int? userId;
  String? name;
  String? userLogo;
  int? productId;
  String? comment;
  String? createdAt;
  int? countCommentLike;
  int? liked;
  List<CommentReply>? commentReply;

  Comment(
      {this.id,
        this.userId,
        this.name,
        this.userLogo,
        this.productId,
        this.comment,
        this.createdAt,
        this.countCommentLike,
        this.liked,
        this.commentReply});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    userLogo = json['user_logo'];
    productId = json['product_id'];
    comment = json['comment'];
    createdAt = json['created_at'];
    countCommentLike = json['count_comment_like'];
    liked = json['liked'];
    if (json['comment_reply'] != null) {
      commentReply = <CommentReply>[];
      json['comment_reply'].forEach((v) {
        commentReply!.add(new CommentReply.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['user_logo'] = this.userLogo;
    data['product_id'] = this.productId;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['count_comment_like'] = this.countCommentLike;
    data['liked'] = this.liked;
    if (this.commentReply != null) {
      data['comment_reply'] =
          this.commentReply!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentReply {
  int? id;
  int? commentId;
  int? userId;
  String? comment;
  String? createdAt;
  String? userLogo;
  String? name;

  CommentReply(
      {this.id,
        this.commentId,
        this.userId,
        this.comment,
        this.createdAt,
        this.userLogo,
        this.name});

  CommentReply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentId = json['comment_id'];
    userId = json['user_id'];
    comment = json['comment'];
    createdAt = json['created_at'];
    userLogo = json['user_logo'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment_id'] = this.commentId;
    data['user_id'] = this.userId;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['user_logo'] = this.userLogo;
    data['name'] = this.name;
    return data;
  }
}