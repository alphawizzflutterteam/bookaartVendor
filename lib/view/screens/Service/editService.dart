import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/data/model/response/manage_service_model.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:html/parser.dart';

import 'package:sixvalley_vendor_app/view/screens/Service/ServiceCategoryModel.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/colors.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/manage_Service.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/utility_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/widget.dart';
import 'package:sixvalley_vendor_app/view/screens/Subcriptionplans/app_token_data.dart';
import 'package:sixvalley_vendor_app/view/screens/Subcriptionplans/utility_hlepar.dart';
import 'package:sizer/sizer.dart';

import 'package:http/http.dart' as http;

class EditServicePage extends StatefulWidget {
  final ManageServiceModel manageServiceModel;
  EditServicePage({Key? key, required this.manageServiceModel
      // this.profileResponse
      })
      : super(key: key);

  // final GetProfileResponse? profileResponse;

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  TextEditingController serviceName = new TextEditingController();
  TextEditingController serviceDescription = new TextEditingController();
  TextEditingController unitPrice = new TextEditingController();
  TextEditingController tax = TextEditingController();
  // TextEditingController videoLinkTextField = new TextEditingController();
  TextEditingController shippingCostTextField = new TextEditingController();
  TextEditingController selectedTexModel =
      new TextEditingController(text: "include");
  TextEditingController discountType = new TextEditingController(text: "flat");
  TextEditingController discountValue = new TextEditingController();
  TextEditingController categoryIdValue = new TextEditingController();
  TextEditingController thumbnailValue = new TextEditingController();
  var addedThumbImage = "";
  var addedServiceImage = "";

  GlobalKey<FormState> _formKey = GlobalKey();

  bool buttonLogin = false;
  String? selectedCategory;
  String? selectedCategoryID;
  List<XFile>? imagePathList = [];
  XFile? thumnailImage;
  bool isLoading = false;
  @override
  void initState() {
    final document = parse(widget.manageServiceModel.details);
    // TODO: implement initState
    serviceName.text = widget.manageServiceModel.name ?? '';
    serviceDescription.text =
        parse(document.body?.text).documentElement?.text ?? '';
    unitPrice.text = widget.manageServiceModel.unitPrice.toString();
    discountValue.text = widget.manageServiceModel.discount.toString() ?? '';
    tax.text = widget.manageServiceModel.tax.toString() ?? '';
    // videoLinkTextField.text = widget.manageServiceModel.videoUrl ?? '';
    shippingCostTextField.text =
        widget.manageServiceModel.shippingCost.toString() ?? '';
    thumbnailValue.text = widget.manageServiceModel.thumbnail.toString() ?? '';
    categoryIdValue.text = widget.manageServiceModel.categoryId ?? "";
    discountType.text = widget.manageServiceModel.discountType ?? '';
    selectedTexModel.text = widget.manageServiceModel.taxModel ?? '';
    addedThumbImage = "";
    addedServiceImage = "";
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Edit Service",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: Container(
            width: 6.38.w,
            height: 6.38.w,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 7.91.w),
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back)
                // Image.asset(
                //   back,
                //   height: 4.0.h,
                //   width: 8.w,
                // )

                )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            width: 100.w,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.5),
                colors: [
                  AppColor().colorBg1(),
                  AppColor().colorBg1(),
                ],
                radius: 0.8,
              ),
            ),
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  secondSign(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget secondSign(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 2.62.h,
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            color: AppColor().colorEdit(),
            child: Container(
                width: double.infinity,
                height: 6.h,
                decoration: boxDecoration(
                  radius: 14.0,
                  bgColor: AppColor().colorEdit(),
                ),
                child: TextFormField(
                  controller: serviceName,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(
                    hintText: "Service Name",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
                    prefixIcon: Icon(
                      Icons.miscellaneous_services,
                      color: AppColor.PrimaryDark,
                    ),
                  ),
                )),
          ),
          SizedBox(
            height: 1.h,
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            color: AppColor().colorEdit(),
            child: Container(
              width: double.infinity,
              height: 15.h,
              decoration: boxDecoration(
                radius: 14.0,
                bgColor: AppColor().colorEdit(),
              ),
              child: TextFormField(
                controller: serviceDescription,
                maxLines: 100,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  hintText: "Service Description",
                  border: InputBorder.none,
                  hintStyle: TextStyle(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
                  prefixIcon: Icon(
                    Icons.description,
                    color: AppColor.PrimaryDark,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            color: AppColor().colorEdit(),
            child: Container(
                width: double.infinity,
                height: 6.h,
                decoration: boxDecoration(
                  radius: 14.0,
                  bgColor: AppColor().colorEdit(),
                ),
                child: TextFormField(
                  controller: unitPrice,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(
                    hintText: "Unit Price",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
                    prefixIcon: Icon(
                      Icons.price_change,
                      color: AppColor.PrimaryDark,
                    ),
                  ),
                )),
          ),
          SizedBox(
            height: 1.h,
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            color: AppColor().colorEdit(),
            child: Container(
                width: double.infinity,
                height: 6.h,
                decoration: boxDecoration(
                  radius: 14.0,
                  bgColor: AppColor().colorEdit(),
                ),
                child: TextFormField(
                  controller: discountValue,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(
                    hintText: "Discount",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
                    prefixIcon: Icon(
                      Icons.price_change,
                      color: AppColor.PrimaryDark,
                    ),
                  ),
                )),
          ),
          SizedBox(
            height: 1.h,
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: const Text("Discount Type")),
          Container(
              width: double.infinity,
              height: 6.h,
              decoration: boxDecoration(
                radius: 10.0,
                color: AppColor().colorEdit(),
              ),
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
                          'Discount Type',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: ["flat", "percent"]
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: discountType.text,
                  onChanged: (value) {
                    setState(() {
                      discountType.text = value.toString();
                    });
                  },
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: AppColor.PrimaryDark,
                    ),
                    iconSize: 14,
                  ),

                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: 160,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: AppColor().colorEdit(),
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
                  //   color: AppColor.PrimaryDark,
                  // ),
                  // iconSize: 14,
                  // buttonHeight: 50,
                  // buttonWidth: 160,
                  // buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                  // buttonDecoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(14),
                  //   color: AppColor().colorEdit(),
                  // ),
                  // buttonElevation: 0,
                  // itemHeight: 40,
                  // itemPadding: const EdgeInsets.only(left: 14, right: 14),
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
              )),
          SizedBox(
            height: 1.h,
          ),
          // Card(
          //   elevation: 0,
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(14.0)),
          //   color: AppColor().colorEdit(),
          //   child: Container(
          //       width: double.infinity,
          //       height: 6.h,
          //       decoration: boxDecoration(
          //         radius: 14.0,
          //         bgColor: AppColor().colorEdit(),
          //       ),
          //       child: TextFormField(
          //         controller: tax,
          //         maxLines: 1,
          //         keyboardType: TextInputType.number,
          //         textAlignVertical: TextAlignVertical.center,
          //         decoration: const InputDecoration(
          //           hintText: "Tax",
          //           border: InputBorder.none,
          //           contentPadding:
          //               EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
          //           prefixIcon: Icon(
          //             Icons.money_rounded,
          //             color: AppColor.PrimaryDark,
          //           ),
          //         ),
          //       )),
          // ),
          // SizedBox(
          //   height: 1.h,
          // ),
          // Container(
          //     width: MediaQuery.of(context).size.width,
          //     child: Text("Tax Model")),
          // Container(
          //     width: double.infinity,
          //     height: 6.h,
          //     decoration: boxDecoration(
          //       radius: 10.0,
          //       color: AppColor().colorEdit(),
          //     ),
          //     child: DropdownButtonHideUnderline(
          //       child: DropdownButton2(
          //         isExpanded: true,
          //         hint: Row(
          //           children: const [
          //             Icon(Icons.countertops),
          //             // Image.asset(
          //             //   country,
          //             //   width: 6.04.w,
          //             //   height: 5.04.w,
          //             //   fit: BoxFit.fill,
          //             //   color: AppColor.PrimaryDark,
          //             // ),
          //             SizedBox(
          //               width: 4,
          //             ),
          //             Expanded(
          //               child: Text(
          //                 'Tex Model',
          //                 style: TextStyle(
          //                   fontSize: 14,
          //                   fontWeight: FontWeight.normal,
          //                 ),
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //             ),
          //           ],
          //         ),
          //         items: ["include", "exclude"]
          //             .map((item) => DropdownMenuItem<String>(
          //                   value: item,
          //                   child: Text(
          //                     item,
          //                     style: const TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.black,
          //                     ),
          //                     overflow: TextOverflow.ellipsis,
          //                   ),
          //                 ))
          //             .toList(),
          //         value: selectedTexModel.text,
          //         onChanged: (value) {
          //           setState(() {
          //             selectedTexModel.text = value.toString();
          //           });
          //         },
          //         icon: const Icon(
          //           Icons.arrow_forward_ios_outlined,
          //           color: AppColor.PrimaryDark,
          //         ),
          //         iconSize: 14,
          //         buttonHeight: 50,
          //         buttonWidth: 160,
          //         buttonPadding: const EdgeInsets.only(left: 14, right: 14),
          //         buttonDecoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(14),
          //           color: AppColor().colorEdit(),
          //         ),
          //         buttonElevation: 0,
          //         itemHeight: 40,
          //         itemPadding: const EdgeInsets.only(left: 14, right: 14),
          //         dropdownMaxHeight: 300,
          //         dropdownPadding: null,
          //         dropdownDecoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(14),
          //         ),
          //         dropdownElevation: 8,
          //         scrollbarRadius: const Radius.circular(40),
          //         scrollbarThickness: 6,
          //         scrollbarAlwaysShow: true,
          //       ),
          //     )),
          // SizedBox(
          //   height: 1.h,
          // ),
          // Card(
          //   elevation: 0,
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(14.0)),
          //   color: AppColor().colorEdit(),
          //   child: Container(
          //       width: double.infinity,
          //       height: 6.h,
          //       decoration: boxDecoration(
          //         radius: 14.0,
          //         bgColor: AppColor().colorEdit(),
          //       ),
          //       child: TextFormField(
          //         controller: videoLinkTextField,
          //         maxLines: 1,
          //         keyboardType: TextInputType.text,
          //         textAlignVertical: TextAlignVertical.center,
          //         decoration: const InputDecoration(
          //           hintText: "Youtube Video link",
          //           border: InputBorder.none,
          //           contentPadding:
          //               EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
          //           prefixIcon: Icon(
          //             Icons.video_camera_back_outlined,
          //             color: AppColor.PrimaryDark,
          //           ),
          //         ),
          //       )),
          // ),
          // SizedBox(
          //   height: 1.h,
          // ),
          // Card(
          //   elevation: 0,
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(14.0)),
          //   color: AppColor().colorEdit(),
          //   child: Container(
          //       width: double.infinity,
          //       height: 6.h,
          //       decoration: boxDecoration(
          //         radius: 14.0,
          //         bgColor: AppColor().colorEdit(),
          //       ),
          //       child: TextFormField(
          //         controller: shippingCostTextField,
          //         maxLines: 1,
          //         keyboardType: TextInputType.number,
          //         textAlignVertical: TextAlignVertical.center,
          //         decoration: const InputDecoration(
          //           hintText: "Shipping Cost",
          //           border: InputBorder.none,
          //           contentPadding:
          //               EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
          //           prefixIcon: Icon(
          //             Icons.local_shipping,
          //             color: AppColor.PrimaryDark,
          //           ),
          //         ),
          //       )),
          // ),
          SizedBox(
            height: 1.h,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Text(
                'Select Category',
              )),
          Container(
              width: double.infinity,
              height: 6.h,
              decoration: boxDecoration(
                radius: 10.0,
              ),
              child: FutureBuilder(
                  future: getServiceCategory(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<ServiceCategoryModel> serviceList = snapshot.data;
                      return Container(
                        width: double.infinity,
                        height: 6.h,
                        decoration: boxDecoration(
                          radius: 10.0,
                          color: AppColor().colorEdit(),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            hint: const Text(
                              'Select Category',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            items: serviceList
                                .map((item) => DropdownMenuItem<String>(
                                      value: item.name.toString(),
                                      child: Text(
                                        item.name!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            value: selectedCategory,
                            onChanged: (value) {
                              selectedCategory = value.toString();

                              for (var i = 0; i < serviceList.length; i++) {
                                if (serviceList[i].name == value) {
                                  categoryIdValue.text =
                                      serviceList[i].id.toString();
                                }
                              }
                              setState(() {});
                            },
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: AppColor.PrimaryDark,
                              ),
                              iconSize: 14,
                            ),

                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: 160,
                              padding: const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: AppColor().colorEdit(),
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
                            //   color: AppColor.PrimaryDark,
                            // ),
                            // iconSize: 14,
                            // buttonHeight: 50,
                            // buttonWidth: 160,
                            // buttonPadding:
                            //     const EdgeInsets.only(left: 14, right: 14),
                            // buttonDecoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(14),
                            //   color: AppColor().colorEdit(),
                            // ),
                            // buttonElevation: 0,
                            // itemHeight: 40,
                            // itemPadding:
                            //     const EdgeInsets.only(left: 14, right: 14),
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
                      );
                    } else if (snapshot.hasError) {
                      print("ERROR===" + snapshot.error.toString());
                      return const Icon(Icons.error_outline);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })),
          SizedBox(
            height: 2.62.h,
          ),

          SizedBox(
            height: 1.h,
          ),
          GestureDetector(
            onTap: () async {
              final plugin = DeviceInfoPlugin();
              final android = await plugin.androidInfo;

              final storageStatus = android.version.sdkInt! < 33
                  ? await Permission.storage.request()
                  : await Permission.photos.request();
              final status = await Permission.storage.request();
              if (storageStatus.isGranted) {
                //getFromGallery();
                // getSingleImagePicker();
                showOptions(context, "thumbnail");
              } else {
                print('=====permission denied=====');
              }
            },
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0)),
              color: AppColor().colorEdit(),
              child: Container(
                  width: double.infinity,
                  height: 10.46.h,
                  decoration: boxDecoration(
                    radius: 14.0,
                    bgColor: AppColor().colorEdit(),
                  ),
                  child:
                      // servicePic != null

                      Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.image,
                          color: AppColor.PrimaryDark,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        thumnailImage == null
                            ? const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text("Upload Thumbnail image"),
                                  ],
                                ),
                              )
                            : Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Image.file(File(thumnailImage!.path)),
                                ),
                              ),
                      ],
                    ),
                  )),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          SizedBox(
            height: 1.h,
          ),
          GestureDetector(
            onTap: () async {
              final plugin = DeviceInfoPlugin();
              final android = await plugin.androidInfo;

              final storageStatus = android.version.sdkInt! < 33
                  ? await Permission.storage.request()
                  : await Permission.photos.request();
              final status = await Permission.storage.request();
              if (storageStatus.isGranted) {
                //getFromGallery();
                // getImagePicker();
                showOptions(context, "service");
              } else {
                print('=====permission denied=====');
              }
            },
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0)),
              color: AppColor().colorEdit(),
              child: Container(
                  width: double.infinity,
                  height: 10.46.h,
                  decoration: boxDecoration(
                    radius: 14.0,
                    bgColor: AppColor().colorEdit(),
                  ),
                  child:
                      // servicePic != null

                      Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.image,
                          color: AppColor.PrimaryDark,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        imagePathList == null || imagePathList!.length == 0
                            ? const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text("Upload service image"),
                                  ],
                                ),
                              )
                            : Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imagePathList!.length,
                                    itemBuilder: (c, i) {
                                      return Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Image.file(
                                            File(imagePathList![i].path)),
                                      );
                                    }),
                              ),
                      ],
                    ),
                  )),
            ),
          ),
          ListView.builder(
              // scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.manageServiceModel.images?.length,
              itemBuilder: (context, index) {
                var item = widget.manageServiceModel.images?[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                      errorWidget: (ctx, url, err) => Image.asset(
                          Images.placeholderImage,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover),
                      placeholder: (ctx, url) => Image.asset(
                          Images.placeholderImage,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover),
                      imageUrl:
                          "${AppConstants.baseUrl}/storage/app/public/product/$item",
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover),
                );
              }),

          SizedBox(
            height: 2.5.h,
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading == true
                ? const CircularProgressIndicator()
                : Container(
                    height: 50,
                    width: double.maxFinite,
                    child: InkWell(
                      onTap: () async {
                        print("asklj");
                        // var userId = await MyToken.getUserID();
                        // print(selectedCategory11.id);
                        // print(serviceName.text.isNotEmpty);
                        // if (descriptionController.text.trim().toString().length < 100) {
                        //   return UtilityHlepar.getToast(
                        //       "Description must be of at least 100 characters.");
                        // }

                        // if (serviceName.text.isNotEmpty &&
                        //     selectedCAtegoryId != "" &&
                        //     serviceCharge.text.isNotEmpty) {
                        //   if (selectedCAtegoryId.isEmpty && categorylist.isNotEmpty ||
                        //       subcateid.isNotEmpty && serviceCharge.text.isNotEmpty) {
                        //     setState(() {
                        //       buttonLogin = true;
                        //     });

                        //     for (int i = 0; i < addonServicePriceControllerList.length; i++) {
                        //       if (addonServicePriceControllerList[i].text.isNotEmpty &&
                        //           addonHourDayPriceControllerList[i].text.isNotEmpty &&
                        //           selectedServiceTypeList[i] != null &&
                        //           selectedServiceHourList[i] != null) {
                        //         addonList.add(jsonEncode({
                        //           "service": selectedServiceTypeList[i],
                        //           "price_a": addonServicePriceControllerList[i].text,
                        //           "hrly": selectedServiceHourList[i],
                        //           "days_hrs": addonHourDayPriceControllerList[i].text
                        //         }));
                        //       }
                        //     }

                        //   } else if (selectedCategory11.id.toString() == "null") {
                        //     UtilityHlepar.getToast(ToastString.msgSelectServiceType);
                        //   } else if (categorylist.isEmpty) {
                        //     UtilityHlepar.getToast(ToastString.msgSelectServiceSubType);
                        //   } else if (serviceCharge.text.isEmpty) {
                        //     UtilityHlepar.getToast(ToastString.msgServiceCharge);
                        //   } else if (servicePic == null) {
                        //     UtilityHlepar.getToast("Service Image Required");
                        //   }
                        // } else {
                        //   UtilityHlepar.getToast("Please select fields");
                        // }

                        if (serviceName.text != '' &&
                            serviceDescription.text != '' &&
                            //  tax.text != '' &&
                            unitPrice.text != '' &&
                            discountValue.text != '' &&
                            // videoLinkTextField.text != '' &&
                            //  shippingCostTextField.text != '' &&
                            categoryIdValue.text != '' &&
                            imagePathList!.length != 0) {
                          var userId = await MyToken.getUserID();
                          Map<String, String> param = {
                            "service_id":
                                widget.manageServiceModel.id.toString(),
                            'name': '${serviceName.text.toString()}',
                            'description': '${serviceDescription.text}',
                            "unit_price": unitPrice.text,
                            "discount": discountValue.text,
                            "discount_type": discountType.text,
                            "tax": '1', //tax.text,
                            "tax_model": 'include', //selectedTexModel.text,
                            "category_id": categoryIdValue.text,
                            "lang": "en",
                            // "video_url": videoLinkTextField.text,
                            "shipping_cost": '0', // shippingCostTextField.text,
                            '_method': 'put'
                            // "thumbnail": thumbnailValue.text
                          };

                          print("ADD SERVICE PARAM=====" + param.toString());
                          bool addModel =
                              await updateServices(param, context: context);
                        } else {
                          UtilityHlepar.getToast('Please enter all the value');
                        }
                      },
                      child: UtilityWidget.lodingButton(
                          buttonLogin: buttonLogin, btntext: 'Update'),
                    )),
          ),
          const Text(
            "Note: Please add time availability to start booking on your service",
            style: TextStyle(color: AppColor.PrimaryDark, fontSize: 12),
          ),
          SizedBox(
            height: 1.h,
          ),
        ],
      ),
    );
  }

  List<ServiceCategoryModel>? serviceModelList;

  Future<List<ServiceCategoryModel>?> getServiceCategory() async {
    try {
      // Retrieve token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.token) ?? "";

      // Make GET request
      final response = await http.get(
        Uri.parse(
            '${AppConstants.baseUrl}/api/v3/seller/services/service-category'),
        headers: {'Authorization': 'Bearer $token'},
      );

      // Check for successful response
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List; // Parse JSON
        List<ServiceCategoryModel> list = jsonData
            .map((item) => ServiceCategoryModel.fromJson(item))
            .toList();

        for (var i = 0; i < list.length; i++) {
          if (list[i].id.toString() == categoryIdValue.text) {
            selectedCategory = list[i].name;
          }
        }
        return list;
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }

  Future<bool> updateServices(
    Map<String, String> param, {
    required BuildContext context,
  }) async {
    setState(() {
      isLoading = true;
    });

    try {
      print("ADD SERVICE PARAM: $param");

      // Retrieve the token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(AppConstants.token) ?? "";

      // Create the request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppConstants.baseUrl}/api/v3/seller/services/update/${widget.manageServiceModel.id}',
        ),
      );

      request.fields.addAll(param);
      request.headers['Authorization'] = 'Bearer $token';

      // Add image files if available
      if (imagePathList != null && imagePathList!.isNotEmpty) {
        for (var file in imagePathList!) {
          // Convert file to bytes and attach it as a MultipartFile
          var multipartFile = await http.MultipartFile.fromPath(
            'images[]', // Key for the array
            file.path,
          );
          request.files.add(multipartFile);
        }
      }

      if (thumnailImage != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          'thumbnail', // Key for the array
          thumnailImage!.path,
        );
        request.files.add(multipartFile);
      }
      // Log request details
      print("Request Files: ${request.files}");
      print("Request Fields: ${request.fields}");

      // Send the request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        print("Service updated successfully: $jsonResponse");
        UtilityHlepar.getToast('Service updated successfully');

        // Navigate to ManageServicesScreen on success
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const ManageServicesScreen()),
          );
        }

        setState(() {
          isLoading = false;
        });
        return true;
      } else {
        print("Failed to update service. Status Code: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
        return false;
      }
    } catch (e, stackTrace) {
      print("Exception occurred: $e");
      print("Stack trace: $stackTrace");
      UtilityHlepar.getToast('An error occurred. Please try again.');

      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

  getImagePicker() async {
    try {
      final image = await ImagePicker().pickMultiImage();
      print(image);
      // imagePathList = [];
      imagePathList!.addAll(image);
      setState(() {});
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  getSingleImagePicker() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      print(image);
      thumnailImage = image;

      setState(() {});
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  // Get Image from Camera
  void getSingleImageCamera() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      thumnailImage = image;
      setState(() {});
    }
  }

  // Get Image from Camera
  void getImageCamera() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      // imagePathList = [];
      imagePathList!.add(image);
      setState(() {});
    }
  }

  // Show Image picker options
  Future showOptions(BuildContext context, type) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Gallery'),
            onPressed: () {
              Navigator.of(context).pop();
              if (type == "thumbnail") {
                getSingleImagePicker();
              } else {
                getImagePicker();
              }
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop();
              if (type == "thumbnail") {
                getSingleImageCamera();
              } else {
                getImageCamera();
              }
            },
          ),
        ],
      ),
    );
  }
}
