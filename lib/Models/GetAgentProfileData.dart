class GetAgentProfile {
  bool? status;
  bool? isFollow;
  User? user;
  List<PostList>? post;

  GetAgentProfile({this.status, this.isFollow, this.user, this.post});

  GetAgentProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isFollow = json['is_follow'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    if (json['Post'] != null) {
      post = <PostList>[];
      json['Post'].forEach((v) {
        post!.add(new PostList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['is_follow'] = this.isFollow;
    if (this.user != null) {
      data['User'] = this.user!.toJson();
    }
    if (this.post != null) {
      data['Post'] = this.post!.map((v) => v.toJson()).toList();
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
  String? appleId;
  String? deviceId;
  String? platform;
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
  String? video;
  List<Images>? images;
  Null? privacyPolicy;
  String? createdAt;
  int? shopId;
  String? description;
  User? createdBy;
  Category? category;
  List<Comment>? comment;
  int? totalComment;
  int? like;
  Null? view;
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
        this.video,
        this.images,
        this.privacyPolicy,
        this.createdAt,
        this.shopId,
        this.description,
        this.createdBy,
        this.category,
        this.comment,
        this.totalComment,
        this.like,
        this.view,
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
    video = json['video'];
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
        ? new User.fromJson(json['created_by'])
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
    totalComment = json['total_comment'];
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
    data['video'] = this.video;
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
    if (this.comment != null) {
      data['comment'] = this.comment!.map((v) => v.toJson()).toList();
    }
    data['total_comment'] = this.totalComment;
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
        });

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

    return data;
  }
}
