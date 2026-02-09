class SellerBody {
  String? _sMethod;
  String? _fName;
  String? _lName;
  String? _description;
  String? _bankName;
  String? _branch;
  String? _accountNo;
  String? _ifscNo;
  String? _holderName;
  String? _password;
  String? _image;
  String? _type;
  int? _categoryId;
  int? _subCategoryId;

  SellerBody(
      {String? sMethod,
      String? fName,
      String? lName,
      String? description,
      String? bankName,
      String? branch,
      String? accountNo,
      String? holderName,
      String? password,
      String? image,
      String? type,
      String? ifscNo,
      int? categoryId,
      int? subCategoryId}) {
    _sMethod = sMethod;
    _fName = fName;
    _lName = lName;
    _description = description;
    _bankName = bankName;
    _branch = branch;
    _accountNo = accountNo;
    _ifscNo = ifscNo;
    _holderName = holderName;
    _password = password;
    _image = image;
    _type = type;
    _categoryId = categoryId;
    _subCategoryId = subCategoryId;
  }

  String? get sMethod => _sMethod;
  String? get fName => _fName;
  String? get lName => _lName;
  String? get description => _description;
  String? get bankName => _bankName;
  String? get branch => _branch;
  String? get accountNo => _accountNo;
  String? get ifscNo => _ifscNo;
  String? get holderName => _holderName;
  String? get password => _password;
  String? get image => _image;
  String? get type => _type;
  int? get categoryId => _categoryId;
  int? get subCategoryId => _subCategoryId;

  SellerBody.fromJson(Map<String, dynamic> json) {
    _sMethod = json['_method'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _description = json['_description'];
    _bankName = json['bank_name'];
    _branch = json['branch'];
    _accountNo = json['account_no'];
    _ifscNo = json['ifsc_code'];
    _holderName = json['holder_name:'];
    _password = json['password'];
    _image = json['image'];
    _type = json['type'];
    _categoryId = json['seller_category_id'];
    _subCategoryId = json['seller_sub_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_method'] = _sMethod;
    data['f_name'] = _fName;
    data['l_name'] = _lName;
    data['_description'] = _description;
    data['bank_name'] = _bankName;
    data['branch'] = _branch;
    data['account_no'] = _accountNo;
    data['ifsc_code'] = _ifscNo;
    data['holder_name:'] = _holderName;
    data['password'] = _password;
    data['image'] = _image;
    data['type'] = _type;
    data['seller_category_id'] = _categoryId;
    data['seller_sub_category_id'] = _subCategoryId;
    return data;
  }
}
