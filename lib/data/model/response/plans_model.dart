// class PlansModel {
//   bool? status;
//   List<Data>? data;

//   PlansModel({this.status, this.data});

//   PlansModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Data {
//   int? id;
//   String? title;
//   String? description;
//   int? amount;
//   int? discountAmount;
//   int? days;
//   Null? level;
//   int? status;
//   int? frenchiseBonus;
//   int? districtBonus;
//   int? stateBonus;
//   int? shopBonus;
//   int? repurchaseFrenchiseBonus;
//   int? repurchaseDistrictBonus;
//   int? repurchaseStateBonus;
//   int? selfPurchaseBonus;
//   Null? dailyBonusTillDays;
//   Null? dailyBonusLimit;
//   String? createdAt;
//   String? updatedAt;
//   List<Null>? levels;

//   Data(
//       {this.id,
//       this.title,
//       this.description,
//       this.amount,
//       this.discountAmount,
//       this.days,
//       this.level,
//       this.status,
//       this.frenchiseBonus,
//       this.districtBonus,
//       this.stateBonus,
//       this.shopBonus,
//       this.repurchaseFrenchiseBonus,
//       this.repurchaseDistrictBonus,
//       this.repurchaseStateBonus,
//       this.selfPurchaseBonus,
//       this.dailyBonusTillDays,
//       this.dailyBonusLimit,
//       this.createdAt,
//       this.updatedAt,
//       this.levels});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     description = json['description'];
//     amount = json['amount'];
//     discountAmount = json['discount_amount'];
//     days = json['days'];
//     level = json['level'];
//     status = json['status'];
//     frenchiseBonus = json['frenchise_bonus'];
//     districtBonus = json['district_bonus'];
//     stateBonus = json['state_bonus'];
//     shopBonus = json['shop_bonus'];
//     repurchaseFrenchiseBonus = json['repurchase_frenchise_bonus'];
//     repurchaseDistrictBonus = json['repurchase_district_bonus'];
//     repurchaseStateBonus = json['repurchase_state_bonus'];
//     selfPurchaseBonus = json['self_purchase_bonus'];
//     dailyBonusTillDays = json['daily_bonus_till_days'];
//     dailyBonusLimit = json['daily_bonus_limit'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     // if (json['levels'] != null) {
//     //   levels = <Null>[];
//     //   json['levels'].forEach((v) {
//     //     levels!.add(new Null.fromJson(v));
//     //   });
//     // }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     data['description'] = this.description;
//     data['amount'] = this.amount;
//     data['discount_amount'] = this.discountAmount;
//     data['days'] = this.days;
//     data['level'] = this.level;
//     data['status'] = this.status;
//     data['frenchise_bonus'] = this.frenchiseBonus;
//     data['district_bonus'] = this.districtBonus;
//     data['state_bonus'] = this.stateBonus;
//     data['shop_bonus'] = this.shopBonus;
//     data['repurchase_frenchise_bonus'] = this.repurchaseFrenchiseBonus;
//     data['repurchase_district_bonus'] = this.repurchaseDistrictBonus;
//     data['repurchase_state_bonus'] = this.repurchaseStateBonus;
//     data['self_purchase_bonus'] = this.selfPurchaseBonus;
//     data['daily_bonus_till_days'] = this.dailyBonusTillDays;
//     data['daily_bonus_limit'] = this.dailyBonusLimit;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     // if (this.levels != null) {
//     //   data['levels'] = this.levels!.map((v) => v?.toJson()).toList();
//     // }
//     return data;
//   }
// }
