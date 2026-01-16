class RegisterModel {
  String? fName;
  String? deviceToken;
  String? lName;
  String? phone;
  String? email;
  String? password;
  String? confirmPassword;
  String? shopName;
  String? shopAddress;
  String? zipCode;
  String? area;
  String? city;
  String? state;
  String? gstNumber;
  String? sellerCategory;
  String? sellerSubCategory;
  String? aadharNumber;
  RegisterModel(
      {this.fName,
      this.deviceToken,
      this.lName,
      this.phone,
      this.email,
      this.password,
      this.confirmPassword,
      this.shopName,
      this.shopAddress,
      this.area,
      this.city,
      this.state,
      this.zipCode,
      this.gstNumber, this.aadharNumber,this.sellerCategory,this.sellerSubCategory});
}
