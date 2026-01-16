class BookingModel {
  bool? status;
  int? totalSize;
  int? limit;
  int? offset;
  List<BookingData>? data;
  Counts? counts;

  BookingModel({this.status, this.data, this.counts});

  BookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalSize = json['total_size'];
    limit = int.parse(json['limit'].toString());
    offset = int.parse(json['offset'].toString());
    if (json['data'] != null) {
      data = <BookingData>[];
      json['data'].forEach((v) {
        data!.add(BookingData.fromJson(v));
      });
    }
    counts =
    json['counts'] != null ? Counts.fromJson(json['counts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (counts != null) {
      data['counts'] = counts!.toJson();
    }
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    return data;
  }
}

class BookingData {
  int? id;
  String? bookingId;
  int? userId;
  String? bookingType;
  String? type;
  dynamic? employeeId;
  int? sellerId;
  int? serviceId;
  String? serviceType;
  String? patientName;
  dynamic? patientAge;
  dynamic? patientGender;
  String? patientEmail;
  String? patientMobile;
  dynamic? houseNumber;
  dynamic? streetName;
  dynamic? locality;
  int? pincode;
  String? area;
  double? sellerAmount;
  double? adminAmount;
  String? bookingDatetime;
  int? slotId;
  dynamic? landmark;
  String? complaint;
  String? orderNote;
  String? bookingTime;
  String? tillTime;
  dynamic? alternateDatetime;
  double? paidAmount;
  int? adminCommission;
  int? isPaid;
  String? paymentMethod;
  String? transactionId;
  String? googleAddress;
  String? latitude;
  String? longitude;
  int? status;
  int? checked;
  int? rescheduleUserStatus;
  int? statusUpdateBy;
  String? createdAt;
  String? updatedAt;
  String? alternateMobile;
  String? city;
  String? state;
  String? images;
  String? couponCode;
  int? couponDiscount;
  User? user;
  Service? service;

  BookingData(
      {this.id,
        this.bookingId,
        this.userId,
        this.bookingType,
        this.type,
        this.employeeId,
        this.sellerId,
        this.serviceId,
        this.serviceType,
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
        this.sellerAmount,
        this.adminAmount,
        this.bookingDatetime,
        this.slotId,
        this.landmark,
        this.complaint,
        this.orderNote,
        this.bookingTime,
        this.tillTime,
        this.alternateDatetime,
        this.paidAmount,
        this.adminCommission,
        this.isPaid,
        this.paymentMethod,
        this.transactionId,
        this.googleAddress,
        this.latitude,
        this.longitude,
        this.status,
        this.checked,
        this.rescheduleUserStatus,
        this.statusUpdateBy,
        this.createdAt,
        this.updatedAt,
        this.alternateMobile,
        this.city,
        this.state,
        this.images,
        this.couponCode,
        this.couponDiscount,
        this.user,
        this.service});

  BookingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    userId = json['user_id'];
    bookingType = json['booking_type'];
    type = json['type'];
    employeeId = json['employee_id'];
    sellerId = json['seller_id'];
    serviceId = json['service_id'];
    serviceType = json['service_type'];
    patientName = json['patient_name'];
    patientAge = json['patient_age'];
    patientGender = json['patient_gender'];
    patientEmail = json['patient_email'];
    patientMobile = json['patient_mobile'];
    houseNumber = json['house_number'];
    streetName = json['street_name'];
    locality = json['locality'];
    pincode = json['pincode'];
    area = json['area'];
    sellerAmount = double.tryParse(json['seller_amount'].toString());
    adminAmount = double.tryParse(json['admin_amount'].toString());
    bookingDatetime = json['booking_datetime'];
    slotId = json['slot_id'];
    landmark = json['landmark'];
    complaint = json['complaint'];
    orderNote = json['order_note'];
    bookingTime = json['booking_time'];
    tillTime = json['till_time'];
    alternateDatetime = json['alternate_datetime'];
    paidAmount = double.parse(json['paid_amount'].toString());
    adminCommission = json['admin_commission'];
    isPaid = json['is_paid'];
    paymentMethod = json['payment_method'];
    transactionId = json['transaction_id'];
    googleAddress = json['google_address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    checked = json['checked'];
    rescheduleUserStatus = json['reschedule_user_status'];
    statusUpdateBy = json['status_update_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    alternateMobile = json['alternate_mobile'];
    city = json['city'];
    state = json['state'];
    images = json['images'];
    couponCode = json['coupon_code'];
    couponDiscount = json['coupon_discount'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    service =
    json['service'] != null ? Service.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['user_id'] = userId;
    data['booking_type'] = bookingType;
    data['type'] = type;
    data['employee_id'] = employeeId;
    data['seller_id'] = sellerId;
    data['service_id'] = serviceId;
    data['service_type'] = serviceType;
    data['patient_name'] = patientName;
    data['patient_age'] = patientAge;
    data['patient_gender'] = patientGender;
    data['patient_email'] = patientEmail;
    data['patient_mobile'] = patientMobile;
    data['house_number'] = houseNumber;
    data['street_name'] = streetName;
    data['locality'] = locality;
    data['pincode'] = pincode;
    data['area'] = area;
    data['seller_amount'] = sellerAmount;
    data['admin_amount'] = adminAmount;
    data['booking_datetime'] = bookingDatetime;
    data['slot_id'] = slotId;
    data['landmark'] = landmark;
    data['complaint'] = complaint;
    data['order_note'] = orderNote;
    data['booking_time'] = bookingTime;
    data['till_time'] = tillTime;
    data['alternate_datetime'] = alternateDatetime;
    data['paid_amount'] = paidAmount;
    data['admin_commission'] = adminCommission;
    data['is_paid'] = isPaid;
    data['payment_method'] = paymentMethod;
    data['transaction_id'] = transactionId;
    data['google_address'] = googleAddress;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['status'] = status;
    data['checked'] = checked;
    data['reschedule_user_status'] = rescheduleUserStatus;
    data['status_update_by'] = statusUpdateBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['alternate_mobile'] = alternateMobile;
    data['city'] = city;
    data['state'] = state;
    data['images'] = images;
    data['coupon_code'] = couponCode;
    data['coupon_discount'] = couponDiscount;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (service != null) {
      data['service'] = service!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  dynamic? name;
  String? fName;
  String? lName;
  String? phone;
  String? image;
  String? email;
  dynamic? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  dynamic? streetAddress;
  String? age;
  String? gender;
  dynamic? dob;
  dynamic? country;
  String? city;
  String? state;
  String? zipcode;
  String? area;
  String? address;
  String? latitude;
  String? longitude;
  dynamic? houseNo;
  dynamic? apartmentNo;
  dynamic? cmFirebaseToken;
  int? isActive;
  dynamic? paymentCardLastFour;
  dynamic? paymentCardBrand;
  dynamic? paymentCardFawryToken;
  dynamic? loginMedium;
  dynamic? socialId;
  int? isPhoneVerified;
  String? temporaryToken;
  int? isEmailVerified;
  int? walletBalance;
  dynamic? loyaltyPoint;
  int? loginHitCount;
  int? isTempBlocked;
  dynamic? tempBlockTime;
  dynamic? referralCode;
  dynamic? friendReferral;
  int? planStatus;
  dynamic? planId;
  dynamic? planExpireDate;
  int? dailyBonusAmount;
  dynamic? referralBonus;
  int? repurchaseWallet;
  int? withdrawalWallet;
  int? isFrenchise;
  int? fundWallet;
  int? rewardPoints;

  User(
      {this.id,
        this.name,
        this.fName,
        this.lName,
        this.phone,
        this.image,
        this.email,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.streetAddress,
        this.age,
        this.gender,
        this.dob,
        this.country,
        this.city,
        this.state,
        this.zipcode,
        this.area,
        this.address,
        this.latitude,
        this.longitude,
        this.houseNo,
        this.apartmentNo,
        this.cmFirebaseToken,
        this.isActive,
        this.paymentCardLastFour,
        this.paymentCardBrand,
        this.paymentCardFawryToken,
        this.loginMedium,
        this.socialId,
        this.isPhoneVerified,
        this.temporaryToken,
        this.isEmailVerified,
        this.walletBalance,
        this.loyaltyPoint,
        this.loginHitCount,
        this.isTempBlocked,
        this.tempBlockTime,
        this.referralCode,
        this.friendReferral,
        this.planStatus,
        this.planId,
        this.planExpireDate,
        this.dailyBonusAmount,
        this.referralBonus,
        this.repurchaseWallet,
        this.withdrawalWallet,
        this.isFrenchise,
        this.fundWallet,
        this.rewardPoints});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    image = json['image'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    streetAddress = json['street_address'];
    age = json['age'];
    gender = json['gender'];
    dob = json['dob'];
    country = json['country'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    area = json['area'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    houseNo = json['house_no'];
    apartmentNo = json['apartment_no'];
    cmFirebaseToken = json['cm_firebase_token'];
    isActive = json['is_active'];
    paymentCardLastFour = json['payment_card_last_four'];
    paymentCardBrand = json['payment_card_brand'];
    paymentCardFawryToken = json['payment_card_fawry_token'];
    loginMedium = json['login_medium'];
    socialId = json['social_id'];
    isPhoneVerified = json['is_phone_verified'];
    temporaryToken = json['temporary_token'];
    isEmailVerified = json['is_email_verified'];
    walletBalance = json['wallet_balance'];
    loyaltyPoint = json['loyalty_point'];
    loginHitCount = json['login_hit_count'];
    isTempBlocked = json['is_temp_blocked'];
    tempBlockTime = json['temp_block_time'];
    referralCode = json['referral_code'];
    friendReferral = json['friend_referral'];
    planStatus = json['plan_status'];
    planId = json['plan_id'];
    planExpireDate = json['plan_expire_date'];
    dailyBonusAmount = json['daily_bonus_amount'];
    referralBonus = json['referral_bonus'];
    repurchaseWallet = json['repurchase_wallet'];
    withdrawalWallet = json['withdrawal_wallet'];
    isFrenchise = json['is_frenchise'];
    fundWallet = json['fund_wallet'];
    rewardPoints = json['reward_points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['image'] = image;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['street_address'] = streetAddress;
    data['age'] = age;
    data['gender'] = gender;
    data['dob'] = dob;
    data['country'] = country;
    data['city'] = city;
    data['state'] = state;
    data['zipcode'] = zipcode;
    data['area'] = area;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['house_no'] = houseNo;
    data['apartment_no'] = apartmentNo;
    data['cm_firebase_token'] = cmFirebaseToken;
    data['is_active'] = isActive;
    data['payment_card_last_four'] = paymentCardLastFour;
    data['payment_card_brand'] = paymentCardBrand;
    data['payment_card_fawry_token'] = paymentCardFawryToken;
    data['login_medium'] = loginMedium;
    data['social_id'] = socialId;
    data['is_phone_verified'] = isPhoneVerified;
    data['temporary_token'] = temporaryToken;
    data['is_email_verified'] = isEmailVerified;
    data['wallet_balance'] = walletBalance;
    data['loyalty_point'] = loyaltyPoint;
    data['login_hit_count'] = loginHitCount;
    data['is_temp_blocked'] = isTempBlocked;
    data['temp_block_time'] = tempBlockTime;
    data['referral_code'] = referralCode;
    data['friend_referral'] = friendReferral;
    data['plan_status'] = planStatus;
    data['plan_id'] = planId;
    data['plan_expire_date'] = planExpireDate;
    data['daily_bonus_amount'] = dailyBonusAmount;
    data['referral_bonus'] = referralBonus;
    data['repurchase_wallet'] = repurchaseWallet;
    data['withdrawal_wallet'] = withdrawalWallet;
    data['is_frenchise'] = isFrenchise;
    data['fund_wallet'] = fundWallet;
    data['reward_points'] = rewardPoints;
    return data;
  }
}

class Service {
  int? id;
  String? addedBy;
  int? userId;
  int? sellerId;
  String? name;
  String? slug;
  String? productType;
  int? sellerCategoryId;
  int? sellerSubCategoryId;
  String? serviceType;
  dynamic categoryIds;
  dynamic categoryId;
  dynamic subCategoryId;
  dynamic subSubCategoryId;
  dynamic brandId;
  dynamic unit;
  int? minQty;
  int? refundable;
  dynamic digitalProductType;
  dynamic digitalFileReady;
  String? images;
  dynamic colorImage;
  String? thumbnail;
  dynamic featured;
  dynamic flashDeal;
  String? videoProvider;
  dynamic videoUrl;
  dynamic colors;
  int? variantProduct;
  dynamic attributes;
  dynamic choiceOptions;
  dynamic variation;
  int? published;
  int? unitPrice;
  int? purchasePrice;
  int? tax;
  dynamic taxType;
  String? taxModel;
  int? discount;
  String? discountType;
  dynamic currentStock;
  int? minimumOrderQty;
  String? details;
  int? freeShipping;
  dynamic attachment;
  String? createdAt;
  String? updatedAt;
  int? status;
  int? featuredStatus;
  dynamic metaTitle;
  dynamic metaDescription;
  dynamic metaImage;
  int? requestStatus;
  dynamic deniedNote;
  int? shippingCost;
  dynamic multiplyQty;
  dynamic tempShippingCost;
  dynamic isShippingCostUpdated;
  dynamic code;
  int? isFaster;
  int? reviewsCount;
  List<dynamic>? translations;
  List<dynamic>? reviews;

  Service(
      {this.id,
        this.addedBy,
        this.userId,
        this.sellerId,
        this.name,
        this.slug,
        this.productType,
        this.sellerCategoryId,
        this.sellerSubCategoryId,
        this.serviceType,
        this.categoryIds,
        this.categoryId,
        this.subCategoryId,
        this.subSubCategoryId,
        this.brandId,
        this.unit,
        this.minQty,
        this.refundable,
        this.digitalProductType,
        this.digitalFileReady,
        this.images,
        this.colorImage,
        this.thumbnail,
        this.featured,
        this.flashDeal,
        this.videoProvider,
        this.videoUrl,
        this.colors,
        this.variantProduct,
        this.attributes,
        this.choiceOptions,
        this.variation,
        this.published,
        this.unitPrice,
        this.purchasePrice,
        this.tax,
        this.taxType,
        this.taxModel,
        this.discount,
        this.discountType,
        this.currentStock,
        this.minimumOrderQty,
        this.details,
        this.freeShipping,
        this.attachment,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.featuredStatus,
        this.metaTitle,
        this.metaDescription,
        this.metaImage,
        this.requestStatus,
        this.deniedNote,
        this.shippingCost,
        this.multiplyQty,
        this.tempShippingCost,
        this.isShippingCostUpdated,
        this.code,
        this.isFaster,
        this.reviewsCount,
        this.translations,
        this.reviews});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addedBy = json['added_by'];
    userId = json['user_id'];
    sellerId = json['seller_id'];
    name = json['name'];
    slug = json['slug'];
    productType = json['product_type'];
    sellerCategoryId = json['seller_category_id'];
    sellerSubCategoryId = json['seller_sub_category_id'];
    serviceType = json['service_type'];
    categoryIds = json['category_ids'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    subSubCategoryId = json['sub_sub_category_id'];
    brandId = json['brand_id'];
    unit = json['unit'];
    minQty = json['min_qty'];
    refundable = json['refundable'];
    digitalProductType = json['digital_product_type'];
    digitalFileReady = json['digital_file_ready'];
    images = json['images'];
    colorImage = json['color_image'];
    thumbnail = json['thumbnail'];
    featured = json['featured'];
    flashDeal = json['flash_deal'];
    videoProvider = json['video_provider'];
    videoUrl = json['video_url'];
    colors = json['colors'];
    variantProduct = json['variant_product'];
    attributes = json['attributes'];
    choiceOptions = json['choice_options'];
    variation = json['variation'];
    published = json['published'];
    unitPrice = json['unit_price'];
    purchasePrice = json['purchase_price'];
    tax = json['tax'];
    taxType = json['tax_type'];
    taxModel = json['tax_model'];
    discount = json['discount'];
    discountType = json['discount_type'];
    currentStock = json['current_stock'];
    minimumOrderQty = json['minimum_order_qty'];
    details = json['details'];
    freeShipping = json['free_shipping'];
    attachment = json['attachment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    featuredStatus = json['featured_status'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    metaImage = json['meta_image'];
    requestStatus = json['request_status'];
    deniedNote = json['denied_note'];
    shippingCost = json['shipping_cost'];
    multiplyQty = json['multiply_qty'];
    tempShippingCost = json['temp_shipping_cost'];
    isShippingCostUpdated = json['is_shipping_cost_updated'];
    code = json['code'];
    isFaster = json['is_faster'];
    reviewsCount = json['reviews_count'];
    // if (json['translations'] != null) {
    //   translations = <Null>[];
    //   json['translations'].forEach((v) {
    //     translations!.add(Null.fromJson(v));
    //   });
    // }
    // if (json['reviews'] != null) {
    //   reviews = <dynamic>[];
    //   json['reviews'].forEach(() {
    //     reviews!.add(fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['added_by'] = addedBy;
    data['user_id'] = userId;
    data['seller_id'] = sellerId;
    data['name'] = name;
    data['slug'] = slug;
    data['product_type'] = productType;
    data['seller_category_id'] = sellerCategoryId;
    data['seller_sub_category_id'] = sellerSubCategoryId;
    data['service_type'] = serviceType;
    data['category_ids'] = categoryIds;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['sub_sub_category_id'] = subSubCategoryId;
    data['brand_id'] = brandId;
    data['unit'] = unit;
    data['min_qty'] = minQty;
    data['refundable'] = refundable;
    data['digital_product_type'] = digitalProductType;
    data['digital_file_ready'] = digitalFileReady;
    data['images'] = images;
    data['color_image'] = colorImage;
    data['thumbnail'] = thumbnail;
    data['featured'] = featured;
    data['flash_deal'] = flashDeal;
    data['video_provider'] = videoProvider;
    data['video_url'] = videoUrl;
    data['colors'] = colors;
    data['variant_product'] = variantProduct;
    data['attributes'] = attributes;
    data['choice_options'] = choiceOptions;
    data['variation'] = variation;
    data['published'] = published;
    data['unit_price'] = unitPrice;
    data['purchase_price'] = purchasePrice;
    data['tax'] = tax;
    data['tax_type'] = taxType;
    data['tax_model'] = taxModel;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['current_stock'] = currentStock;
    data['minimum_order_qty'] = minimumOrderQty;
    data['details'] = details;
    data['free_shipping'] = freeShipping;
    data['attachment'] = attachment;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['featured_status'] = featuredStatus;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['meta_image'] = metaImage;
    data['request_status'] = requestStatus;
    data['denied_note'] = deniedNote;
    data['shipping_cost'] = shippingCost;
    data['multiply_qty'] = multiplyQty;
    data['temp_shipping_cost'] = tempShippingCost;
    data['is_shipping_cost_updated'] = isShippingCostUpdated;
    data['code'] = code;
    data['is_faster'] = isFaster;
    data['reviews_count'] = reviewsCount;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Counts {
  int? pending;
  int? confirmed;
  int? completed;
  int? cancelled;
  int? rescheduled;

  Counts(
      {this.pending,
        this.confirmed,
        this.completed,
        this.cancelled,
        this.rescheduled});

  Counts.fromJson(Map<String, dynamic> json) {
    pending = json['pending'];
    confirmed = json['confirmed'];
    completed = json['completed'];
    cancelled = json['cancelled'];
    rescheduled = json['rescheduled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pending'] = pending;
    data['confirmed'] = confirmed;
    data['completed'] = completed;
    data['cancelled'] = cancelled;
    data['rescheduled'] = rescheduled;
    return data;
  }
}
