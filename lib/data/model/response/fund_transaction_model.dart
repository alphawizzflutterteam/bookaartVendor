class FundTransaction {
  bool? status;
  String? message;
  List<FundTransactionData>? data;

  FundTransaction({this.status, this.message, this.data});

  FundTransaction.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FundTransactionData>[];
      json['data'].forEach((v) {
        data!.add(new FundTransactionData.fromJson(v));
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

class FundTransactionData {
  int? id;
  int? userId;
  int? amount;
  String? transactionId;
  String? image;
  int? status;
  Null? remark;
  String? createdAt;
  String? updatedAt;

  FundTransactionData(
      {this.id,
      this.userId,
      this.amount,
      this.transactionId,
      this.image,
      this.status,
      this.remark,
      this.createdAt,
      this.updatedAt});

  FundTransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    amount = json['amount'];
    transactionId = json['transaction_id'];
    image = json['image'];
    status = json['status'];
    remark = json['remark'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['transaction_id'] = this.transactionId;
    data['image'] = this.image;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
