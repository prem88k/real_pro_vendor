class GetUserProfile {
  bool? status;
  int? like;
  bool? isFollow;
  User? user;
  List<Likes>? likes;
  List<Collects>? collect;

  GetUserProfile(
      {this.status,
        this.like,
        this.isFollow,
        this.user,
        this.likes,
        this.collect});

  GetUserProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    like = json['Like'];
    isFollow = json['is_follow'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    if (json['Likes'] != null) {
      likes = <Likes>[];
      json['Likes'].forEach((v) {
        likes!.add(new Likes.fromJson(v));
      });
    }
    if (json['collect'] != null) {
      collect = <Collects>[];
      json['collect'].forEach((v) {
        collect!.add(new Collects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['Like'] = this.like;
    data['is_follow'] = this.isFollow;
    if (this.user != null) {
      data['User'] = this.user!.toJson();
    }
    if (this.likes != null) {
      data['Likes'] = this.likes!.map((v) => v.toJson()).toList();
    }
    if (this.collect != null) {
      data['collect'] = this.collect!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Likes {
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
  String? video;
  String? purpose;
  List<Images>? images;
  String? city;
  String? area;
  String? tower;
  String? propertyType;
  Null? privacyPolicy;
  String? createdAt;
  int? shopId;
  String? description;
  int? totalComment;
  int? like;
  Null? view;
  bool? collected;

  Likes(
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
        this.purpose,
        this.images,
        this.city,
        this.area,
        this.tower,
        this.propertyType,
        this.privacyPolicy,
        this.createdAt,
        this.shopId,
        this.description,
        this.totalComment,
        this.like,
        this.view,
        this.collected});

  Likes.fromJson(Map<String, dynamic> json) {
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
    purpose = json['purpose'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    city = json['city'];
    area = json['area'];
    tower = json['tower'];
    propertyType = json['property_type'];
    privacyPolicy = json['privacy_policy'];
    createdAt = json['created_at'];
    shopId = json['shop_id'];
    description = json['description'];
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
    data['purpose'] = this.purpose;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['city'] = this.city;
    data['area'] = this.area;
    data['tower'] = this.tower;
    data['property_type'] = this.propertyType;
    data['privacy_policy'] = this.privacyPolicy;
    data['created_at'] = this.createdAt;
    data['shop_id'] = this.shopId;
    data['description'] = this.description;
    data['total_comment'] = this.totalComment;
    data['like'] = this.like;
    data['view'] = this.view;
    data['collected'] = this.collected;
    return data;
  }
}
class Collects {
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
  String? video;
  String? purpose;
  List<Images>? images;
  String? city;
  String? area;
  String? tower;
  String? propertyType;
  Null? privacyPolicy;
  String? createdAt;
  int? shopId;
  String? description;
  int? totalComment;
  int? like;
  Null? view;
  bool? collected;

  Collects(
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
        this.purpose,
        this.images,
        this.city,
        this.area,
        this.tower,
        this.propertyType,
        this.privacyPolicy,
        this.createdAt,
        this.shopId,
        this.description,
        this.totalComment,
        this.like,
        this.view,
        this.collected});

  Collects.fromJson(Map<String, dynamic> json) {
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
    purpose = json['purpose'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    city = json['city'];
    area = json['area'];
    tower = json['tower'];
    propertyType = json['property_type'];
    privacyPolicy = json['privacy_policy'];
    createdAt = json['created_at'];
    shopId = json['shop_id'];
    description = json['description'];
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
    data['purpose'] = this.purpose;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['city'] = this.city;
    data['area'] = this.area;
    data['tower'] = this.tower;
    data['property_type'] = this.propertyType;
    data['privacy_policy'] = this.privacyPolicy;
    data['created_at'] = this.createdAt;
    data['shop_id'] = this.shopId;
    data['description'] = this.description;
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
class User {
  int? id;
  String? name;
  String? email;
  String? mobileNumber;
  String? image;
  String? coverPhoto;
  String? description;
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
