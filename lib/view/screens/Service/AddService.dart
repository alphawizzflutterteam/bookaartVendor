import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/data/model/response/seller_category_model.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/shop_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/ServiceCategoryModel.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/colors.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/manage_Service.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/utility_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/widget.dart';
import 'package:sixvalley_vendor_app/view/screens/Subcriptionplans/app_token_data.dart';
import 'package:sixvalley_vendor_app/view/screens/Subcriptionplans/utility_hlepar.dart';
import 'package:sizer/sizer.dart';

import '../../../data/model/response/manage_service_model.dart';
import '../../../localization/language_constrants.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/globles.dart';
import '../../../utill/images.dart';
import '../../../utill/styles.dart';
import '../../../widgets/app_dropdown.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import '../../base/textfeild/custom_text_feild.dart';

class AddServices extends StatefulWidget {
  const AddServices({Key? key,
     this.service
  }) : super(key: key);

  final ManageServiceModel? service;

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {

  List<Map<String, dynamic>> timeSlots = [
    {
      'id': 1,
      'date': DateTime.now(),
      'fromTime': null,
      'toTime': null,
    },
  ];


  bool buttonLogin = false;
  String? selectedCategory;

  List<XFile>? imagePathList = [];

  XFile? thumnailImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var provider = Provider.of<SellerProvider>(context,listen: false);
    if(widget.service !=null) {
      provider.serviceName.text = widget.service?.name ?? '' ;
      provider.serviceDescription.text = widget.service?.details ?? '' ;
      provider.unitPriceC.text = '${widget.service?.unitPrice ?? ''}';
      provider.tax.text = '${widget.service?.tax ?? ''}';
      provider.discountC.text = '${widget.service?.discount ?? ''}';
      provider.serviceDiscountType = widget.service?.discountType?.toLowerCase();
      provider.texModel = widget.service?.taxModel?.toLowerCase();
      provider.serviceType = widget.service?.serviceType?.toLowerCase();

      timeSlots = [];
      widget.service?.timeSlots?.forEach((element) {

        timeSlots.add({
          'id': element.id,
          'date': DateTime.tryParse(element.date ?? '') ?? DateTime.now(),
          'fromTime': element.fromTime!=null || element.fromTime!=''? parseTimeOfDay(element.fromTime!): null,
          'toTime': element.fromTime!=null || element.fromTime!=''? parseTimeOfDay(element.toTime!): null,
        });
        
      },);

      setState(() {});

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: /*getTranslated('Manage_Services', context)*/widget.service !=null ? 'Update':'Add Service',
        isBackButtonExist: true,
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

   return Consumer<SellerProvider>(builder: (authContext, provider, _) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 2.62.h,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
              'Service Name',
              style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault)),
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
              hintText: "Service Name",
              //focusNode: authProvider.areaNode,
             // nextNode: authProvider.shopAddressNode,
              textInputType: TextInputType.text,
              controller: provider.serviceName,
              textInputAction: TextInputAction.next,
            )),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
              'Description',
              style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault)),
        ),
        Container(
            margin: const EdgeInsets.only(
                left: Dimensions.paddingSizeLarge,
                right: Dimensions.paddingSizeLarge,
                bottom: Dimensions.paddingSizeSmall,
                top: Dimensions.paddingSizeSmall),
            child: CustomTextField(
              border: true,

              maxLine: 5,
              hintText: "Service Description",
              //focusNode: authProvider.areaNode,
              // nextNode: authProvider.shopAddressNode,
              textInputType: TextInputType.text,
              controller: provider.serviceDescription,
              textInputAction: TextInputAction.next,
            )),
        Row(
          children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                      'Unit Price',
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault)),
                ),
                Container(
                    margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),

                    child: CustomTextField(
                      border: true,
                      maxSize: 12,
                      hintText: "₹ Unit Price",
                      //focusNode: authProvider.areaNode,
                      // nextNode: authProvider.shopAddressNode,
                      textInputType: TextInputType.number,
                      controller:provider.unitPriceC,
                      textInputAction: TextInputAction.next,
                    )),
              ],),
          ),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                        'Service Type',
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault)),
                  ),
                  AppDropdown<String>(
                    margin: EdgeInsets.all(10),
                    items:  ['home', 'center','both'],
                    value: provider.serviceType,
                    hintText: 'Service type',
                    onChanged: (value) {

                      provider.serviceType = value;
                      setState(() {

                      });
                      // int index = provider.sellerCategoryList!.indexWhere((element) => element.name == value,);
                      // if(index !=-1) {
                      //   provider.getSellerSubCategoryList(index);
                      // }

                    },
                  ),
                ],),
          )
        ],),
        Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                    'Discount Type',
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault)),
              ),
              AppDropdown<String>(
                margin: EdgeInsets.all(10),
                items:  ['flat', 'percent'],
                value: provider.serviceDiscountType,
                hintText: 'Discount Type',
                onChanged: (value) {
                  provider.serviceDiscountType = value!;
                  setState(() {

                  });
                  // int index = provider.sellerCategoryList!.indexWhere((element) => element.name == value,);
                  // if(index !=-1) {
                  //   provider.getSellerSubCategoryList(index);
                  // }

                },
              ),
            ],),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                    'Tax Model',
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault)),
              ),
              AppDropdown<String>(
                margin: EdgeInsets.all(10),
                items:  ['exclude', 'include'],
                value: provider.texModel,
                hintText: 'Tax Model',
                onChanged: (value) {

                  provider.texModel = value;
                  setState(() {});
                  // int index = provider.sellerCategoryList!.indexWhere((element) => element.name == value,);
                  // if(index !=-1) {
                  //   provider.getSellerSubCategoryList(index);
                  // }

                },
              ),
            ],),
          )
        ],),
        Row(children: [
         Expanded(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,

             children: [
             Padding(
               padding: const EdgeInsets.only(left: 10),
               child: Text(
                   'Discount',
                   style: robotoRegular.copyWith(
                       fontSize: Dimensions.fontSizeDefault)),
             ),
             Container(
                 margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                 child: CustomTextField(
                   border: true,
                   maxSize: 12,
                   hintText: "\$ Discount",
                   //focusNode: authProvider.areaNode,
                   // nextNode: authProvider.shopAddressNode,
                   textInputType: TextInputType.number,
                   controller: provider.discountC,
                   textInputAction: TextInputAction.next,
                 )),
           ],),
         ),
         Expanded(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
             Padding(
               padding: const EdgeInsets.only(left: 10),
               child: Text(
                   'Tax',
                   style: robotoRegular.copyWith(
                       fontSize: Dimensions.fontSizeDefault)),
             ),
             Container(
             margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                 child: CustomTextField(
                   border: true,
                   maxSize: 12,
                   hintText: "Tax",
                   //focusNode: authProvider.areaNode,
                   // nextNode: authProvider.shopAddressNode,
                   textInputType: TextInputType.number,
                   controller: provider.tax,
                   textInputAction: TextInputAction.next,
                 )),
           ],),
         )
       ],),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(
              'Time Slot',
              style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault)),

            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  )
              ),
              onPressed: () {
                addNewSlot();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add  '),
            ),
          ],
          ),
        ),

        _mobileCards(),

        // Service Image
        const SizedBox(height: Dimensions.paddingSizeDefault),
        Padding(
          padding: const EdgeInsets.only(
              left: Dimensions.paddingSizeLarge,
              right: Dimensions.paddingSizeLarge,
              bottom: Dimensions.paddingSizeDefault),
          child: Row(
            children: [
              Text('Service Image',
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
                  child: provider.serviceImage != null
                      ? Image.file(
                    File(provider.serviceImage!.path),
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
                    onTap: () => provider.pickServiceImage(
                        true, false, false),
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
        Padding(
          padding: const EdgeInsets.only(
              left: Dimensions.paddingSizeLarge,
              right: Dimensions.paddingSizeLarge,
              bottom: Dimensions.paddingSizeDefault),
          child: Row(
            children: [
              Text('Service Thumbnail',
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
                  child: provider.serviceThumbnail != null
                      ? Image.file(
                    File(provider.serviceThumbnail!.path),
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
                    onTap: () => provider.pickServiceImage(
                        false, true, false),
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

        SizedBox(
          height: 1.h,
        ),
        /*SizedBox(
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
                              color: Colors.blue,
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
                          //   color: Colors.blue,
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
                    print("ERROR===${snapshot.error}");
                    return const Icon(Icons.error_outline);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })),*/
        SizedBox(
          height: 2.62.h,
        ),

        provider.isLoading ? Center(child: CircularProgressIndicator())
                           : CustomButton(
          btnTxt: 'Submit',
          onTap: () {
            if (provider.serviceName.text
                .trim()
                .isEmpty) {
              showCustomSnackBar('service name is required',
                  context);
            } else if (provider.serviceDescription.text
                .trim()
                .isEmpty) {
              showCustomSnackBar('description name is required',
                  context);
            } else if (provider.unitPriceC.text
                .trim()
                .isEmpty) {
              showCustomSnackBar('unit price is required',
                  context);
            } else if (provider.serviceType==null) {
              showCustomSnackBar('service type is required', context);
            }else if (provider.texModel==null) {
              showCustomSnackBar('tax model is required', context);
            }else if (provider.tax.text.trim().isEmpty) {
              showCustomSnackBar('tax is required', context);
            }
            else if (timeSlots.any((element) => element['fromTime']==null ||element['toTime']==null ,)) {
              showCustomSnackBar('add time slot properly', context);
            }else if (provider.serviceImage==null && widget.service == null ) {
              showCustomSnackBar('add service image', context);
            } else if (provider.serviceThumbnail==null && widget.service == null) {
              showCustomSnackBar('add service thumbnail', context);
            }
            else {
              SellerServiceModel serviceModel = SellerServiceModel(
                  name: provider.serviceName.text,
                  description: provider.serviceDescription.text,
                  discount: provider.discountC.text,
                  discountType: provider.serviceDiscountType,
                  fromTime: timeSlots.first['fromTime'].toString(),
                  toTime: timeSlots.first['toTime'].toString(),
                  date: timeSlots.first['date'].toString(),
                  serviceType: provider.serviceType,
                  tax: provider.tax.text,
                  taxModel: provider.texModel,
                  unitPrice: provider.unitPriceC.text,
                  sellerCategoryId:  Provider.of<ProfileProvider>(context,listen: false).userInfoModel?.sellerCategoryId.toString(),
                  sellerSubCategoryId: Provider.of<ProfileProvider>(context,listen: false).userInfoModel?.sellerSubCategoryId.toString(),
                  isFaster: 0,
                  timeSlot: timeSlots
              );
              provider.addService(context, serviceModel,id: widget.service?.id);
            }


          },
        ),


        SizedBox(
          height: 1.h,
        ),
      ],
    );

   });
  }



  Widget _mobileCards() {
    return Column(
      children: List.generate(timeSlots.length, (index) {
        final slot = timeSlots[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).hintColor.withOpacity(.35),
            ),
            borderRadius:
            BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Date'),
              _inputBox(
                text: formatDate(slot['date']),
                onTap: () => pickDate(index),
                forDate: true,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('From Time'),
                        _inputBox(
                          text: formatTime(slot['fromTime']),
                          onTap: () => pickTime(index, 'fromTime'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('To Time'),
                        _inputBox(
                          text: formatTime(slot['toTime']),
                          onTap: () => pickTime(index, 'toTime'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.delete, size: 18),
                label: const Text('Remove Slot'),
                onPressed: () => removeSlot(slot['id']),
              ),
            ],
          ),
        );
      }),
    );
  }
  Widget _inputBox({required String text, required VoidCallback onTap, bool? forDate }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).hintColor.withOpacity(.35),
          ),
          borderRadius:
          BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(text, style: const TextStyle(fontSize: 14)),Icon( forDate ?? false ? Icons.calendar_month: Icons.timer)],),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xff6B7280),
        ),
      ),
    );
  }


  Future<void> pickDate(int index) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: timeSlots[index]['date'] ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => timeSlots[index]['date'] = picked);
    }
  }

  Future<void> pickTime(int index, String key) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: timeSlots[index][key] ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => timeSlots[index][key] = picked);
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return DateFormat('dd/MM/yyyy').format(date);
  }



  void addNewSlot() {
    setState(() {
      timeSlots.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'date': null,
        'fromTime': null,
        'toTime': null,
      });
    });
  }

  void removeSlot(int id) {
    setState(() {
      timeSlots.removeWhere((e) => e['id'] == id);
    });
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
        return jsonData
            .map((item) => ServiceCategoryModel.fromJson(item))
            .toList();
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }







}

