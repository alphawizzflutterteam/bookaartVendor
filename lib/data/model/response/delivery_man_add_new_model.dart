class DeliveryManAddNewModel {
  List<UnassignedDeliveryMen>? unassignedDeliveryMen;

  DeliveryManAddNewModel({this.unassignedDeliveryMen});

  DeliveryManAddNewModel.fromJson(Map<String, dynamic> json) {
    if (json['unassignedDeliveryMen'] != null) {
      unassignedDeliveryMen = <UnassignedDeliveryMen>[];
      json['unassignedDeliveryMen'].forEach((v) {
        unassignedDeliveryMen!.add(new UnassignedDeliveryMen.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.unassignedDeliveryMen != null) {
      data['unassignedDeliveryMen'] =
          this.unassignedDeliveryMen!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UnassignedDeliveryMen {
  int? id;
  int? sellerId;
  String? fName;
  String? lName;
  String? address;
  String? latitude;
  String? longitude;
  String? zipcode;
  String? city;
  String? state;
  String? area;
  String? countryCode;
  String? phone;
  String? email;
  String? identityNumber;
  String? identityType;
  String? identityImage;
  String? image;
  String? bankName;
  String? branch;
  String? accountNo;
  String? holderName;
  int? isActive;
  int? isOnline;
  String? createdAt;
  String? updatedAt;
  String? fcmToken;

  UnassignedDeliveryMen(
      {this.id,
      this.sellerId,
      this.fName,
      this.lName,
      this.address,
      this.latitude,
      this.longitude,
      this.zipcode,
      this.city,
      this.state,
      this.area,
      this.countryCode,
      this.phone,
      this.email,
      this.identityNumber,
      this.identityType,
      this.identityImage,
      this.image,
      this.bankName,
      this.branch,
      this.accountNo,
      this.holderName,
      this.isActive,
      this.isOnline,
      this.createdAt,
      this.updatedAt,
      this.fcmToken});

  UnassignedDeliveryMen.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerId = json['seller_id'];
    fName = json['f_name'];
    lName = json['l_name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zipcode = json['zipcode'];
    city = json['city'];
    state = json['state'];
    area = json['area'];
    countryCode = json['country_code'];
    phone = json['phone'];
    email = json['email'];
    identityNumber = json['identity_number'];
    identityType = json['identity_type'];
    identityImage = json['identity_image'];
    image = json['image'];
    bankName = json['bank_name'];
    branch = json['branch'];
    accountNo = json['account_no'];
    holderName = json['holder_name'];
    isActive = json['is_active'];
    isOnline = json['is_online'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fcmToken = json['fcm_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['seller_id'] = this.sellerId;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['zipcode'] = this.zipcode;
    data['city'] = this.city;
    data['state'] = this.state;
    data['area'] = this.area;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['identity_number'] = this.identityNumber;
    data['identity_type'] = this.identityType;
    data['identity_image'] = this.identityImage;
    data['image'] = this.image;
    data['bank_name'] = this.bankName;
    data['branch'] = this.branch;
    data['account_no'] = this.accountNo;
    data['holder_name'] = this.holderName;
    data['is_active'] = this.isActive;
    data['is_online'] = this.isOnline;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['fcm_token'] = this.fcmToken;
    return data;
  }
}
