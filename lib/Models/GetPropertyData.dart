class GetPropertyData {
  bool? status;
  int? totalCount;
  List<PropertyList>? data;

  GetPropertyData({this.status, this.totalCount, this.data});

  GetPropertyData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalCount = json['total_count'];
    if (json['data'] != null) {
      data = <PropertyList>[];
      json['data'].forEach((v) {
        data!.add(new PropertyList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['total_count'] = this.totalCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropertyList {
  int? id;
  int? userId;
  int? categoryId;
  String? propertyName;
  int? price;
  int? isPost;
  Null? salePrice;
  int? propertySize;
  bool? liked;
  String? propertyAddress;
  int? bedroomCount;
  int? kitchenCount;
  int? bathroomCount;
  int? isverified;
  String? thamblain;
  List<Images>? images;
  String? privacyPolicy;
  String? createdAt;
  int? shopId;
  String? description;
  CreatedBy? createdBy;
  Category? category;
  int? like;
  String? view;
  bool? collected;

  PropertyList(
      {this.id,
        this.userId,
        this.categoryId,
        this.propertyName,
        this.price,
        this.isPost,
        this.salePrice,
        this.propertySize,
        this.liked,
        this.propertyAddress,
        this.bedroomCount,
        this.kitchenCount,
        this.bathroomCount,
        this.isverified,
        this.thamblain,
        this.images,
        this.privacyPolicy,
        this.createdAt,
        this.shopId,
        this.description,
        this.createdBy,
        this.category,
        this.like,
        this.view,
        this.collected});

  PropertyList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    propertyName = json['property_name'];
    price = json['price'];
    isPost = json['is_post'];
    salePrice = json['sale_price'];
    propertySize = json['property_size'];
    liked = json['liked'];
    propertyAddress = json['property_address'];
    bedroomCount = json['bedroom_count'];
    kitchenCount = json['kitchen_count'];
    bathroomCount = json['bathroom_count'];
    isverified = json['isverified'];
    thamblain = json['thamblain'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    privacyPolicy = json['privacy_policy'];
    createdAt = json['created_at'];
    shopId = json['shop_id'];
    description = json['description'];
    createdBy = json['created_by'] != null
        ? new CreatedBy.fromJson(json['created_by'])
        : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    like = json['like'];
    view = json['view'];
    collected = json['collected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['property_name'] = this.propertyName;
    data['price'] = this.price;
    data['is_post'] = this.isPost;
    data['sale_price'] = this.salePrice;
    data['property_size'] = this.propertySize;
    data['liked'] = this.liked;
    data['property_address'] = this.propertyAddress;
    data['bedroom_count'] = this.bedroomCount;
    data['kitchen_count'] = this.kitchenCount;
    data['bathroom_count'] = this.bathroomCount;
    data['isverified'] = this.isverified;
    data['thamblain'] = this.thamblain;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['privacy_policy'] = this.privacyPolicy;
    data['created_at'] = this.createdAt;
    data['shop_id'] = this.shopId;
    data['description'] = this.description;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['like'] = this.like;
    data['view'] = this.view;
    data['collected'] = this.collected;
    return data;
  }
}

class Images {
  int? id;
  int? productId;
  String? image;

  Images({this.id, this.productId, this.image});

  Images.fromJson(Map<String, dynamic> json) {
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
  String? description;
  String? uid;
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
        this.uid,
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
    uid = json['uid'];
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
    data['uid'] = this.uid;
    data['location'] = this.location;
    data['social_login'] = this.socialLogin;
    return data;
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
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
