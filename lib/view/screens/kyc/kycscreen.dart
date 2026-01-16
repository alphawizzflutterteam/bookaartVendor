import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_sixvalley_ecommerce/data/model/response/kyc_model.dart';
// import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
// import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
// import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
// import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
// import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/kyc_model.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/profile_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../../utill/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/textfeild/custom_text_feild.dart';
// import '../../basewidget/button/custom_button.dart';
// import '../../basewidget/textfield/custom_textfield.dart';

class KYCScreen extends StatefulWidget {
  KYCScreen();

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  final TextEditingController _phoneController = TextEditingController();
  GlobalKey<FormState>? _formKey;
  final FocusNode _phoneFocus = FocusNode();
  TextEditingController userName = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  TextEditingController accountType = TextEditingController();
  TextEditingController nominiNumber = TextEditingController();
  TextEditingController relationNumber = TextEditingController();
  TextEditingController panNumber = TextEditingController();
  TextEditingController addharNumber = TextEditingController();

  int? verified = -1;
  String typeImage = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formKey = GlobalKey<FormState>();

    initUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: CustomAppBar(
            title: "KYC",
            isBackButtonExist: true,
            // isSkip: false,
          )),
      body: SingleChildScrollView(
        child: Consumer<ProfileProvider>(builder: (context, profile, child) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text("KYC"),
                  SizedBox(
                    height: 15,
                  ),
                  Image.asset(Images.kycimage,
                      height: Dimensions.paddingSizeBottomSpace),

                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    child: CustomTextField(
                      prefixIcon: const Icon(Icons.app_registration),
                      textInputType: TextInputType.text,

                      maxSize: 10,
                      // border: true,
                      controller: panNumber,
                      hintText: "Pan Number",
                    ),
                  ),
                  SizedBox(height: 5),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.document_scanner),
                    title: Text(
                      "Upload Pan Front",
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        typeImage = "panf";
                        getImageGallery();
                      },
                      child: Text("Upload"),
                    ),
                  ),
                  _panimagef == null || _panimagef == ""
                      ? profile.kycInfoModel?.pan_image != ""
                          ? Container(
                              margin: const EdgeInsets.only(
                                  left: 12, right: 12, bottom: 10),
                              height: 170,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  "${profile.kycInfoModel?.pan_image}",
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                    child: Image.asset(Images.placeholderImage),
                                  ),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Image.file(
                                _panimagef!,
                                height: 170,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.file(
                            _panimagef!,
                            height: 170,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                  SizedBox(height: 5),
                  // ListTile(
                  //   dense: true,
                  //   leading: Icon(Icons.document_scanner),
                  //   title: Text(
                  //     "Upload Pan Back",
                  //     style: TextStyle(fontSize: 16),
                  //   ),
                  //   trailing: TextButton(
                  //     onPressed: () {
                  //       typeImage = "panb";
                  //       getImageGallery();
                  //     },
                  //     child: Text("Upload"),
                  //   ),
                  // ),
                  // _panimageb == null || _panimageb == ""
                  //     ? profile.kycInfoModel?.pan_image != ""
                  //         ? Container(
                  //             margin: const EdgeInsets.only(
                  //                 left: 12, right: 12, bottom: 10),
                  //             height: 170,
                  //             width: double.infinity,
                  //             decoration: BoxDecoration(
                  //                 border:
                  //                     Border.all(width: 1, color: Colors.grey),
                  //                 borderRadius: BorderRadius.circular(10)),
                  //             child: ClipRRect(
                  //               borderRadius: BorderRadius.circular(10),
                  //               child: Image.network(
                  //                 "${profile.kycInfoModel?.pan_image}",
                  //                 fit: BoxFit.fill,
                  //                 errorBuilder: (context, error, stackTrace) =>
                  //                     Center(
                  //                   child: Text(
                  //                       "Error Loading Image!${profile.kycInfoModel?.pan_image}"),
                  //                 ),
                  //               ),
                  //             ),
                  //           )
                  //         : ClipRRect(
                  //             borderRadius: BorderRadius.circular(0),
                  //             child: Image.file(
                  //               _panimageb!,
                  //               height: 170,
                  //               width: double.infinity,
                  //               fit: BoxFit.fill,
                  //             ),
                  //           )
                  //     : ClipRRect(
                  //         borderRadius: BorderRadius.circular(0),
                  //         child: Image.file(
                  //           _panimageb!,
                  //           height: 170,
                  //           width: double.infinity,
                  //           fit: BoxFit.fill,
                  //         ),
                  //       ),

                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    child: CustomTextField(
                      prefixIcon: const Icon(Icons.app_registration),
                      textInputType: TextInputType.phone,
                      isZipCode: true,
                      maxSize: 12,
                      // border: true,
                      controller: addharNumber,
                      hintText: "Aadhaar Number",
                    ),
                  ),
                  SizedBox(height: 5),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.document_scanner),
                    title: Text(
                      "Upload Aadhaar  Front",
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        // typeImage = "pas";
                        typeImage = "aadhaarf";
                        getImageGallery();
                      },
                      child: Text("Upload"),
                    ),
                  ),
                  _aadharimagef == null || _aadharimagef == ""
                      ? profile.kycInfoModel?.adhar_front != ""
                          ? Container(
                              margin: const EdgeInsets.only(
                                  left: 12, right: 12, bottom: 10),
                              height: 170,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  "${profile.kycInfoModel?.adhar_front}",
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                    child: Image.asset(Images.placeholderImage),
                                  ),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Image.file(
                                _aadharimagef!,
                                height: 170,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.file(
                            _aadharimagef!,
                            height: 170,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),

                  SizedBox(height: 5),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.document_scanner),
                    title: Text(
                      "Upload Aadhaar Back",
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        typeImage = "aadhaarb";
                        getImageGallery();
                      },
                      child: Text("Upload"),
                    ),
                  ),
                  _aadharimageb == null || _aadharimageb == ""
                      ? profile.kycInfoModel?.adhar_back != ""
                          ? Container(
                              margin: const EdgeInsets.only(
                                  left: 12, right: 12, bottom: 10),
                              height: 170,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  "${profile.kycInfoModel?.adhar_back}",
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                    child: Image.asset(Images.placeholderImage),
                                  ),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Image.file(
                                _aadharimagef!,
                                height: 170,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.file(
                            _aadharimagef!,
                            height: 170,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Nominee",
                        style: titilliumRegular.copyWith(
                          fontSize: 20,
                          color: Provider.of<ThemeProvider>(context).darkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    child: CustomTextField(
                      prefixIcon: const Icon(Icons.app_registration),
                      textInputType: TextInputType.text,
                      // border: true,
                      controller: nominiNumber,
                      hintText: "Name",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    child: CustomTextField(
                      prefixIcon: const Icon(Icons.app_registration),
                      textInputType: TextInputType.text,
                      // border: true,
                      controller: relationNumber,
                      hintText: "Relation",
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       bottom: Dimensions.paddingSizeSmall),
                  //   child: CustomTextField(
                  //     hintText: getTranslated('ENTER_MOBILE_NUMBER', context),
                  //     prefixIcon: const Icon(Icons.phone),
                  //     controller: _phoneController,
                  //     focusNode: _phoneFocus,
                  //     // nextNode: _referalFocus,
                  //     isPhoneNumber: true,
                  //     textInputAction: TextInputAction.next,
                  //     textInputType: TextInputType.phone,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    child: CustomTextField(
                      prefixIcon: const Icon(Icons.person),
                      textInputType: TextInputType.text,
                      // border: true,
                      isValidator: true,
                      validatorMessage: 'Please Enter username',
                      controller: userName,
                      hintText: "Account Holder name",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          prefixIcon:
                              const Icon(Icons.account_balance_outlined),
                          textInputType: TextInputType.text,
                          // border: true,
                          isValidator: true,
                          validatorMessage: 'Please Enter Bank Name',
                          controller: bankName,
                          hintText: "Bank Name",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          prefixIcon:
                              const Icon(Icons.account_balance_outlined),
                          textInputType: TextInputType.number,
                          // border: true,
                          isValidator: true,
                          isZipCode: true,
                          maxSize: 18,
                          validatorMessage: 'Please Enter Account Number',
                          controller: accountNumber,
                          hintText: "Account Number",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          prefixIcon: const Icon(Icons.code),
                          textInputType: TextInputType.text,
                          // textAlign: TextAlign.start,
                          isValidator: true,
                          isZipCode: true,
                          maxSize: 11,
                          validatorMessage: 'Please Enter IFSC Code',
                          // border: true,
                          controller: ifscCode,
                          hintText: "Ifsc Code",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          prefixIcon:
                              const Icon(Icons.account_balance_outlined),
                          textInputType: TextInputType.text,
                          // border: true,
                          controller: accountType,

                          isValidator: true,
                          validatorMessage: 'Please Enter Account Type',
                          hintText: "Account Type",
                        ),
                      ],
                    ),
                  ),

                  ListTile(
                    dense: true,
                    leading: Icon(Icons.document_scanner),
                    title: Text(
                      "Upload Account",
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        typeImage = "Accountb";
                        getImageGallery();
                      },
                      child: Text("Upload"),
                    ),
                  ),
                  _accountimageb == null || _accountimageb == ""
                      ? profile.kycInfoModel?.passbook_image != ""
                          ? Container(
                              margin: const EdgeInsets.only(
                                  left: 12, right: 12, bottom: 10),
                              height: 170,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  "${profile.kycInfoModel?.passbook_image}",
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                    child: Image.asset(Images.placeholderImage),
                                  ),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Image.file(
                                _accountimageb!,
                                height: 170,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.file(
                            _accountimageb!,
                            height: 170,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),

                  // profile.userInfoModel!.accountImage != ""
                  //     ? Container(
                  //         margin: const EdgeInsets.only(
                  //             left: 12, right: 12, bottom: 10),
                  //         height: 170,
                  //         width: double.infinity,
                  //         decoration: BoxDecoration(
                  //             border: Border.all(width: 1, color: Colors.grey),
                  //             borderRadius: BorderRadius.circular(10)),
                  //         child: ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Image.network(
                  //             "${profile.userInfoModel!.accountImage}",
                  //             fit: BoxFit.fill,
                  //             errorBuilder: (context, error, stackTrace) =>
                  //                 Center(
                  //               child: Text("Error Loading Image!"),
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     : Text(""),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                  //   decoration: BoxDecoration(color: Theme.of(context).cardColor,
                  //       border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                  //       borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                  //   child: DropdownButton<int>(
                  //     value: withdraw.methodSelectedIndex,
                  //     items: withdraw.methodsIds.map((int? value) {
                  //       return DropdownMenuItem<int>(
                  //         value: withdraw.methodsIds.indexOf(value),
                  //         child: Text(withdraw.methodList[(withdraw.methodsIds.indexOf(value))].methodName!),);}).toList(),
                  //     onChanged: (int? value) {
                  //       withdraw.setMethodTypeIndex(value);
                  //     },
                  //     isExpanded: true, underline: const SizedBox(),),),

                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  verified == 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Kyc pending ",
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Consumer<ProfileProvider>(
                        builder: (context, profile, child) {
                      return CustomButton(
                          onTap: loginUser,
                          btnTxt: verified == 1
                              ? "Kyc Verified"
                              : verified == 0
                                  ? "Kyc Pending"
                                  : "Submit");
                    }),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  File? croppedFile;
  File? _image;
  File? _panimagef;
  File? _panimageb;
  File? _aadharimagef;
  File? _aadharimageb;
  File? _accountimageb;
  final picker = ImagePicker();

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 300,
        maxHeight: 400);
    if (pickedFile != null) {
      // final cropFile = await ImageCropper().cropImage(
      //     sourcePath: pickedFile.path, cropStyle: CropStyle.rectangle);
      final cropFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(toolbarTitle: 'Crop Image',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(title: 'Crop Image',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );


      Fluttertoast.showToast(msg: "Uploading Image");
      if (cropFile != null) {
        if (typeImage == "panf") {
          _panimagef = File(cropFile!.path);
        } else if (typeImage == "panb") {
          _panimageb = File(cropFile!.path);
        } else if (typeImage == "aadhaarf") {
          _aadharimagef = File(cropFile!.path);
        } else if (typeImage == "aadhaarb") {
          _aadharimageb = File(cropFile!.path);
        } else if (typeImage == "Accountb") {
          _accountimageb = File(cropFile!.path);
        }
        _image = File(cropFile!.path);
        setState(() {});
      }
    }
  }

  loginUser() async {
    if (verified == 1) {
      Fluttertoast.showToast(msg: "Already Verified");
      return;
    }

    if (_formKey!.currentState!.validate()) {
      String userNameField = userName.text.trim();
      String bankNameField = bankName.text.trim();
      String accountNumberField = accountNumber.text.trim();
      String ifscCodeField = ifscCode.text.trim();
      String accountTypeField = accountType.text.trim();
      String nominiNumberField = nominiNumber.text.trim();
      String relationNumberField = relationNumber.text.trim();
      String panNumberField = panNumber.text.trim();
      String addharNumberField = addharNumber.text.trim();
      if (userNameField.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter username"),
          backgroundColor: Colors.red,
        ));
      } else if (bankNameField.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter Bank Name"),
          backgroundColor: Colors.red,
        ));
      } else if (accountNumberField.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter Account Number"),
          backgroundColor: Colors.red,
        ));
      } else if (ifscCodeField.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter IFSC Code"),
          backgroundColor: Colors.red,
        ));
      } else if (accountTypeField.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter accountTypeField"),
          backgroundColor: Colors.red,
        ));
      } else if (accountTypeField.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter accountTypeField"),
          backgroundColor: Colors.red,
        ));
      } else if (nominiNumberField.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter accountTypeField"),
          backgroundColor: Colors.red,
        ));
      } else if (relationNumberField.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter accountTypeField"),
          backgroundColor: Colors.red,
        ));
      } else if (panNumberField.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter Pan Number"),
          backgroundColor: Colors.red,
        ));
      } else if (panNumberField.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter valid Pan Number "),
          backgroundColor: Colors.red,
        ));
      } else if (addharNumberField.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter Aadhaar"),
          backgroundColor: Colors.red,
        ));
      } else if (addharNumberField.length != 12) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter valid Aadhaar"),
          backgroundColor: Colors.red,
        ));
      } else {
        KYCModel register = KYCModel();
        register.user_id = int.parse("25");
        register.pan_number = panNumber.text;
        register.holder_name = userName.text;
        register.adhar_number = addharNumber.text;
        register.nomini_name = nominiNumber.text;
        register.nomini_relation = relationNumber.text;
        register.account_number = accountNumber.text;
        register.ifsc = ifscCode.text;
        register.bank_name = bankName.text;
        register.type = "user";
        await Provider.of<ProfileProvider>(context, listen: false)
            .updateKYC(register, _panimagef, _aadharimagef, _aadharimageb,
                _accountimageb, "")
            .then((value) {
          Fluttertoast.showToast(msg: "Profile Updated Successfully");

          Navigator.pop(context);
        });
      }
    }
  }

  route(bool isRoute, String? token, String? temporaryToken,
      String errorMessage) async {}

  Future<void> initUI() async {
    KYCModel? kycModel =
        await Provider.of<ProfileProvider>(context, listen: false).getUserKYC(
            context,
            Provider.of<ProfileProvider>(context, listen: false)
                .userInfoModel!
                .id
                .toString());

    if (kycModel != null) {
      userName.text = kycModel.holder_name.toString();
      bankName.text = kycModel.bank_name.toString();
      accountNumber.text = kycModel.account_number.toString();
      ifscCode.text = kycModel.ifsc.toString();
      accountType.text = kycModel.type.toString();
      nominiNumber.text = kycModel.nomini_name.toString();
      relationNumber.text = kycModel.nomini_relation.toString();
      panNumber.text = kycModel.pan_number.toString();
      addharNumber.text = kycModel.adhar_number.toString();

      verified = kycModel?.status;
    }

    // TextEditingController userName = TextEditingController();
    // TextEditingController bankName = TextEditingController();
    // TextEditingController accountNumber = TextEditingController();
    // TextEditingController ifscCode = TextEditingController();
    // TextEditingController accountType = TextEditingController();
    // TextEditingController nominiNumber = TextEditingController();
    // TextEditingController relationNumber = TextEditingController();
    // TextEditingController panNumber = TextEditingController();
    // TextEditingController addharNumber = TextEditingController();
  }
}
