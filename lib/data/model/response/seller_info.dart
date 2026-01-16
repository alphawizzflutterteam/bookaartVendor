class SellerModel {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? image;
  String? email;
  String? password;
  String? status;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;
  String? bankName;
  String? branch;
  String? accountNo;
  String? holderName;
  String? ifscNo;
  String? authToken;
  double? salesCommissionPercentage;
  String? gst;
  int? productCount;
  int? serviceCount;
  int? ordersCount;
  String? wallet_maintain;
  int? sellerCategoryId;
  int? sellerSubCategoryId;
  String? certificate;
  double? earning_wallet;
  Wallet? wallet;
  int? planStatus;
  int? planId;
  String? startDate;
  String? endDate;
  String? type;
  String? uniqueCode;
  String? address;
  String? city;
  String? area;
  String? state;
  String? zipCode;

  SellerModel(
      {this.id,
      this.fName,
      this.lName,
      this.phone,
      this.image,
      this.email,
      this.password,
      this.status,
      this.rememberToken,
      this.createdAt,
      this.updatedAt,
      this.bankName,
      this.branch,
      this.accountNo,
      this.holderName,
      this.ifscNo,
      this.authToken,
      this.salesCommissionPercentage,
      this.gst,
      this.productCount,
      this.ordersCount,
      this.serviceCount,
      this.certificate,
      this.earning_wallet,
      this.wallet,
      this.planStatus,
      this.planId,
      this.startDate,
      this.endDate,
      this.type,
      this.uniqueCode,
      this.address,
      this.area,
      this.city,
      this.state,
      this.zipCode,this.sellerCategoryId,this.sellerSubCategoryId});

  SellerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerCategoryId =    json['seller_category_id'];
    sellerSubCategoryId = json['seller_sub_category_id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    image = json['image'];
    email = json['email'];
    password = json['password'];
    status = json['status'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bankName = json['bank_name'];
    branch = json['branch'];
    accountNo = json['account_no'];
    holderName = json['holder_name'];
    ifscNo = json['ifsc_no'];
    authToken = json['auth_token'];
    wallet_maintain = json['minimum_wallet_maintain'].toString();
    certificate = json['certificate'].toString();
    earning_wallet = double.parse(json['earning_wallet'].toString());
    if (json['sales_commission_percentage'] != null) {
      try {
        salesCommissionPercentage =
            (json['sales_commission_percentage']).toDouble();
      } catch (e) {
        salesCommissionPercentage =
            double.parse(json['sales_commission_percentage'].toString());
      }
    }
    if (json['gst'] != null) {
      gst = json['gst'];
    }
    productCount = json['product_count'];
    ordersCount = json['orders_count'];
    serviceCount = json['service_count'];
    type = json['type'];
    uniqueCode = json['unique_code'];
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    planStatus = json['plan_status'];
    planId = json['plan_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    address = json['address'];
    zipCode = json['zipcode'];
    area = json['area'];
    city = json['city'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['seller_category_id'] = sellerCategoryId;
    data['seller_sub_category_id'] =sellerSubCategoryId;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['earning_wallet'] = earning_wallet;
    data['image'] = image;
    data['certificate'] = certificate;
    data['wallet_maintain'] = wallet_maintain;
    data['email'] = email;
    data['password'] = password;
    data['status'] = status;
    data['remember_token'] = rememberToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['bank_name'] = bankName;
    data['branch'] = branch;
    data['account_no'] = accountNo;
    data['holder_name'] = holderName;
    data['ifsc_no'] = ifscNo;
    data['auth_token'] = authToken;
    data['sales_commission_percentage'] = salesCommissionPercentage;
    data['gst'] = gst;
    data['product_count'] = productCount;
    data['orders_count'] = ordersCount;
    data['address'] = address;
    data['zipcode'] = zipCode;
    data['area'] = area;
    data['city'] = city;
    data['state'] = state;
    data['type'] = type;
    data['unique_code'] = uniqueCode;
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    data['plan_status'] = this.planStatus;
    data['plan_id'] = this.planId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}

class Wallet {
  int? id;
  double? totalEarning;
  double? withdrawn;
  String? createdAt;
  String? updatedAt;
  String? minimum_wallet;
  double? commissionGiven;
  double? pendingWithdraw;
  double? deliveryChargeEarned;
  double? collectedCash;
  double? totalTaxCollected;

  Wallet(
      {this.id,
      this.totalEarning,
      this.withdrawn,
      this.createdAt,
      this.updatedAt,
      this.commissionGiven,
      this.pendingWithdraw,
      this.deliveryChargeEarned,
      this.collectedCash,
      this.totalTaxCollected});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalEarning = json['total_earning'].toDouble();
    withdrawn = json['withdrawn'].toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    minimum_wallet = json['minimum_wallet'].toString();
    commissionGiven = json['commission_given'].toDouble();
    pendingWithdraw = json['pending_withdraw'].toDouble();
    deliveryChargeEarned = json['delivery_charge_earned'].toDouble();
    collectedCash = json['collected_cash'].toDouble();
    totalTaxCollected = json['total_tax_collected'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['total_earning'] = totalEarning;
    data['withdrawn'] = withdrawn;
    data['created_at'] = createdAt;
    data['minimum_wallet'] = minimum_wallet;
    data['updated_at'] = updatedAt;
    data['commission_given'] = commissionGiven;
    data['pending_withdraw'] = pendingWithdraw;
    data['delivery_charge_earned'] = deliveryChargeEarned;
    data['collected_cash'] = collectedCash;
    data['total_tax_collected'] = totalTaxCollected;
    return data;
  }
}
