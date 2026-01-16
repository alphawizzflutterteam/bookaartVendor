import 'dart:convert';

class PlanhistoryModel {
  final bool? status;
  final Data? data;

  PlanhistoryModel({
    this.status,
    this.data,
  });

  factory PlanhistoryModel.fromRawJson(String str) =>
      PlanhistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlanhistoryModel.fromJson(Map<String, dynamic> json) =>
      PlanhistoryModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  final DateTime? purchaseDate;
  final DateTime? expireDate;
  final Plan? activePlan;
  final List<PlanHistory>? planHistory;

  Data({
    this.purchaseDate,
    this.expireDate,
    this.activePlan,
    this.planHistory,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        purchaseDate: json["purchase_date"] == null
            ? null
            : DateTime.parse(json["purchase_date"]),
        expireDate: json["expire_date"] == null
            ? null
            : DateTime.parse(json["expire_date"]),
        activePlan: json["active_plan"] == null
            ? null
            : Plan.fromJson(json["active_plan"]),
        planHistory: json["plan_history"] == null
            ? []
            : List<PlanHistory>.from(
                json["plan_history"]!.map((x) => PlanHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "purchase_date":
            "${purchaseDate!.year.toString().padLeft(4, '0')}-${purchaseDate!.month.toString().padLeft(2, '0')}-${purchaseDate!.day.toString().padLeft(2, '0')}",
        "expire_date":
            "${expireDate!.year.toString().padLeft(4, '0')}-${expireDate!.month.toString().padLeft(2, '0')}-${expireDate!.day.toString().padLeft(2, '0')}",
        "active_plan": activePlan?.toJson(),
        "plan_history": planHistory == null
            ? []
            : List<dynamic>.from(planHistory!.map((x) => x.toJson())),
      };
}

class Plan {
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

  Plan({
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
  });

  factory Plan.fromRawJson(String str) => Plan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        title: json["title"]!,
        description: json["description"]!,
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
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
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
      };
}

// enum Description { P_TEST_P, P_TEST_PLAN_NBSP_P }

// final descriptionValues = EnumValues({
//   "<p>test</p>": Description.P_TEST_P,
//   "<p>test plan&nbsp;</p>": Description.P_TEST_PLAN_NBSP_P
// });

class PlanHistory {
  final int? id;
  final dynamic userId;
  final int? sellerId;
  final int? planId;
  final String? transactionId;
  final String? amount;
  final String? remark;
  final String? status;
  final DateTime? expireDate;
  final DateTime? createdAt;
  final dynamic updatedAt;
  final Plan? plan;

  PlanHistory({
    this.id,
    this.userId,
    this.sellerId,
    this.planId,
    this.transactionId,
    this.amount,
    this.remark,
    this.status,
    this.expireDate,
    this.createdAt,
    this.updatedAt,
    this.plan,
  });

  factory PlanHistory.fromRawJson(String str) =>
      PlanHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlanHistory.fromJson(Map<String, dynamic> json) => PlanHistory(
        id: json["id"],
        userId: json["user_id"],
        sellerId: json["seller_id"],
        planId: json["plan_id"],
        transactionId: json["transaction_id"],
        amount: json["amount"],
        remark: json["remark"],
        status: json["status"],
        expireDate: json["expire_date"] == null
            ? null
            : DateTime.parse(json["expire_date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "seller_id": sellerId,
        "plan_id": planId,
        "transaction_id": transactionId,
        "amount": amount,
        "remark": remark,
        "status": status,
        "expire_date":
            "${expireDate!.year.toString().padLeft(4, '0')}-${expireDate!.month.toString().padLeft(2, '0')}-${expireDate!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
        "plan": plan?.toJson(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
