class MyBookingModel {
  MyBookingModel({
    required this.status,
    required this.data,
  });

  final bool? status;
  final List<Data> data;

  factory MyBookingModel.fromJson(Map<String, dynamic> json) {
    return MyBookingModel(
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<Data>.from(json["data"]!.map((x) => Data.fromJson(x))),
    );
  }
}

class Data {
  Data({
     this.id,
     this.bookingId,
     this.userId,
     this.bookingType,
     this.employeeId,
     this.sellerId,
     this.serviceId,
     this.patientName,
     this.patientAge,
     this.patientGender,
     this.patientEmail,
     this.patientMobile,
     this.houseNumber,
     this.streetName,
     this.locality,
     this.pincode,
     this.area,
     this.landmark,
     this.complaint,
     this.bookingDatetime,
     this.slotId,
     this.bookingTime,
     this.tillTime,
     this.alternateDatetime,
     this.paidAmount,
     this.isPaid,
     this.googleAddress,
     this.latitude,
     this.longitude,
     this.status,
     this.statusUpdateBy,
     this.createdAt,
     this.updatedAt,
     this.alternateMobile,
     this.city,
     this.state,
     this.images,
     this.user,
     this.service,
  });

  final int? id;
  final String? bookingId;
  final int? userId;
  final String? bookingType;
  final dynamic employeeId;
  final int? sellerId;
  final int? serviceId;
  final String? patientName;
  final dynamic patientAge;
  final dynamic patientGender;
  final String? patientEmail;
  final String? patientMobile;
  final dynamic houseNumber;
  final dynamic streetName;
  final dynamic locality;
  final int? pincode;
  final String? area;
  final dynamic landmark;
  final String? complaint;
  final DateTime? bookingDatetime;
  final int? slotId;
  final String? bookingTime;
  final String? tillTime;
  final dynamic alternateDatetime;
  final int? paidAmount;
  final int? isPaid;
  final String? googleAddress;
  final String? latitude;
  final String? longitude;
  final int? status;
  final dynamic statusUpdateBy;
  final DateTime? createdAt;
  final dynamic updatedAt;
  final String? alternateMobile;
  final String? city;
  final String? state;
  final String? images;
  final User? user;
  final Service? service;

  factory Data.fromJson(Map<String, dynamic> json) {

    try{ return Data(
      id: json["id"],
      bookingId: json["booking_id"],
      userId: json["user_id"],
      bookingType: json["booking_type"],
      employeeId: json["employee_id"],
      sellerId: json["seller_id"],
      serviceId: json["service_id"],
      patientName: json["patient_name"],
      patientAge: json["patient_age"],
      patientGender: json["patient_gender"],
      patientEmail: json["patient_email"],
      patientMobile: json["patient_mobile"],
      houseNumber: json["house_number"],
      streetName: json["street_name"],
      locality: json["locality"],
      pincode: json["pincode"],
      area: json["area"],
      landmark: json["landmark"],
      complaint: json["complaint"],
      bookingDatetime: DateTime.tryParse(json["booking_datetime"] ?? ""),
      slotId: json["slot_id"],
      bookingTime: json["booking_time"],
      tillTime: json["till_time"],
      alternateDatetime: json["alternate_datetime"],
      paidAmount: double.parse(json["paid_amount"].toString()).toInt(),
      isPaid: json["is_paid"],
      googleAddress: json["google_address"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      status: json["status"],
      statusUpdateBy: json["status_update_by"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: json["updated_at"],
      alternateMobile: json["alternate_mobile"],
      city: json["city"],
      state: json["state"],
      images: json["images"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      service:
          json["service"] == null ? null : Service.fromJson(json["service"]),
    );
    }catch(e){

      return Data();
    }
  }
}

class Service {
  Service({
    required this.id,
    required this.addedBy,
    required this.userId,
    required this.name,
    required this.slug,
    required this.productType,
    required this.categoryIds,
    required this.categoryId,
    required this.subCategoryId,
    required this.subSubCategoryId,
    required this.brandId,
    required this.unit,
    required this.minQty,
    required this.refundable,
    required this.digitalProductType,
    required this.digitalFileReady,
    required this.images,
    required this.colorImage,
    required this.thumbnail,
    required this.featured,
    required this.flashDeal,
    required this.videoProvider,
    required this.videoUrl,
    required this.colors,
    required this.variantProduct,
    required this.attributes,
    required this.choiceOptions,
    required this.variation,
    required this.published,
    required this.unitPrice,
    required this.purchasePrice,
    required this.tax,
    required this.taxType,
    required this.taxModel,
    required this.discount,
    required this.discountType,
    required this.currentStock,
    required this.minimumOrderQty,
    required this.details,
    required this.freeShipping,
    required this.attachment,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.featuredStatus,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaImage,
    required this.requestStatus,
    required this.deniedNote,
    required this.shippingCost,
    required this.multiplyQty,
    required this.tempShippingCost,
    required this.isShippingCostUpdated,
    required this.code,
    required this.reviewsCount,
    required this.translations,
    required this.reviews,
  });

  final int? id;
  final String? addedBy;
  final int? userId;
  final String? name;
  final String? slug;
  final String? productType;
  final dynamic categoryIds;
  final String? categoryId;
  final dynamic subCategoryId;
  final dynamic subSubCategoryId;
  final dynamic brandId;
  final dynamic unit;
  final int? minQty;
  final int? refundable;
  final dynamic digitalProductType;
  final dynamic digitalFileReady;
  final String? images;
  final dynamic colorImage;
  final String? thumbnail;
  final dynamic featured;
  final dynamic flashDeal;
  final String? videoProvider;
  final dynamic videoUrl;
  final dynamic colors;
  final int? variantProduct;
  final dynamic attributes;
  final dynamic choiceOptions;
  final dynamic variation;
  final int? published;
  final int? unitPrice;
  final int? purchasePrice;
  final int? tax;
  final dynamic taxType;
  final String? taxModel;
  final int? discount;
  final String? discountType;
  final dynamic currentStock;
  final int? minimumOrderQty;
  final String? details;
  final int? freeShipping;
  final dynamic attachment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? status;
  final int? featuredStatus;
  final dynamic metaTitle;
  final dynamic metaDescription;
  final dynamic metaImage;
  final int? requestStatus;
  final dynamic deniedNote;
  final int? shippingCost;
  final dynamic multiplyQty;
  final dynamic tempShippingCost;
  final dynamic isShippingCostUpdated;
  final dynamic code;
  final int? reviewsCount;
  final List<dynamic> translations;
  final List<dynamic> reviews;

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json["id"],
      addedBy: json["added_by"],
      userId: json["user_id"],
      name: json["name"],
      slug: json["slug"],
      productType: json["product_type"],
      categoryIds: json["category_ids"],
      categoryId: json["category_id"],
      subCategoryId: json["sub_category_id"],
      subSubCategoryId: json["sub_sub_category_id"],
      brandId: json["brand_id"],
      unit: json["unit"],
      minQty: json["min_qty"],
      refundable: json["refundable"],
      digitalProductType: json["digital_product_type"],
      digitalFileReady: json["digital_file_ready"],
      images: json["images"],
      colorImage: json["color_image"],
      thumbnail: json["thumbnail"],
      featured: json["featured"],
      flashDeal: json["flash_deal"],
      videoProvider: json["video_provider"],
      videoUrl: json["video_url"],
      colors: json["colors"],
      variantProduct: json["variant_product"],
      attributes: json["attributes"],
      choiceOptions: json["choice_options"],
      variation: json["variation"],
      published: json["published"],
      unitPrice: json["unit_price"],
      purchasePrice: json["purchase_price"],
      tax: json["tax"],
      taxType: json["tax_type"],
      taxModel: json["tax_model"],
      discount: json["discount"],
      discountType: json["discount_type"],
      currentStock: json["current_stock"],
      minimumOrderQty: json["minimum_order_qty"],
      details: json["details"],
      freeShipping: json["free_shipping"],
      attachment: json["attachment"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      status: json["status"],
      featuredStatus: json["featured_status"],
      metaTitle: json["meta_title"],
      metaDescription: json["meta_description"],
      metaImage: json["meta_image"],
      requestStatus: json["request_status"],
      deniedNote: json["denied_note"],
      shippingCost: json["shipping_cost"],
      multiplyQty: json["multiply_qty"],
      tempShippingCost: json["temp_shipping_cost"],
      isShippingCostUpdated: json["is_shipping_cost_updated"],
      code: json["code"],
      reviewsCount: json["reviews_count"],
      translations: json["translations"] == null
          ? []
          : List<dynamic>.from(json["translations"]!.map((x) => x)),
      reviews: json["reviews"] == null
          ? []
          : List<dynamic>.from(json["reviews"]!.map((x) => x)),
    );
  }
}

class User {
  User({
    required this.id,
    required this.name,
    required this.fName,
    required this.lName,
    required this.phone,
    required this.image,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.streetAddress,
    required this.age,
    required this.gender,
    required this.country,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.area,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.houseNo,
    required this.apartmentNo,
    required this.cmFirebaseToken,
    required this.isActive,
    required this.paymentCardLastFour,
    required this.paymentCardBrand,
    required this.paymentCardFawryToken,
    required this.loginMedium,
    required this.socialId,
    required this.isPhoneVerified,
    required this.temporaryToken,
    required this.isEmailVerified,
    required this.walletBalance,
    required this.loyaltyPoint,
    required this.loginHitCount,
    required this.isTempBlocked,
    required this.tempBlockTime,
    required this.referralCode,
    required this.friendReferral,
    required this.planStatus,
    required this.planId,
    required this.planExpireDate,
    required this.dailyBonusAmount,
    required this.referralBonus,
    required this.repurchaseWallet,
    required this.withdrawalWallet,
    required this.isFrenchise,
    required this.fundWallet,
  });

  final int? id;
  final dynamic name;
  final String? fName;
  final String? lName;
  final String? phone;
  final String? image;
  final String? email;
  final dynamic emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic streetAddress;
  final dynamic age;
  final dynamic gender;
  final dynamic country;
  final String? city;
  final String? state;
  final String? zipcode;
  final String? area;
  final String? address;
  final String? latitude;
  final String? longitude;
  final dynamic houseNo;
  final dynamic apartmentNo;
  final String? cmFirebaseToken;
  final int? isActive;
  final dynamic paymentCardLastFour;
  final dynamic paymentCardBrand;
  final dynamic paymentCardFawryToken;
  final dynamic loginMedium;
  final dynamic socialId;
  final int? isPhoneVerified;
  final String? temporaryToken;
  final int? isEmailVerified;
  final int? walletBalance;
  final dynamic loyaltyPoint;
  final int? loginHitCount;
  final int? isTempBlocked;
  final dynamic tempBlockTime;
  final String? referralCode;
  final String? friendReferral;
  final int? planStatus;
  final dynamic planId;
  final dynamic planExpireDate;
  final int? dailyBonusAmount;
  final dynamic referralBonus;
  final int? repurchaseWallet;
  final int? withdrawalWallet;
  final int? isFrenchise;
  final int? fundWallet;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      fName: json["f_name"],
      lName: json["l_name"],
      phone: json["phone"],
      image: json["image"],
      email: json["email"],
      emailVerifiedAt: json["email_verified_at"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      streetAddress: json["street_address"],
      age: json["age"],
      gender: json["gender"],
      country: json["country"],
      city: json["city"],
      state: json["state"],
      zipcode: json["zipcode"],
      area: json["area"],
      address: json["address"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      houseNo: json["house_no"],
      apartmentNo: json["apartment_no"],
      cmFirebaseToken: json["cm_firebase_token"],
      isActive: json["is_active"],
      paymentCardLastFour: json["payment_card_last_four"],
      paymentCardBrand: json["payment_card_brand"],
      paymentCardFawryToken: json["payment_card_fawry_token"],
      loginMedium: json["login_medium"],
      socialId: json["social_id"],
      isPhoneVerified: json["is_phone_verified"],
      temporaryToken: json["temporary_token"],
      isEmailVerified: json["is_email_verified"],
      walletBalance: json["wallet_balance"],
      loyaltyPoint: json["loyalty_point"],
      loginHitCount: json["login_hit_count"],
      isTempBlocked: json["is_temp_blocked"],
      tempBlockTime: json["temp_block_time"],
      referralCode: json["referral_code"],
      friendReferral: json["friend_referral"],
      planStatus: json["plan_status"],
      planId: json["plan_id"],
      planExpireDate: json["plan_expire_date"],
      dailyBonusAmount: json["daily_bonus_amount"],
      referralBonus: json["referral_bonus"],
      repurchaseWallet: json["repurchase_wallet"],
      withdrawalWallet: json["withdrawal_wallet"],
      isFrenchise: json["is_frenchise"],
      fundWallet: json["fund_wallet"],
    );
  }
}
