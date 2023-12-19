class GetProfileData {
  bool? status;
  int? like;
  bool? isFollow;
  User? user;
  List<PostList>? post;
  List<Null>? likes;

  GetProfileData(
      {this.status,
        this.like,
        this.isFollow,
        this.user,
        this.post,
        this.likes});

  GetProfileData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    like = json['Like'];
    isFollow = json['is_follow'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    if (json['Post'] != null) {
      post = <PostList>[];
      json['Post'].forEach((v) {
        post!.add(new PostList.fromJson(v));
      });
    }
   /* if (json['Likes'] != null) {
      likes = <Null>[];
      json['Likes'].forEach((v) {
        likes!.add(new Like.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['Like'] = this.like;
    data['is_follow'] = this.isFollow;
    if (this.user != null) {
      data['User'] = this.user!.toJson();
    }
    if (this.post != null) {
      data['Post'] = this.post!.map((v) => v.toJson()).toList();
    }
  /*  if (this.likes != null) {
      data['Likes'] = this.likes!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? mobileNumber;
  String? image;
  Null? coverPhoto;
  Null? description;
  String? agentRef;
  String? agentBrn;
  String? dldNo;
  String? brokerOrn;
  String? uid;

  User(
      {this.id,
        this.name,
        this.email,
        this.mobileNumber,
        this.image,
        this.coverPhoto,
        this.description,
        this.agentRef,
        this.agentBrn,
        this.dldNo,
        this.brokerOrn,
        this.uid});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    image = json['image'];
    coverPhoto = json['cover_photo'];
    description = json['description'];
    agentRef = json['agent_ref'];
    agentBrn = json['agent_brn'];
    dldNo = json['dld_no'];
    brokerOrn = json['broker_orn'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_number'] = this.mobileNumber;
    data['image'] = this.image;
    data['cover_photo'] = this.coverPhoto;
    data['description'] = this.description;
    data['agent_ref'] = this.agentRef;
    data['agent_brn'] = this.agentBrn;
    data['dld_no'] = this.dldNo;
    data['broker_orn'] = this.brokerOrn;
    data['uid'] = this.uid;
    return data;
  }
}

class PostList {
  int? id;
  int? userId;
  int? categoryId;
  String? propertyName;
  int? price;
  int? isPost;
  Null? salePrice;
  int? propertySize;
  bool? liked;
  Null? propertyAddress;
  int? bedroomCount;
  int? kitchenCount;
  int? bathroomCount;
  int? isverified;
  String? thamblain;
  String? images;
  Null? privacyPolicy;
  String? createdAt;
  int? shopId;
  String? description;
  CreatedBy? createdBy;
  List<Null>? category;
  int? like;
  Null? view;
  int? enquiry;
  bool? collected;

  PostList(
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
        this.enquiry,
        this.collected});

  PostList.fromJson(Map<String, dynamic> json) {
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
    images = json['images'];
    privacyPolicy = json['privacy_policy'];
    createdAt = json['created_at'];
    shopId = json['shop_id'];
    description = json['description'];
    createdBy = json['created_by'] != null
        ? new CreatedBy.fromJson(json['created_by'])
        : null;
/*    if (json['category'] != null) {
      category = <Null>[];
      json['category'].forEach((v) {
        category!.add(new Null.fromJson(v));
      });
    }*/
    like = json['like'];
    view = json['view'];
    enquiry = json['enquiry'];
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
    data['images'] = this.images;
    data['privacy_policy'] = this.privacyPolicy;
    data['created_at'] = this.createdAt;
    data['shop_id'] = this.shopId;
    data['description'] = this.description;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy!.toJson();
    }
   /* if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }*/
    data['like'] = this.like;
    data['view'] = this.view;
    data['enquiry'] = this.enquiry;
    data['collected'] = this.collected;
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
    data['location'] = this.location;
    data['social_login'] = this.socialLogin;
    return data;
  }
}