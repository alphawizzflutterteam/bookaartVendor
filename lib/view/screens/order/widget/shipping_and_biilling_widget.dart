import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class ShippingAndBillingWidget extends StatelessWidget {
  final Order? orderModel;
  final bool? onlyDigital;
  const ShippingAndBillingWidget({Key? key, this.orderModel, this.onlyDigital})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (!onlyDigital!)
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault,
              vertical: Dimensions.paddingSizeMedium),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: ThemeShadow.getShadow(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: Dimensions.paddingSizeSmall),
                    child: Image.asset(Images.showOnMap,
                        color: ColorResources.getTextColor(context),
                        width: Dimensions.iconSizeSmall),
                  ),
                  Text(getTranslated('shipping_address', context)!,
                      style: titilliumSemiBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: ColorResources.titleColor(context),
                      )),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(
                  '${orderModel!.shippingAddressData != null ? jsonDecode(orderModel!.shippingAddressData!)['address'] : orderModel!.shippingAddress ?? ''}',
                  style: titilliumRegular.copyWith(
                      color: ColorResources.getTextColor(context))),
            ],
          ),
        ),
      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeMedium),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: ThemeShadow.getShadow(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                  child: Image.asset(Images.showOnMap,
                      color: ColorResources.getTextColor(context),
                      width: Dimensions.iconSizeSmall),
                ),
                Text(getTranslated('billing_address', context)!,
                    style: titilliumSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: ColorResources.titleColor(context),
                    )),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
                '${orderModel!.billingAddressData != null ? orderModel!.billingAddressData!.address!.trim() : orderModel!.billingAddress ?? ''}',
                style: titilliumRegular.copyWith(
                    color: ColorResources.getTextColor(context))),
          ],
        ),
      ),
      // const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      // Container(
      //   padding: const EdgeInsets.symmetric(
      //       horizontal: Dimensions.paddingSizeDefault,
      //       vertical: Dimensions.paddingSizeMedium),
      //   decoration: BoxDecoration(
      //       color: Theme.of(context).cardColor,
      //       boxShadow: ThemeShadow.getShadow(context)),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       // Row(
      //       //   children: [
      //       //     Padding(
      //       //       padding:
      //       //           const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
      //       //       child: Image.asset(Images.showOnMap,
      //       //           color: ColorResources.getTextColor(context),
      //       //           width: Dimensions.iconSizeSmall),
      //       //     ),
      //       //     Text(getTranslated('Order_Status', context)!,
      //       //         style: titilliumSemiBold.copyWith(
      //       //           fontSize: Dimensions.fontSizeLarge,
      //       //           color: ColorResources.titleColor(context),
      //       //         )),
      //       //   ],
      //       // ),
      //       // const SizedBox(height: Dimensions.paddingSizeSmall),
      //       // DropdownButtonFormField<String>(
      //       //   decoration: InputDecoration(
      //       //     border: OutlineInputBorder(
      //       //       borderRadius: BorderRadius.circular(8.0),
      //       //     ),
      //       //     contentPadding:
      //       //         const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      //       //   ),
      //       //   value: 'Pending',
      //       //   items: [
      //       //     'Delivered',
      //       //     'Received',
      //       //     'Out for Delivery',
      //       //     'Pending',
      //       //     'Confirmed',
      //       //     'Packaging',
      //       //     'Returned',
      //       //     'Cancelled',
      //       //     'Failed To Driver',
      //       //   ].map((String value) {
      //       //     return DropdownMenuItem<String>(
      //       //       value: value,
      //       //       child: Text(value),
      //       //     );
      //       //   }).toList(),
      //       //   onChanged: (newValue) {
      //       //     // Handle dropdown selection
      //       //     print('Selected Status: $newValue');
      //       //   },
      //       // ),
      //       // const SizedBox(height: Dimensions.paddingSizeSmall),
      //       // Row(
      //       //   children: [
      //       //     Padding(
      //       //       padding:
      //       //           const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
      //       //       child: Image.asset(Images.showOnMap,
      //       //           color: ColorResources.getTextColor(context),
      //       //           width: Dimensions.iconSizeSmall),
      //       //     ),
      //       //     Text(getTranslated('SElect_delivery', context)!,
      //       //         style: titilliumSemiBold.copyWith(
      //       //           fontSize: Dimensions.fontSizeLarge,
      //       //           color: ColorResources.titleColor(context),
      //       //         )),
      //       //   ],
      //       // ),
      //       // const SizedBox(height: Dimensions.paddingSizeSmall),
      //       // DropdownButtonFormField<String>(
      //       //   decoration: InputDecoration(
      //       //     border: OutlineInputBorder(
      //       //       borderRadius: BorderRadius.circular(8.0),
      //       //     ),
      //       //     contentPadding:
      //       //         const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      //       //   ),
      //       //   value: 'Choose Delivery Type',
      //       //   items: [
      //       //     'Choose Delivery Type',
      //       //     'Received',
      //       //     'Out for Delivery',
      //       //     'Pending',
      //       //     'Confirmed',
      //       //     'Packaging',
      //       //     'Returned',
      //       //     'Canceled',
      //       //     'Failed To Driver',
      //       //   ].map((String value) {
      //       //     return DropdownMenuItem<String>(
      //       //       value: value,
      //       //       child: Text(value),
      //       //     );
      //       //   }).toList(),
      //       //   onChanged: (newValue) {
      //       //     // Handle dropdown selection
      //       //     print('Selected Status: $newValue');
      //       //   },
      //       // ),
      //     ],
      //   ),
      // ),
    ]);
  }
}
