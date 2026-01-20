import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_location_picker/map_location_picker.dart';

// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_pass_textfeild.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/colors.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/widget.dart';
import 'package:sixvalley_vendor_app/view/screens/more/html_view_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../../provider/shop_provider.dart';
import '../../../../widgets/app_dropdown.dart';

String? droopUplocation, droopLat, droopLong;

class InfoFieldVIew extends StatefulWidget {
  final bool isShopInfo;

  const InfoFieldVIew({Key? key, this.isShopInfo = false}) : super(key: key);

  @override
  State<InfoFieldVIew> createState() => _InfoFieldVIewState();
}

class _InfoFieldVIewState extends State<InfoFieldVIew> {
  String? _countryDialCode = "+880";
  String currency = '', country = '', selectedTimeZone = '';
  String? lat;
  String? long;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation();
    _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .countryCode!)
        .dialCode;

    Provider.of<SellerProvider>(context, listen: false)
        .getSellerCategory(context, 'en');
  }

  String? droopUplocation, droopLat, droopLong;

  TextEditingController shopAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (authContext, authProvider, _) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.isShopInfo)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeSmall),
                    child: Align(
                        alignment: Alignment.center,
                        child: DottedBorder(
                          color: Theme.of(context).hintColor,
                          dashPattern: const [10, 5],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(
                              Dimensions.paddingSizeSmall),
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.paddingSizeSmall),
                              child: authProvider.sellerProfileImage != null
                                  ? Image.file(
                                      File(authProvider
                                          .sellerProfileImage!.path),
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                  : SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: Image.asset(
                                          Images.cameraPlaceholder,
                                          scale: 3),
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              top: 0,
                              left: 0,
                              child: InkWell(
                                onTap: () => authProvider.pickImage(
                                    true, false, false, false, false),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(.08),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.paddingSizeSmall),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: Dimensions.paddingSizeSmalls,
                        bottom: Dimensions.paddingSizeExtraLarge),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(getTranslated('profile_image', context)!,
                            style: robotoRegular),
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.paddingSizeLarge,
                          right: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeSmall),
                      child: CustomTextField(
                        border: true,
                        hintText: getTranslated('first_name', context),
                        focusNode: authProvider.firstNameNode,
                        nextNode: authProvider.lastNameNode,
                        textInputType: TextInputType.name,
                        controller: authProvider.firstNameController,
                        textInputAction: TextInputAction.next,
                      )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.paddingSizeLarge,
                          right: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeSmall),
                      child: CustomTextField(
                        border: true,
                        hintText: getTranslated('last_name', context),
                        focusNode: authProvider.lastNameNode,
                        nextNode: authProvider.emailNode,
                        textInputType: TextInputType.name,
                        controller: authProvider.lastNameController,
                        textInputAction: TextInputAction.next,
                      )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.paddingSizeLarge,
                          right: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeSmall),
                      child: CustomTextField(
                        border: true,
                        hintText: getTranslated('email_address', context),
                        focusNode: authProvider.emailNode,
                        nextNode: authProvider.phoneNode,
                        textInputType: TextInputType.emailAddress,
                        controller: authProvider.emailController,
                        textInputAction: TextInputAction.next,
                      )),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Container(
                    margin: const EdgeInsets.only(
                        left: Dimensions.paddingSizeLarge,
                        right: Dimensions.paddingSizeLarge,
                        bottom: Dimensions.paddingSizeSmall),
                    child: CustomTextField(
                      hintText: "Mobile Number",
                      controller: authProvider.phoneController,
                      focusNode: authProvider.phoneNode,
                      nextNode: authProvider.passwordNode,
                      isPhoneNumber: true,
                      border: true,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeMedium),
                  Container(
                    margin: const EdgeInsets.only(
                        left: Dimensions.paddingSizeLarge,
                        right: Dimensions.paddingSizeLarge,
                        bottom: Dimensions.paddingSizeSmall),
                    child: CustomTextField(
                      border: true,
                      hintText: 'Description',
                      // focusNode: authProvider.emailNode,
                      // nextNode: authProvider.phoneNode,
                      textInputType: TextInputType.text,
                      controller: authProvider.descriptionController,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeMedium),
                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.paddingSizeLarge,
                          right: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeDefault),
                      child: CustomPasswordTextField(
                        border: true,
                        hintTxt: getTranslated('password', context),
                        textInputAction: TextInputAction.next,
                        focusNode: authProvider.passwordNode,
                        nextNode: authProvider.confirmPasswordNode,
                        controller: authProvider.passwordController,
                      )),
                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.paddingSizeLarge,
                          right: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeDefault),
                      child: CustomPasswordTextField(
                        border: true,
                        hintTxt: getTranslated('confirm_password', context),
                        textInputAction: TextInputAction.done,
                        focusNode: authProvider.confirmPasswordNode,
                        controller: authProvider.confirmPasswordController,
                      )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                ],
              ),
            if (widget.isShopInfo)
              Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.paddingSizeLarge,
                          right: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeSmall,
                          top: Dimensions.paddingSizeSmall),
                      child: CustomTextField(
                        border: true,
                        hintText: getTranslated('shop_name', context),
                        focusNode: authProvider.shopNameNode,
                        nextNode: authProvider.gstNode,
                        textInputType: TextInputType.name,
                        controller: authProvider.shopNameController,
                        textInputAction: TextInputAction.next,
                      )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.paddingSizeLarge,
                          right: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeSmall,
                          top: Dimensions.paddingSizeSmall),
                      child: CustomTextField(
                        border: true,
                        maxSize: 16,
                        hintText: "Gst Number(Optional)",
                        focusNode: authProvider.gstNode,
                        nextNode: authProvider.adharNode,
                        textInputType: TextInputType.name,
                        controller: authProvider.gstController,
                        textInputAction: TextInputAction.next,
                      )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.paddingSizeLarge,
                          right: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeSmall,
                          top: Dimensions.paddingSizeSmall),
                      child: CustomTextField(
                        border: true,
                        maxSize: 12,
                        hintText: "Aadhaar Number",
                        focusNode: authProvider.adharNode,
                        nextNode: authProvider.shopAddressNode,
                        textInputType: TextInputType.number,
                        controller: authProvider.adharController,
                        textInputAction: TextInputAction.next,
                      )),

                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  ///Address
                  Container(
                    margin: const EdgeInsets.only(
                        left: Dimensions.paddingSizeLarge,
                        right: Dimensions.paddingSizeLarge,
                        bottom: Dimensions.paddingSizeSmall,
                        top: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.3))),
                    child: TextFormField(
                      readOnly: true,
                      onTap: () {
                        print("latssdsads $lat   and Long  $long  ");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapLocationPicker(
                                    config: MapLocationPickerConfig(
                                      apiKey: AppConstants.mapKey,
                                      initialPosition: LatLng(
                                        double.tryParse(lat.toString()) ??
                                            22.719568,
                                        double.tryParse(long.toString()) ??
                                            75.857727,
                                      ),
                                      onNext: (result) {
                                        if (result != null) {
                                          print(
                                              'Full Address: ${result.formattedAddress}');

                                          // Extract components from address
                                          for (var component
                                              in result.addressComponents) {
                                            if (component.types.contains(
                                                'administrative_area_level_1')) {
                                              authProvider.stateController
                                                  .text = component.longName;
                                            } else if (component.types
                                                .contains('locality')) {
                                              authProvider.cityController.text =
                                                  component.longName; // City
                                            } else if (component.types.contains(
                                                    'sublocality_level_1') ||
                                                component.types
                                                    .contains('neighborhood')) {
                                              authProvider.areaController.text =
                                                  component.longName; // Area
                                            } else if (component.types
                                                .contains('postal_code')) {
                                              authProvider
                                                      .zipCodeController.text =
                                                  component.longName; // Pincode
                                            }
                                          }

                                          setState(() {
                                            authProvider.shopAddressController
                                                    .text =
                                                result.formattedAddress
                                                    .toString();
                                            authProvider.latController.text =
                                                result.geometry!.location.lat
                                                    .toString();
                                            authProvider.longController.text =
                                                result.geometry!.location.lng
                                                    .toString();
                                          });
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    ),
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
                        //             authProvider.stateController.text =
                        //                 component.longName; // State
                        //           } else if (component.types
                        //               .contains('locality')) {
                        //             authProvider.cityController.text =
                        //                 component.longName; // City
                        //           } else if (component.types
                        //                   .contains('sublocality_level_1') ||
                        //               component.types
                        //                   .contains('neighborhood')) {
                        //             authProvider.areaController.text =
                        //                 component.longName; // Area
                        //           } else if (component.types
                        //               .contains('postal_code')) {
                        //             authProvider.zipCodeController.text =
                        //                 component.longName; // Pincode
                        //           }
                        //         }
                        //
                        //         setState(() {
                        //           authProvider.shopAddressController.text =
                        //               result.formattedAddress.toString();
                        //           authProvider.latController.text =
                        //               result.geometry!.location.lat.toString();
                        //           authProvider.longController.text =
                        //               result.geometry!.location.lng.toString();
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
                      controller: authProvider.shopAddressController,
                      decoration: InputDecoration(
                        hintText: 'Shop Address',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        )),
                        filled: false,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 10),
                        alignLabelWithHint: true,
                        counterText: '',
                        hintStyle: titilliumRegular.copyWith(
                            color: Theme.of(context).hintColor),
                        errorStyle: const TextStyle(height: 1.5),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.paddingSizeLarge,
                          right: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeSmall,
                          top: Dimensions.paddingSizeSmall),
                      child: CustomTextField(
                        border: true,
                        maxSize: 12,
                        hintText: "Area",
                        focusNode: authProvider.areaNode,
                        nextNode: authProvider.shopAddressNode,
                        textInputType: TextInputType.text,
                        controller: authProvider.areaController,
                        textInputAction: TextInputAction.next,
                      )),

                  // Container(
                  //     margin: const EdgeInsets.only(
                  //         left: Dimensions.paddingSizeLarge,
                  //         right: Dimensions.paddingSizeLarge,
                  //         bottom: Dimensions.paddingSizeSmall),
                  //     child: CustomTextField(
                  //       onChanged: (value) {
                  //         print("fsdfsdfsff");
                  //
                  //       },
                  //       border: true,
                  //       maxLine: 3,
                  //       hintText: getTranslated('shop_address', context),
                  //       focusNode: authProvider.shopAddressNode,
                  //       textInputType: TextInputType.name,
                  //       controller: authProvider.shopAddressController,
                  //       textInputAction: TextInputAction.done,
                  //     )),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(
                                left: Dimensions.paddingSizeLarge,
                                right: Dimensions.paddingSizeLarge,
                                bottom: Dimensions.paddingSizeSmall,
                                top: Dimensions.paddingSizeSmall),
                            child: CustomTextField(
                              border: true,
                              maxSize: 12,
                              hintText: "City",
                              focusNode: authProvider.cityNode,
                              nextNode: authProvider.stateNode,
                              textInputType: TextInputType.text,
                              controller: authProvider.cityController,
                              textInputAction: TextInputAction.next,
                            )),
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(
                                left: Dimensions.paddingSizeLarge,
                                right: Dimensions.paddingSizeLarge,
                                bottom: Dimensions.paddingSizeSmall,
                                top: Dimensions.paddingSizeSmall),
                            child: CustomTextField(
                              border: true,
                              maxSize: 12,
                              hintText: "State",
                              focusNode: authProvider.stateNode,
                              nextNode: authProvider.shopAddressNode,
                              textInputType: TextInputType.text,
                              controller: authProvider.stateController,
                              textInputAction: TextInputAction.next,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  ///Category section
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
                                child: Text('Seller Category',
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault)),
                              ),
                              AppDropdown<String>(
                                margin: EdgeInsets.all(10),
                                items: provider.sellerCategoryList
                                        ?.map(
                                          (e) => e.name!,
                                        )
                                        .toList() ??
                                    [],
                                value: provider.selectedSellerCate,
                                hintText: 'Seller Category',
                                onChanged: (value) {
                                  int index =
                                      provider.sellerCategoryList!.indexWhere(
                                    (element) => element.name == value,
                                  );
                                  if (index != -1) {
                                    provider.getSellerSubCategoryList(index);
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
                                child: Text('Seller Sub Category',
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault)),
                              ),
                              AppDropdown<String>(
                                margin: EdgeInsets.all(10),
                                items: provider.sellerSubCategoryList
                                        ?.map(
                                          (e) => e.name!,
                                        )
                                        .toList() ??
                                    [],
                                value: provider.selectedSellerSubCate,
                                hintText: 'Subcategory Category',
                                onChanged: (value) {
                                  int index = provider.sellerSubCategoryList!
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

                  /*Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Text("Type"))*/
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    height: 2.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeLarge,
                        right: Dimensions.paddingSizeLarge,
                        bottom: Dimensions.paddingSizeDefault),
                    child: Row(
                      children: [
                        Text(
                            '${getTranslated('business_or_shop_logo', context)}',
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault)),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Align(
                      alignment: Alignment.center,
                      child: DottedBorder(
                        dashPattern: const [10, 5],
                        color: Theme.of(context).hintColor,
                        borderType: BorderType.RRect,
                        radius:
                            const Radius.circular(Dimensions.paddingSizeSmall),
                        child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeSmall),
                            child: authProvider.shopLogo != null
                                ? Image.file(
                                    File(authProvider.shopLogo!.path),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Image.asset(Images.cameraPlaceholder,
                                        scale: 3)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            top: 0,
                            left: 0,
                            child: InkWell(
                              onTap: () => authProvider.pickImage(
                                  false, true, false, false, false),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(.08),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeSmall),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: Dimensions.paddingSizeSmall,
                        bottom: Dimensions.paddingSizeDefault),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(getTranslated('image_size', context)!,
                            style: robotoRegular),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text(
                          '(1:1)',
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: Dimensions.paddingSizeLarge,
                  //       right: Dimensions.paddingSizeLarge,
                  //       bottom: Dimensions.paddingSizeDefault),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //           '${getTranslated('business_or_shop_banner', context)}',
                  //           style: robotoRegular.copyWith(
                  //               fontSize: Dimensions.fontSizeDefault)),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  // Align(
                  //     alignment: Alignment.center,
                  //     child: DottedBorder(
                  //       dashPattern: const [10, 5],
                  //       color: Theme.of(context).hintColor,
                  //       borderType: BorderType.RRect,
                  //       radius:
                  //           const Radius.circular(Dimensions.paddingSizeSmall),
                  //       child: Stack(children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(
                  //               Dimensions.paddingSizeSmall),
                  //           child: authProvider.shopBanner != null
                  //               ? Image.file(
                  //                   File(authProvider.shopBanner!.path),
                  //                   width:
                  //                       MediaQuery.of(context).size.width - 40,
                  //                   height: 120,
                  //                   fit: BoxFit.cover,
                  //                 )
                  //               : SizedBox(
                  //                   height: 120,
                  //                   width:
                  //                       MediaQuery.of(context).size.width - 40,
                  //                   child: Image.asset(
                  //                     Images.cameraPlaceholder,
                  //                     scale: 3,
                  //                   ),
                  //                 ),
                  //         ),
                  //         Positioned(
                  //           bottom: 0,
                  //           right: 0,
                  //           top: 0,
                  //           left: 0,
                  //           child: InkWell(
                  //             onTap: () => authProvider.pickImage(
                  //                 false, false, false, false, false),
                  //             child: Container(
                  //               decoration: BoxDecoration(
                  //                 color: Theme.of(context)
                  //                     .hintColor
                  //                     .withOpacity(0.08),
                  //                 borderRadius: BorderRadius.circular(
                  //                     Dimensions.paddingSizeSmall),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ]),
                  //     )),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       top: Dimensions.paddingSizeSmall,
                  //       bottom: Dimensions.paddingSizeDefault),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(getTranslated('image_size', context)!,
                  //           style: robotoRegular),
                  //       const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  //       Text(
                  //         '(3:1)',
                  //         style: robotoRegular.copyWith(
                  //             color: Theme.of(context).colorScheme.error),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: Dimensions.paddingSizeDefault),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: Dimensions.paddingSizeLarge,
                  //       right: Dimensions.paddingSizeLarge,
                  //       bottom: Dimensions.paddingSizeDefault),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //           '${getTranslated('store_secondary_banner', context)}',
                  //           style: robotoRegular.copyWith(
                  //               fontSize: Dimensions.fontSizeDefault)),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  // Align(
                  //     alignment: Alignment.center,
                  //     child: DottedBorder(
                  //       dashPattern: const [10, 5],
                  //       color: Theme.of(context).hintColor,
                  //       borderType: BorderType.RRect,
                  //       radius:
                  //           const Radius.circular(Dimensions.paddingSizeSmall),
                  //       child: Stack(children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(
                  //               Dimensions.paddingSizeSmall),
                  //           child: authProvider.secondaryBanner != null
                  //               ? Image.file(
                  //                   File(authProvider.secondaryBanner!.path),
                  //                   width:
                  //                       MediaQuery.of(context).size.width - 40,
                  //                   height: 120,
                  //                   fit: BoxFit.cover,
                  //                 )
                  //               : SizedBox(
                  //                   height: 120,
                  //                   width:
                  //                       MediaQuery.of(context).size.width - 40,
                  //                   child: Image.asset(
                  //                     Images.cameraPlaceholder,
                  //                     scale: 3,
                  //                   ),
                  //                 ),
                  //         ),
                  //         Positioned(
                  //           bottom: 0,
                  //           right: 0,
                  //           top: 0,
                  //           left: 0,
                  //           child: InkWell(
                  //             onTap: () => authProvider.pickImage(
                  //                 false, false, false, false, false,
                  //                 secondary: true),
                  //             child: Container(
                  //               decoration: BoxDecoration(
                  //                 color: Theme.of(context)
                  //                     .hintColor
                  //                     .withOpacity(0.08),
                  //                 borderRadius: BorderRadius.circular(
                  //                     Dimensions.paddingSizeSmall),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ]),
                  //     )),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       top: Dimensions.paddingSizeSmall,
                  //       bottom: Dimensions.paddingSizeDefault),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(getTranslated('image_size', context)!,
                  //           style: robotoRegular),
                  //       const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  //       Text(
                  //         '(3:1)',
                  //         style: robotoRegular.copyWith(
                  //             color: Theme.of(context).colorScheme.error),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // Aadhaar
                  // const SizedBox(height: Dimensions.paddingSizeDefault),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeLarge,
                        right: Dimensions.paddingSizeLarge,
                        bottom: Dimensions.paddingSizeDefault),
                    child: Row(
                      children: [
                        Text('Aadhar card front',
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault)),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Align(
                      alignment: Alignment.center,
                      child: DottedBorder(
                        dashPattern: const [10, 5],
                        color: Theme.of(context).hintColor,
                        borderType: BorderType.RRect,
                        radius:
                            const Radius.circular(Dimensions.paddingSizeSmall),
                        child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeSmall),
                            child: authProvider.aadharCard != null
                                ? Image.file(
                                    File(authProvider.aadharCard!.path),
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox(
                                    height: 120,
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    child: Image.asset(
                                      Images.cameraPlaceholder,
                                      scale: 3,
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            top: 0,
                            left: 0,
                            child: InkWell(
                              onTap: () => authProvider.pickImage(
                                  false, false, false, true, false),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeSmall),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: Dimensions.paddingSizeSmall,
                        bottom: Dimensions.paddingSizeDefault),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(getTranslated('image_size', context)!,
                            style: robotoRegular),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text(
                          '(3:1)',
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  // Aadhaar Back
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeLarge,
                        right: Dimensions.paddingSizeLarge,
                        bottom: Dimensions.paddingSizeDefault),
                    child: Row(
                      children: [
                        Text('Aadhaar card back',
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault)),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Align(
                      alignment: Alignment.center,
                      child: DottedBorder(
                        dashPattern: const [10, 5],
                        color: Theme.of(context).hintColor,
                        borderType: BorderType.RRect,
                        radius:
                            const Radius.circular(Dimensions.paddingSizeSmall),
                        child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeSmall),
                            child: authProvider.aadharBack != null
                                ? Image.file(
                                    File(authProvider.aadharBack!.path),
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox(
                                    height: 120,
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    child: Image.asset(
                                      Images.cameraPlaceholder,
                                      scale: 3,
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            top: 0,
                            left: 0,
                            child: InkWell(
                              onTap: () => authProvider.pickImage(
                                  false, false, false, false, false,
                                  isAadharBack: true),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeSmall),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: Dimensions.paddingSizeSmall,
                        bottom: Dimensions.paddingSizeDefault),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(getTranslated('image_size', context)!,
                            style: robotoRegular),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text(
                          '(3:1)',
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ),
                  ),

                  /*const SizedBox(height: Dimensions.paddingSizeDefault),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeLarge,
                        right: Dimensions.paddingSizeLarge,
                        bottom: Dimensions.paddingSizeDefault),
                    child: Row(
                      children: [
                        Text('Pan card',
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault)),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Align(
                      alignment: Alignment.center,
                      child: DottedBorder(
                        dashPattern: const [10, 5],
                        color: Theme.of(context).hintColor,
                        borderType: BorderType.RRect,
                        radius:
                            const Radius.circular(Dimensions.paddingSizeSmall),
                        child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeSmall),
                            child: authProvider.panCard != null
                                ? Image.file(
                                    File(authProvider.panCard!.path),
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox(
                                    height: 120,
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    child: Image.asset(
                                      Images.cameraPlaceholder,
                                      scale: 3,
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            top: 0,
                            left: 0,
                            child: InkWell(
                              onTap: () => authProvider.pickImage(
                                  false, false, false, false, true),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeSmall),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: Dimensions.paddingSizeSmall,
                        bottom: Dimensions.paddingSizeDefault),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(getTranslated('image_size', context)!,
                            style: robotoRegular),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text(
                          '(3:1)',
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ),
                  ),*/
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Container(
                    margin: const EdgeInsets.only(
                        right: Dimensions.paddingSizeSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Consumer<AuthProvider>(
                                builder: (context, authProvider, child) =>
                                    Checkbox(
                                        checkColor: ColorResources.white,
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: authProvider.isTermsAndCondition,
                                        onChanged: authProvider
                                            .updateTermsAndCondition)),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HtmlViewScreen(
                                              title: getTranslated(
                                                  'terms_and_condition',
                                                  context),
                                              url: Provider.of<SplashProvider>(
                                                      context,
                                                      listen: false)
                                                  .configModel!
                                                  .termsConditions)));
                                },
                                child: Row(children: [
                                  Text(getTranslated(
                                      'i_agree_to_your', context)!),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                      getTranslated(
                                          'terms_and_condition', context)!,
                                      style: robotoMedium),
                                ])),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ],
        ),
      );
    });
  }

  Future<void> getUserCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("checking permission here $permission");
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude.toString();
    long = position.longitude.toString();

    List<Placemark> placemark = await placemarkFromCoordinates(
      double.parse(lat.toString()), double.parse(long.toString()),
      // localeIdentifier: "en",
    );
    if (mounted) {
      setState(() {
        lat = position.latitude.toString();
        long = position.longitude.toString();
      });
    }
  }
}
