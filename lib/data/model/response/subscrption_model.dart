import 'dart:convert';

class SubscriptionModel {
    final bool? status;
    final List<SubscriptionList>? data;

    SubscriptionModel({
        this.status,
        this.data,
    });

    factory SubscriptionModel.fromRawJson(String str) => SubscriptionModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SubscriptionModel.fromJson(Map<String, dynamic> json) => SubscriptionModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<SubscriptionList>.from(json["data"]!.map((x) => SubscriptionList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class SubscriptionList {
    final int? id;
    final String? title;
    final String? description;
    final int? amount;
    final int? discountAmount;
    final int? days;
    final dynamic level;
    final int? status;
    final int? frenchiseBonus;
    final int? districtBonus;
    final int? stateBonus;
    final int? shopBonus;
    final int? repurchaseFrenchiseBonus;
    final int? repurchaseDistrictBonus;
    final int? repurchaseStateBonus;
    final int? selfPurchaseBonus;
    final dynamic dailyBonusTillDays;
    final dynamic dailyBonusLimit;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final List<dynamic>? levels;

    SubscriptionList({
        this.id,
        this.title,
        this.description,
        this.amount,
        this.discountAmount,
        this.days,
        this.level,
        this.status,
        this.frenchiseBonus,
        this.districtBonus,
        this.stateBonus,
        this.shopBonus,
        this.repurchaseFrenchiseBonus,
        this.repurchaseDistrictBonus,
        this.repurchaseStateBonus,
        this.selfPurchaseBonus,
        this.dailyBonusTillDays,
        this.dailyBonusLimit,
        this.createdAt,
        this.updatedAt,
        this.levels,
    });

    factory SubscriptionList.fromRawJson(String str) => SubscriptionList.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SubscriptionList.fromJson(Map<String, dynamic> json) => SubscriptionList(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        amount: json["amount"],
        discountAmount: json["discount_amount"],
        days: json["days"],
        level: json["level"],
        status: json["status"],
        frenchiseBonus: json["frenchise_bonus"],
        districtBonus: json["district_bonus"],
        stateBonus: json["state_bonus"],
        shopBonus: json["shop_bonus"],
        repurchaseFrenchiseBonus: json["repurchase_frenchise_bonus"],
        repurchaseDistrictBonus: json["repurchase_district_bonus"],
        repurchaseStateBonus: json["repurchase_state_bonus"],
        selfPurchaseBonus: json["self_purchase_bonus"],
        dailyBonusTillDays: json["daily_bonus_till_days"],
        dailyBonusLimit: json["daily_bonus_limit"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        levels: json["levels"] == null ? [] : List<dynamic>.from(json["levels"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "amount": amount,
        "discount_amount": discountAmount,
        "days": days,
        "level": level,
        "status": status,
        "frenchise_bonus": frenchiseBonus,
        "district_bonus": districtBonus,
        "state_bonus": stateBonus,
        "shop_bonus": shopBonus,
        "repurchase_frenchise_bonus": repurchaseFrenchiseBonus,
        "repurchase_district_bonus": repurchaseDistrictBonus,
        "repurchase_state_bonus": repurchaseStateBonus,
        "self_purchase_bonus": selfPurchaseBonus,
        "daily_bonus_till_days": dailyBonusTillDays,
        "daily_bonus_limit": dailyBonusLimit,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "levels": levels == null ? [] : List<dynamic>.from(levels!.map((x) => x)),
    };
}
