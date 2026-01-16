class SellerCategoryModel {
  int? id;
  String? name;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<SellerSubcategory>? childes;

  SellerCategoryModel(
      {this.id,
        this.name,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.childes});

  SellerCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['childes'] != null) {
      childes = <SellerSubcategory>[];
      json['childes'].forEach((v) {
        childes!.add(SellerSubcategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (childes != null) {
      data['childes'] = childes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SellerSubcategory {
  int? id;
  int? parentId;
  String? name;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;

  SellerSubcategory(
      {this.id,
        this.parentId,
        this.name,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt});

  SellerSubcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['name'] = name;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}


class SellerServiceModel {

  String? name;
  String? description;
  String? shippingCost;
  String? date;
  String? fromTime;
  String? toTime;
  String? sellerCategoryId;
  String? sellerSubCategoryId;
  String? serviceType;
  int? isFaster;
  String? discountType;
  String? unitPrice;
  String? discount;
  String? tax;
  String? taxModel;
  List<Map<String, dynamic>>? timeSlot ;

  SellerServiceModel(
      { this.name,
        this.description,
        this.shippingCost,
        this.fromTime,
        this.toTime,
        this.sellerCategoryId,
        this.sellerSubCategoryId,
        this.serviceType,
        this.isFaster,
        this.discountType,
        this.unitPrice,
        this.discount,
        this.tax,
        this.taxModel,
        this.date,
        this.timeSlot
      }
      );

}
