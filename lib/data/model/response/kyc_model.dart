class KYCModel {
  int? user_id;
  int? status;
  String? type;
  String? pan_number;
  String? adhar_number;
  String? nomini_name;
  String? nomini_relation;
  String? account_number;
  String? holder_name;
  String? ifsc;
  String? bank_name;
  String? pan_image;
  String? adhar_front;
  String? adhar_back;
  String? passbook_image;
  String? panback;
  String? aadharback;
  String? aadharfront;
  String? accountImage;

  KYCModel({
    this.user_id,
    this.status,
    this.type,
    this.pan_number,
    this.adhar_number,
    this.nomini_name,
    this.nomini_relation,
    this.account_number,
    this.holder_name,
    this.ifsc,
    this.bank_name,
    this.pan_image,
    this.adhar_front,
    this.adhar_back,
    this.passbook_image,
  });

  KYCModel.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    type = json['type'];
    status = json['status'];
    pan_number = json['pan_number'];
    adhar_number = json['adhar_number'];
    nomini_name = json['nomini_name'];
    nomini_relation = json['nomini_relation'];
    account_number = json['account_number'];
    holder_name = json['holder_name'];
    ifsc = json['ifsc'];

    bank_name = json['bank_name'];
    pan_image = json['pan_image'];
    adhar_front = json['adhar_front'];
    adhar_back = json['adhar_back'];
    passbook_image = json['passbook_image'];
    aadharback = json['aadharback'];
    aadharfront = json['aadharfront'];
    accountImage = json['accountImage'];
    panback = json['panback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = user_id;
    data['status'] = status;
    data['type'] = type;
    data['pan_number'] = pan_number;
    data['adhar_number'] = adhar_number;
    data['nomini_name'] = nomini_name;
    data['nomini_relation'] = nomini_relation;
    data['account_number'] = account_number;
    data['holder_name'] = holder_name;
    data['ifsc'] = ifsc;
    data['bank_name'] = bank_name;
    data['pan_image'] = pan_image;
    data['adhar_front'] = adhar_front;
    data['adhar_back'] = adhar_back;
    data['passbook_image'] = passbook_image;
    return data;
  }
}
