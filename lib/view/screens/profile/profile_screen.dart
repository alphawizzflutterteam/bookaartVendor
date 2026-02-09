import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/body/seller_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/seller_info.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/provider/bank_info_provider.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/custom_image.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../provider/shop_provider.dart';
import '../../../widgets/app_dropdown.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _discriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController shopAddressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController areaController = TextEditingController();

  File? file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  TextEditingController typeController = TextEditingController();

  void _choose(ImageSource source) async {
    final pickedFile = await picker.pickImage(
        source: source, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  Future<void> _showSelectionDialog() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select image source'),
        actions: [
          TextButton(
            child: const Text('Camera'),
            onPressed: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          TextButton(
            child: const Text('Gallery'),
            onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
        ],
      ),
    );
    if (source != null) {
      _choose(source);
    }
  }

  List<File> imageFiles = [];
  List<File> pdfFiles = [];

  List<File> multipleFiles = [];
  Future<void> pickMultipleImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        imageFiles.addAll(
          result.paths.map((path) => File(path!)).toList(),
        );
      });
    }
  }

  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        pdfFiles.add(File(result.files.single.path!));
      });
    }
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;

  List<DateTime> getCurrentWeekDates() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1));

    return List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );
  }

  Future<void> pickTime() async {
    TimeOfDay? from = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (from == null) return;

    TimeOfDay? to = await showTimePicker(
      context: context,
      initialTime: from.replacing(hour: from.hour + 1),
    );
    if (to == null) return;

    final fromMin = from.hour * 60 + from.minute;
    final toMin = to.hour * 60 + to.minute;

    if (toMin <= fromMin) {
      to = TimeOfDay(
          hour: from.hour + 1 > 23 ? 23 : from.hour + 1, minute: from.minute);
    }

    setState(() {
      dateTimeSlots.putIfAbsent(selectedDateKey, () => []);
      dateTimeSlots[selectedDateKey]!.add(TimeRange(from: from, to: to!));
    });
  }

  _updateUserAccount() async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String password0 = _passwordController.text.trim();
    String description = _discriptionController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String type = typeController.text.trim();

    // Basic validations
    if (firstName.isEmpty) {
      showCustomSnackBar(getTranslated('enter_first_name', context), context);
      return;
    } else if (lastName.isEmpty) {
      showCustomSnackBar(getTranslated('enter_last_name', context), context);
      return;
    } else if (phoneNumber.isEmpty) {
      showCustomSnackBar(getTranslated('enter_phone_number', context), context);
      return;
    } else if ((password0.isNotEmpty && password0.length < 6) ||
        (confirmPassword.isNotEmpty && confirmPassword.length < 6)) {
      showCustomSnackBar(
          getTranslated('password_be_at_least', context), context);
      return;
    } else if (password0 != confirmPassword) {
      showCustomSnackBar(
          getTranslated('password_did_not_match', context), context);
      return;
    }

    // ✅ Time Slot validation
    if (dateTimeSlots.isEmpty ||
        dateTimeSlots.values.every((slots) => slots.isEmpty)) {
      showCustomSnackBar("Please select From & To time slots.", context);
      return;
    }

    // ✅ Upload Work validation
    if (imageFiles.isEmpty) {
      showCustomSnackBar("Please upload at least one work image.", context);
      return;
    }

    // Prepare User Info Model
    SellerModel updateUserInfoModel =
        Provider.of<ProfileProvider>(context, listen: false).userInfoModel!;
    updateUserInfoModel.fName = firstName;
    updateUserInfoModel.lName = lastName;
    updateUserInfoModel.phone = phoneNumber;
    updateUserInfoModel.description = description;
    updateUserInfoModel.type = type;
    updateUserInfoModel.address = shopAddressController.text;
    updateUserInfoModel.city = cityController.text;
    updateUserInfoModel.state = stateController.text;
    updateUserInfoModel.area = areaController.text;
    updateUserInfoModel.zipCode = zipCodeController.text;
    updateUserInfoModel.sellerCategoryId =
        Provider.of<SellerProvider>(context, listen: false)
            .selectedSellerCateId;
    updateUserInfoModel.sellerSubCategoryId =
        Provider.of<SellerProvider>(context, listen: false)
            .selectedSellerSubCateId;

    String password = _passwordController.text;

    SellerModel bank =
        Provider.of<BankInfoProvider>(context, listen: false).bankInfo!;

    // Prepare SellerBody including the time slots
    List<String> availability = [];
    dateTimeSlots.forEach((date, slots) {
      for (var slot in slots) {
        availability.add(jsonEncode({
          "date": date,
          "from": slot.from.format(context),
          "to": slot.to.format(context),
        }));
      }
    });
    print("fsrweww ${availability}");
    SellerBody sellerBody = SellerBody(
      sMethod: '_put',
      fName: firstName,
      lName: lastName,
      description: description,
      image: updateUserInfoModel.image,
      bankName: bank.bankName,
      branch: bank.branch,
      holderName: bank.holderName,
      accountNo: bank.accountNo,
      type: type,
      categoryId: Provider.of<SellerProvider>(context, listen: false)
          .selectedSellerCateId,
      subCategoryId: Provider.of<SellerProvider>(context, listen: false)
          .selectedSellerSubCateId,
    );

    // Call the API
    await Provider.of<ProfileProvider>(context, listen: false)
        .updateUserInfo(
            updateUserInfoModel,
            sellerBody,
            file,
            Provider.of<AuthProvider>(context, listen: false).getUserToken(),
            password,
            imageFiles,
            pdfFiles,
            availability)
        .then((response) {
      if (response.isSuccess) {
        Provider.of<ProfileProvider>(context, listen: false).getSellerInfo();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(getTranslated('updated_successfully', context)!),
            backgroundColor: Colors.green));
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.message!), backgroundColor: Colors.red));
      }
    });
  }

  @override
  void initState() {
    ///for auto select category
    inIt();
  }

  inIt() async {
    var provider = Provider.of<SellerProvider>(context, listen: false);
    var profile = Provider.of<ProfileProvider>(context, listen: false);
    await provider.getSellerCategory(context, 'en');
    if (provider.sellerCategoryList?.isNotEmpty ?? false) {
      provider.sellerCategoryList!.forEach(
        (element) {
          int index = provider.sellerCategoryList!.indexOf(element);

          if (element.id == profile.userInfoModel?.sellerCategoryId) {
            provider.getSellerSubCategoryList(index,
                forUpdate: true,
                id: profile.userInfoModel?.sellerSubCategoryId);
          }
        },
      );
    }
  }

  Future<void> pickTimeRange() async {
    TimeOfDay? from = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (from == null) return;

    TimeOfDay? to = await showTimePicker(
      context: context,
      initialTime: from,
    );

    if (to == null) return;

    final fromMin = from.hour * 60 + from.minute;
    final toMin = to.hour * 60 + to.minute;

    if (toMin <= fromMin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("To time must be after From time")),
      );
      return;
    }

    setState(() {
      final key = getDateKey(selectedDate);
      dateTimeSlots.putIfAbsent(key, () => []);
      dateTimeSlots[key]!.add(TimeRange(from: from, to: to));
    });
  }

  Map<String, List<TimeRange>> dateTimeSlots = {};
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  String dateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String getDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String selectedDateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final weekDates = getCurrentWeekDates();

    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: getTranslated('edit_profile', context),
      ),
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          if (_firstNameController.text.isEmpty ||
              _lastNameController.text.isEmpty) {
            _firstNameController.text = profile.userInfoModel!.fName!;
            _lastNameController.text = profile.userInfoModel!.lName!;
            _phoneController.text = profile.userInfoModel!.phone!;
            _discriptionController.text =
                profile.userInfoModel!.description ?? "";
            typeController.text = profile.userInfoModel!.type == null ||
                    profile.userInfoModel!.type == ''
                ? 'goods'
                : profile.userInfoModel!.type ?? '';
            shopAddressController.text = profile.userInfoModel!.address ?? '';
            cityController.text = profile.userInfoModel!.city ?? '';
            areaController.text = profile.userInfoModel!.area ?? '';
            zipCodeController.text = profile.userInfoModel!.zipCode ?? '';
            stateController.text = profile.userInfoModel!.state ?? '';
          }
          print(typeController.text);
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.only(top: Dimensions.paddingSizeSmalls),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    border: Border.all(color: Colors.white, width: 3),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: file == null
                            ? CustomImage(
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                image:
                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.sellerImageUrl}/${profile.userInfoModel!.image ?? ''}')
                            : Image.file(file!,
                                width: 100, height: 100, fit: BoxFit.fill),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _showSelectionDialog,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeExtraLarge),
                                border: Border.all(
                                    color: Theme.of(context).cardColor)),
                            child: IconButton(
                              onPressed: _showSelectionDialog,
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: Dimensions.iconSizeDefault,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: Dimensions.paddingSizeDefault,
                      left: Dimensions.paddingSizeDefault,
                      right: Dimensions.paddingSizeDefault),
                  child: Column(
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      CustomTextField(
                        border: true,
                        textInputType: TextInputType.name,
                        focusNode: _fNameFocus,
                        nextNode: _lNameFocus,
                        hintText: profile.userInfoModel!.fName ?? '',
                        controller: _firstNameController,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      CustomTextField(
                        border: true,
                        textInputType: TextInputType.name,
                        focusNode: _lNameFocus,
                        nextNode: _phoneFocus,
                        hintText: profile.userInfoModel!.lName,
                        controller: _lastNameController,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      CustomTextField(
                        idDate: true,
                        hintText: profile.userInfoModel!.email ?? "",
                        border: true,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      CustomTextField(
                        border: true,
                        idDate: true,
                        // textInputType: TextInputType.phone,
                        //focusNode: _phoneFocus,
                        //   nextNode: _passwordFocus,
                        hintText: profile.userInfoModel!.phone ?? "",
                        // controller: _phoneController,
                        isPhoneNumber: true,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      CustomTextField(
                        border: true,
                        textInputType: TextInputType.text,
                        // focusNode: _lNameFocus,
                        // nextNode: _phoneFocus,
                        hintText:
                            profile.userInfoModel!.description ?? 'Description',
                        controller: _discriptionController,
                      ),

                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      CustomTextField(
                        border: true,
                        hintText: getTranslated('password', context),
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        isPassword: true,
                        nextNode: _confirmPasswordFocus,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      CustomTextField(
                        border: true,
                        hintText: getTranslated('confirm_password', context),
                        isPassword: true,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        textInputAction: TextInputAction.done,
                      ),
                      // const SizedBox(height: Dimensions.paddingSizeDefault),
                      /*profile.userInfoModel!.type == 'both'
                          ? Container()
                          : Container(
                              width: double.infinity,
                              height: 6.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.3))),

                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  hint: const Row(
                                    children: [
                                      Icon(Icons.countertops),

                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Type',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: typeController.text == "goods"
                                      ? ["both", "goods"]
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList()
                                      : ["both", "service"]
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                  value: typeController.text,
                                  onChanged: (value) {
                                    setState(() {
                                      typeController.text = value.toString();
                                    });
                                  },

                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Colors.blue,
                                    ),
                                    iconSize: 14,
                                  ),

                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: 160,
                                    padding: const EdgeInsets.only(left: 14, right: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // color: AppColor().colorEdit(),
                                    ),
                                    elevation: 0,
                                  ),

                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding: EdgeInsets.only(left: 14, right: 14),
                                  ),

                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 8,
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness: MaterialStatePropertyAll(6),
                                      thumbVisibility: MaterialStatePropertyAll(true),
                                    ),
                                  ),

                                  // icon: const Icon(
                                  //   Icons.arrow_forward_ios_outlined,
                                  //   color: Colors.blue,
                                  // ),
                                  // iconSize: 14,
                                  // buttonHeight: 50,
                                  // buttonWidth: 160,
                                  // buttonPadding: const EdgeInsets.only(
                                  //     left: 14, right: 14),
                                  // buttonDecoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(5),
                                  //   // color: AppColor().colorEdit(),
                                  // ),
                                  // buttonElevation: 0,
                                  // itemHeight: 40,
                                  // itemPadding: const EdgeInsets.only(
                                  //     left: 14, right: 14),
                                  // dropdownMaxHeight: 300,
                                  // dropdownPadding: null,
                                  // dropdownDecoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(14),
                                  // ),
                                  // dropdownElevation: 8,
                                  // scrollbarRadius: const Radius.circular(40),
                                  // scrollbarThickness: 6,
                                  // scrollbarAlwaysShow: true,
                                ),
                              ),
                            ),*/

                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                        margin: const EdgeInsets.only(
                            // left: Dimensions.paddingSizeLarge,
                            // right: Dimensions.paddingSizeLarge,
                            bottom: Dimensions.paddingSizeSmall,
                            top: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3))),
                        child: TextFormField(
                          readOnly: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapLocationPicker(
                                        config: MapLocationPickerConfig(
                                            apiKey: Platform.isAndroid
                                                ? "AIzaSyDp5WRm4NU2C0C6NeNkBY1uOUnpGl6ChKY"
                                                : "AIzaSyDp5WRm4NU2C0C6NeNkBY1uOUnpGl6ChKY",
                                            initialPosition:
                                                LatLng(22.719568, 75.857727),
                                            onNext: (result) {
                                              if (result != null) {
                                                print(
                                                    'Full Address: ${result.formattedAddress}');

                                                // Extract components from address
                                                for (var component in result
                                                    .addressComponents!) {
                                                  if (component.types.contains(
                                                      'administrative_area_level_1')) {
                                                    stateController.text =
                                                        component
                                                            .longName; // State
                                                  } else if (component.types
                                                      .contains('locality')) {
                                                    cityController.text =
                                                        component
                                                            .longName; // City
                                                  } else if (component.types
                                                          .contains(
                                                              'sublocality_level_1') ||
                                                      component.types.contains(
                                                          'neighborhood')) {
                                                    areaController.text =
                                                        component
                                                            .longName; // Area
                                                  } else if (component.types
                                                      .contains(
                                                          'postal_code')) {
                                                    zipCodeController.text =
                                                        component
                                                            .longName; // Pincode
                                                  }
                                                }

                                                setState(() {
                                                  shopAddressController.text =
                                                      result.formattedAddress
                                                          .toString();
                                                });
                                                Navigator.of(context).pop();
                                              }
                                            }),
                                      )),
                            );

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PlacePicker(
                            //       selectInitialPosition: true,
                            //       enableMyLocationButton: true,
                            //       apiKey: Platform.isAndroid
                            //           ? "AIzaSyDp5WRm4NU2C0C6NeNkBY1uOUnpGl6ChKY"
                            //           : "AIzaSyDp5WRm4NU2C0C6NeNkBY1uOUnpGl6ChKY",
                            //       onPlacePicked: (result) {
                            //         print(
                            //             'Full Address: ${result.formattedAddress}');
                            //
                            //         // Extract components from address
                            //         for (var component
                            //             in result.addressComponents!) {
                            //           if (component.types.contains(
                            //               'administrative_area_level_1')) {
                            //             stateController.text =
                            //                 component.longName; // State
                            //           } else if (component.types
                            //               .contains('locality')) {
                            //             cityController.text =
                            //                 component.longName; // City
                            //           } else if (component.types.contains(
                            //                   'sublocality_level_1') ||
                            //               component.types
                            //                   .contains('neighborhood')) {
                            //             areaController.text =
                            //                 component.longName; // Area
                            //           } else if (component.types
                            //               .contains('postal_code')) {
                            //             zipCodeController.text =
                            //                 component.longName; // Pincode
                            //           }
                            //         }
                            //
                            //         setState(() {
                            //           shopAddressController.text =
                            //               result.formattedAddress.toString();
                            //         });
                            //         Navigator.of(context).pop();
                            //       },
                            //       initialPosition:
                            //           const LatLng(22.719568, 75.857727),
                            //       useCurrentLocation: true,
                            //     ),
                            //
                            //     // const MapScreen(
                            //     //   mapKey: 'AIzaSyDp5WRm4NU2C0C6NeNkBY1uOUnpGl6ChKY',
                            //     // ),
                            //   ),
                            // );

                            // .then((value) {
                            //   if (value != null) {
                            //     setState(() {
                            //       droopUplocation = value[2];
                            //       authProvider.latController.text =
                            //           value[0].toString();
                            //       authProvider.longController.text =
                            //           value[1].toString();
                            //       authProvider.shopAddressController.text =
                            //           droopUplocation.toString();
                            //     });
                            //   }
                            //   // Navigator.pop(context);
                            // }
                            // );
                          },
                          controller: shopAddressController,
                          decoration: InputDecoration(
                            hintText: 'Artist Address',
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            )),
                            filled: false,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10),
                            alignLabelWithHint: true,
                            counterText: '',
                            hintStyle: titilliumRegular.copyWith(
                                color: Theme.of(context).hintColor),
                            errorStyle: const TextStyle(height: 1.5),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Consumer<SellerProvider>(
                        builder: (context, provider, child) {
                          return Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text('Artist Category',
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault)),
                                  ),
                                  AppDropdown<String>(
                                    margin: EdgeInsets.all(5),
                                    items: provider.sellerCategoryList
                                            ?.map(
                                              (e) => e.name!,
                                            )
                                            .toList() ??
                                        [],
                                    value: provider.selectedSellerCate,
                                    hintText: 'Artist Category',
                                    onChanged: (value) {
                                      int index = provider.sellerCategoryList!
                                          .indexWhere(
                                        (element) => element.name == value,
                                      );
                                      if (index != -1) {
                                        provider
                                            .getSellerSubCategoryList(index);
                                      }
                                    },
                                  )
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text('Artist Sub Category',
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault)),
                                  ),
                                  AppDropdown<String>(
                                    margin: EdgeInsets.all(5),
                                    items: provider.sellerSubCategoryList
                                            ?.map(
                                              (e) => e.name!,
                                            )
                                            .toList() ??
                                        [],
                                    value: provider.selectedSellerSubCate,
                                    hintText: 'Subcategory Category',
                                    onChanged: (value) {
                                      int index = provider
                                          .sellerSubCategoryList!
                                          .indexWhere(
                                        (element) => element.name == value,
                                      );
                                      if (index != -1) {
                                        provider.selectSellerSubCategory(index);
                                      }
                                    },
                                  ),
                                ],
                              )),
                            ],
                          );
                        },
                      ),
                      // const SizedBox(height: Dimensions.paddingSizeSmall),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Available",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 70,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: weekDates.length,
                                itemBuilder: (context, index) {
                                  final date = weekDates[index];
                                  final isSelected =
                                      DateFormat('yyyy-MM-dd').format(date) ==
                                          DateFormat('yyyy-MM-dd')
                                              .format(selectedDate);

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedDate = date;
                                        selectedDateKey =
                                            DateFormat('yyyy-MM-dd')
                                                .format(date);
                                      });
                                    },
                                    child: Container(
                                      width: 50,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? ColorResources.primary
                                            : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateFormat('EEE').format(date),
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            date.day.toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: pickTime,
                              child: const Text("Pick From & To Time"),
                            ),
                            if (dateTimeSlots[selectedDateKey] != null &&
                                dateTimeSlots[selectedDateKey]!.isNotEmpty)
                              Column(
                                children:
                                    dateTimeSlots[selectedDateKey]!.map((slot) {
                                  return Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    // padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Color(0xff8181A6FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "   ${slot.from.format(context)} - ${slot.to.format(context)}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              dateTimeSlots[selectedDateKey]!
                                                  .remove(slot);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Row(
                        children: [
                          InkWell(
                            onTap: pickMultipleImages,
                            child: uploadButton(
                              icon: Icons.image,
                              text: "Upload Work",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      if (imageFiles.isNotEmpty)
                        Wrap(
                          spacing: 18,
                          runSpacing: 10,
                          children: List.generate(imageFiles.length, (index) {
                            return Stack(
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      imageFiles[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        imageFiles.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Row(
                        children: [
                          InkWell(
                            onTap: pickPdf,
                            child: uploadButton(
                              icon: Icons.picture_as_pdf,
                              text: "Upload Certificate",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      if (pdfFiles.isNotEmpty)
                        Column(
                          children: pdfFiles.map((file) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.red,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      file.path.split('/').last,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        pdfFiles.remove(file);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.05),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                      // downloadInvoice(profile),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar:
          Consumer<ProfileProvider>(builder: (context, profile, child) {
        return Container(
          height: 70,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(.125),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset.fromDirection(1, 2))
            ],
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
          width: MediaQuery.of(context).size.width,
          child: !profile.isLoading
              ? CustomButton(
                  borderRadius: 10,
                  backgroundColor: Theme.of(context).primaryColor,
                  onTap: _updateUserAccount,
                  btnTxt: getTranslated('update_profile', context))
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor))),
        );
      }),
    );
  }

  Widget uploadButton({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 8),
          Text(text, style: robotoRegular),
        ],
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    print("Vendor $url");
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw 'Could not launch $url';
  }
}

// downloadInvoice(ProfileProvider profile) {
//   return Card(
//     elevation: 0,
//     child: InkWell(
//         child: ListTile(
//           dense: true,
//           trailing: Icon(
//             Icons.keyboard_arrow_right,
//             color: Theme.of(context).primaryColor,
//           ),
//           leading: Icon(
//             Icons.receipt,
//             color: Theme.of(context).primaryColor,
//           ),
//           title: Text(
//             "Download Certificate",
//             style: Theme.of(context)
//                 .textTheme
//                 .titleSmall!
//                 .copyWith(color: Theme.of(context).colorScheme.surfaceTint),
//           ),
//         ),
//         onTap: () async {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     HtmlToPdfConverter(profile.userInfoModel!.certificate!),
//               ));
//           // _launchUrl(Uri.parse(profile.userInfoModel!.certificate!));
//
//           // try {
//           //   DateTime date = DateFormat('yyyy-MM-dd')
//           //       .parse(profile.userInfoModel!.plan_expire_date!);
//           //   if (date.isBefore(DateTime.now())) {
//           //     showCustomSnackBar("Please purchase plan", Get.context!);
//           //   } else {
//           //     _launchUrl(Uri.parse(profile.userInfoModel!.certificate!));
//           //   }
//           // } catch (e) {
//           //   showCustomSnackBar("Please purchase plan", Get.context!);
//           //   print(e);
//           // }
//
// //             final plugin = DeviceInfoPlugin();
// //             final android = await plugin.androidInfo;
// //             print("++++++++++++");
// //             var status = android.version.sdkInt! < 33
// //                 ? await Permission.storage.request()
// //                 : PermissionStatus.granted;
// //
// //             // status = await Permission.storage.request();
// //             //await Permission.storage.request();
// //             print("++++++++++++${status}");
// //             if (status == PermissionStatus.granted) {
// //               if (mounted) {
// //                 setState(() {
// //                   _isProgress = true;
// //                 });
// //               }
// //               var targetPath;
// //
// //               if (Platform.isIOS) {
// //                 var target = await getApplicationDocumentsDirectory();
// //                 targetPath = target.path.toString();
// //               } else {
// //                 var downloadsDirectory =
// //                     await getApplicationDocumentsDirectory();
// //                 // = await DownloadsPathProvider.downloadsDirectory;
// //                 targetPath = downloadsDirectory!.path.toString();
// //               }
// //
// //               var targetFileName = "Invoice_${"widget.model!.id"}";
// //               var generatedPdfFile, filePath;
// //
// //               try {
// //                 generatedPdfFile =
// //                     await FlutterHtmlToPdf.convertFromHtmlContent("""
// // <!DOCTYPE html>
// // <html>
// // <head>
// //   <style>
// //   table, th, td {
// //     border: 1px solid black;
// //     border-collapse: collapse;
// //   }
// //   th, td, p {
// //     padding: 5px;
// //     text-align: left;
// //   }
// //   </style>
// // </head>
// //   <body>
// //     <h2>PDF Generated with flutter_html_to_pdf plugin</h2>
// //     <table style="width:100%">
// //       <caption>Sample HTML Table</caption>
// //       <tr>
// //         <th>Month</th>
// //         <th>Savings</th>
// //       </tr>
// //       <tr>
// //         <td>January</td>
// //         <td>100</td>
// //       </tr>
// //       <tr>
// //         <td>February</td>
// //         <td>50</td>
// //       </tr>
// //     </table>
// //     <p>Image loaded from web</p>
// //     <img src="https://i.imgur.com/wxaJsXF.png" alt="web-img">
// //   </body>
// // </html>
// // """, targetPath, targetFileName);
// //                 filePath = generatedPdfFile.path;
// //               } on Exception {
// //                 //  filePath = targetPath + "/" + targetFileName + ".html";
// //                 generatedPdfFile =
// //                     await FlutterHtmlToPdf.convertFromHtmlContent("""
// // <!DOCTYPE html>
// // <html>
// // <head>
// //   <style>
// //   table, th, td {
// //     border: 1px solid black;
// //     border-collapse: collapse;
// //   }
// //   th, td, p {
// //     padding: 5px;
// //     text-align: left;
// //   }
// //   </style>
// // </head>
// //   <body>
// //     <h2>PDF Generated with flutter_html_to_pdf plugin</h2>
// //     <table style="width:100%">
// //       <caption>Sample HTML Table</caption>
// //       <tr>
// //         <th>Month</th>
// //         <th>Savings</th>
// //       </tr>
// //       <tr>
// //         <td>January</td>
// //         <td>100</td>
// //       </tr>
// //       <tr>
// //         <td>February</td>
// //         <td>50</td>
// //       </tr>
// //     </table>
// //     <p>Image loaded from web</p>
// //     <img src="https://i.imgur.com/wxaJsXF.png" alt="web-img">
// //   </body>
// // </html>
// // """, targetPath, targetFileName);
// //                 filePath = generatedPdfFile.path;
// //               }
// //
// //               if (mounted) {
// //                 setState(() {
// //                   _isProgress = false;
// //                 });
// //               }
// //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //                 content: Text(
// //                   "Invoice Path $targetFileName",
// //                   textAlign: TextAlign.center,
// //                   style:
// //                       TextStyle(color: Theme.of(context).colorScheme.onError),
// //                 ),
// //                 action: SnackBarAction(
// //                     label: "View",
// //                     textColor: Theme.of(context).colorScheme.primary,
// //                     onPressed: () async {
// //                       final result = await OpenFilex.open(filePath);
// //                       print("object${result.message}");
// //                     }),
// //                 backgroundColor:
// //                     Theme.of(context).colorScheme.onSecondaryContainer,
// //                 elevation: 1.0,
// //               ));
// //             }
//         }),
//   );
// }
class TimeRange {
  final TimeOfDay from;
  final TimeOfDay to;

  TimeRange({required this.from, required this.to});
}
