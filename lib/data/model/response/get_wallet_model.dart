class WalletModel {
  bool? status;
  String? message;
  List<WalletData>? data;

  WalletModel({this.status, this.message, this.data});

  WalletModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WalletData>[];
      json['data'].forEach((v) {
        data!.add(new WalletData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WalletData {
  int? id;
  int? userId;
  String? transactionId;
  String? type;
  String? amount;
  int? status;
  String? remark;
  String? createdAt;
  Null? updatedAt;

  WalletData(
      {this.id,
      this.userId,
      this.transactionId,
      this.type,
      this.amount,
      this.status,
      this.remark,
      this.createdAt,
      this.updatedAt});

  WalletData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    transactionId = json['transaction_id'];
    type = json['type'];
    amount = json['amount'];
    status = json['status'];
    remark = json['remark'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['transaction_id'] = this.transactionId;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
