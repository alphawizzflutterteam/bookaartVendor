import 'dart:convert';

class ManageServiceModel {
  final int? id;
  final String? addedBy;
  final int? userId;
  final String? name;
  final String? slug;
  final String? productType;
  final String? serviceType;
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
   int? status;
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
  final List<TimeSlot>? timeSlots;
  final List<dynamic>? rating;
  final List<dynamic>? reviews;
  final List<dynamic>? translations;

  ManageServiceModel({
    this.id,
    this.addedBy,
    this.userId,
    this.name,
    this.slug,
    this.productType,
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
    this.reviewsCount,
    this.timeSlots,
    this.rating,
    this.reviews,
    this.translations,this.serviceType
  });

  factory ManageServiceModel.fromRawJson(String str) =>
      ManageServiceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ManageServiceModel.fromJson(Map<String, dynamic> json) =>
      ManageServiceModel(
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
        images: json["images"] ,
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
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
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
        serviceType: json["service_type"],
        reviewsCount: json["reviews_count"],
        timeSlots: json["time_slots"] == null
            ? []
            : List<TimeSlot>.from(
                json["time_slots"]!.map((x) => TimeSlot.fromJson(x))),
        rating: json["rating"] == null
            ? []
            : List<dynamic>.from(json["rating"]!.map((x) => x)),
        reviews: json["reviews"] == null
            ? []
            : List<dynamic>.from(json["reviews"]!.map((x) => x)),
        translations: json["translations"] == null
            ? []
            : List<dynamic>.from(json["translations"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "added_by": addedBy,
        "user_id": userId,
        "name": name,
        "slug": slug,
        "product_type": productType,
        "category_ids": categoryIds,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "sub_sub_category_id": subSubCategoryId,
        "brand_id": brandId,
        "unit": unit,
        "min_qty": minQty,
        "refundable": refundable,
        "digital_product_type": digitalProductType,
        "digital_file_ready": digitalFileReady,
        "images": images,
        "color_image": colorImage,
        "thumbnail": thumbnail,
        "featured": featured,
        "flash_deal": flashDeal,
        "video_provider": videoProvider,
        "video_url": videoUrl,
        "colors": colors,
        "variant_product": variantProduct,
        "attributes": attributes,
        "choice_options": choiceOptions,
        "variation": variation,
        "published": published,
        "unit_price": unitPrice,
        "purchase_price": purchasePrice,
        "tax": tax,
        "tax_type": taxType,
        "tax_model": taxModel,
        "discount": discount,
        "discount_type": discountType,
        "current_stock": currentStock,
        "minimum_order_qty": minimumOrderQty,
        "details": details,
        "free_shipping": freeShipping,
        "attachment": attachment,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status,
        "featured_status": featuredStatus,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "meta_image": metaImage,
        "request_status": requestStatus,
        "denied_note": deniedNote,
        "shipping_cost": shippingCost,
        "multiply_qty": multiplyQty,
        "temp_shipping_cost": tempShippingCost,
        "is_shipping_cost_updated": isShippingCostUpdated,
        "code": code,
        "service_type":serviceType,
        "reviews_count": reviewsCount,
        "time_slots": timeSlots == null
            ? []
            : List<dynamic>.from(timeSlots!.map((x) => x.toJson())),
        "rating":
            rating == null ? [] : List<dynamic>.from(rating!.map((x) => x)),
        "reviews":
            reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x)),
        "translations": translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x)),
      };
}

class TimeSlot {
  final int? id;
  final int? sellerId;
  final int? serviceId;
  final String? fromTime;
  final String? toTime;
  final String? date;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TimeSlot({
    this.id,
    this.sellerId,
    this.serviceId,
    this.fromTime,
    this.toTime,
    this.status,
    this.createdAt,
    this.updatedAt,this.date
  });

  factory TimeSlot.fromRawJson(String str) =>
      TimeSlot.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        id: json["id"],
        sellerId: json["seller_id"],
        serviceId: json["service_id"],
        fromTime: json["from_time"],
        toTime: json["to_time"],
        status: json["status"],
        date: json["date"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "seller_id": sellerId,
        "service_id": serviceId,
        "from_time": fromTime,
        "to_time": toTime,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
