class FlashDealsModelList {
  List<FlashDealsModel>? data;

  FlashDealsModelList({this.data});

  FlashDealsModelList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FlashDealsModel>[];
      json['data'].forEach((v) {
        data!.add(new FlashDealsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FlashDealsModel {
  int? id;
  String? title;
  String? startDate;
  String? endDate;
  int? status;
  int? featured;
  Null? backgroundColor;
  Null? textColor;
  String? banner;
  String? slug;
  String? createdAt;
  String? updatedAt;
  Null? productId;
  String? dealType;
  List<FlashDealProductsModel>? products;
  int? sellerProductsCount;

  FlashDealsModel(
      {this.id,
      this.title,
      this.startDate,
      this.endDate,
      this.status,
      this.featured,
      this.backgroundColor,
      this.textColor,
      this.banner,
      this.slug,
      this.createdAt,
      this.updatedAt,
      this.productId,
      this.products,
      this.dealType,
      this.sellerProductsCount});

  FlashDealsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    featured = json['featured'];
    backgroundColor = json['background_color'];
    textColor = json['text_color'];
    banner = json['banner'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productId = json['product_id'];
    dealType = json['deal_type'];
    if (json['products'].length > 0) {
      products = <FlashDealProductsModel>[];
      json['products'].forEach((v) {
        products!.add(new FlashDealProductsModel.fromJson(v));
      });
      sellerProductsCount = json['seller_products_count'];
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['title'] = this.title;
      data['start_date'] = this.startDate;
      data['end_date'] = this.endDate;
      data['status'] = this.status;
      data['featured'] = this.featured;
      data['background_color'] = this.backgroundColor;
      data['text_color'] = this.textColor;
      data['banner'] = this.banner;
      data['slug'] = this.slug;
      data['created_at'] = this.createdAt;
      data['updated_at'] = this.updatedAt;
      data['product_id'] = this.productId;
      data['deal_type'] = this.dealType;
      data['seller_products_count'] = this.sellerProductsCount;
      return data;
    }
  }

  toJson() {}
}

class FlashDealProductsModel {
  int? id;
  int? flashDealId;
  int? productId;
  int? discount;
  Null? discountType;
  String? sellerType;
  int? sellerId;
  int? status;
  String? name;
  int? unitPrice;
  String? createdAt;
  String? updatedAt;

  FlashDealProductsModel(
      {this.id,
      this.flashDealId,
      this.productId,
      this.discount,
      this.discountType,
      this.sellerType,
      this.sellerId,
      this.name,
      this.unitPrice,
      this.status,
      this.createdAt,
      this.updatedAt});

  FlashDealProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flashDealId = json['flash_deal_id'];
    productId = json['product_id'];
    discount = json['discount'];
    discountType = json['discount_type'];
    sellerType = json['seller_type'];
    sellerId = json['seller_id'];
    name = json['name'];
    unitPrice = json['unit_price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['flash_deal_id'] = this.flashDealId;
    data['product_id'] = this.productId;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['seller_type'] = this.sellerType;
    data['seller_id'] = this.sellerId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
