class BonusTransaction {
  int? id;
  int? parentId;
  int? referralId;
  String? parentType;
  String? amount;
  int? zipcode;
  String? type;
  String? transaction;
  String? level;
  String? userType;
  String? createdAt;
  String? updatedAt;
  String? referralFName;
  String? referralLName;

  BonusTransaction(
      {this.id,
      this.parentId,
      this.referralId,
      this.parentType,
      this.amount,
      this.zipcode,
      this.type,
      this.transaction,
      this.level,
      this.userType,
      this.createdAt,
      this.updatedAt,
      this.referralFName,
      this.referralLName});

  BonusTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    referralId = json['referral_id'];
    parentType = json['parent_type'];
    amount = json['amount'];
    zipcode = json['zipcode'];
    type = json['type'];
    transaction = json['transaction'];
    level = json['level'].toString();
    userType = json['user_type'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    referralFName = json['referral_f_name'];
    referralLName = json['referral_l_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['referral_id'] = this.referralId;
    data['parent_type'] = this.parentType;
    data['amount'] = this.amount;
    data['zipcode'] = this.zipcode;
    data['type'] = this.type;
    data['transaction'] = this.transaction;
    data['level'] = this.level;
    data['user_type'] = this.userType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['referral_f_name'] = this.referralFName;
    data['referral_l_name'] = this.referralLName;
    return data;
  }
}
