import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/data/model/response/delivery_man_detail_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_drop_down_item.dart';
import 'package:sixvalley_vendor_app/view/screens/order/widget/delivery_man_assign_widget.dart';

class OrderSetup extends StatefulWidget {
  final String? orderType;
  Order? orderModel;
  final bool onlyDigital;
  OrderSetup(
      {Key? key, this.orderType, this.orderModel, this.onlyDigital = false})
      : super(key: key);

  @override
  State<OrderSetup> createState() => _OrderSetupState();
}

class _OrderSetupState extends State<OrderSetup> {
  @override
  void initState() {
    Provider.of<OrderProvider>(Get.context!, listen: false)
        .getDeliveryManList(context);
    // print("ressppsp ${widget.orderModel!.deliveryManId}");
    selectedDeliveryId = widget.orderModel!.deliveryManId != null
        ? widget.orderModel!.deliveryManId.toString()
        : null;

    // print(
    //     "selectedDeliveryId ${selectedDeliveryId}, ${widget.orderModel!.deliveryManId}");
    // TODO: implement initState
    super.initState();
  }

  String? selectedDeliveryId;

  @override
  Widget build(BuildContext context) {
    bool inHouseShipping = false;
    String? shipping = Provider.of<SplashProvider>(context, listen: false)
        .configModel!
        .shippingMethod;
    if (shipping == 'inhouse_shipping' &&
        (widget.orderModel!.orderStatus == 'out_for_delivery' ||
            widget.orderModel!.orderStatus == 'delivered' ||
            widget.orderModel!.orderStatus == 'returned' ||
            widget.orderModel!.orderStatus == 'failed' ||
            widget.orderModel!.orderStatus == 'cancelled')) {
      inHouseShipping = true;
    } else {
      inHouseShipping = false;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          title: getTranslated('order_setup', context),
          isBackButtonExist: true),
      body: Column(
        children: [
          Consumer<OrderProvider>(builder: (context, order, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: Dimensions.paddingSizeMedium,
                ),
                inHouseShipping
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Dimensions.paddingSizeDefault,
                            Dimensions.paddingSizeExtraSmall,
                            Dimensions.paddingSizeDefault,
                            Dimensions.paddingSizeSmall),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: .5,
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(.125)),
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(.12),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeExtraSmall)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(Dimensions.paddingSize),
                              child: Text(getTranslated(
                                  widget.orderModel!.orderStatus, context)!),
                            )),
                      )
                    : CustomDropDownItem(
                        title: 'order_status',
                        widget: DropdownButtonFormField<String>(
                          value: widget.orderModel!.orderStatus,
                          isExpanded: true,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          iconSize: 24,
                          elevation: 16,
                          style: robotoRegular,
                          onChanged: (value) {
                            order.updateOrderStatus(
                                widget.orderModel!.id,
                                value,
                                context,
                                widget.orderModel!.orderStatus!);
                          },
                          items: order.orderStatusList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(getTranslated(value, context)!,
                                  style: robotoRegular.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color)),
                            );
                          }).toList(),
                        ),
                      ),

                CustomDropDownItem(
                  title: 'payment_status',
                  widget: DropdownButtonFormField<String>(
                    value: widget.orderModel!.paymentStatus,
                    isExpanded: true,
                    decoration: const InputDecoration(border: InputBorder.none),
                    iconSize: 24,
                    elevation: 16,
                    style: robotoRegular,
                    onChanged: (value) {
                      order.setPaymentMethodIndex(value == 'paid' ? 0 : 1);
                      order.updatePaymentStatus(
                          orderId: widget.orderModel!.id,
                          status: value,
                          context: context);
                    },
                    items: <String>['paid', 'unpaid'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(getTranslated(value, context)!,
                            style: robotoRegular.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color)),
                      );
                    }).toList(),
                  ),
                ),

                widget.orderModel!.orderStatus == "delivered"
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeMedium),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: Dimensions.paddingSizeSmall),
                                  child: Image.asset(Images.showOnMap,
                                      color:
                                          ColorResources.getTextColor(context),
                                      width: Dimensions.iconSizeSmall),
                                ),
                                Text(
                                    getTranslated(
                                        'select_delivery_man', context)!,
                                    style: titilliumSemiBold.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                      color: ColorResources.titleColor(context),
                                    )),
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                              value: order.deliveryManList?.any((dm) =>
                                          dm.id.toString() ==
                                          selectedDeliveryId) ==
                                      true
                                  ? selectedDeliveryId
                                  : null,
                              hint: const Text('Select Delivery Man'),
                              items: (order.deliveryManList ?? [])
                                  .map((DeliveryMan value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(
                                      '${value.fName ?? ''} ${value.lName ?? ''}'),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                order.getOrderList(context, 1, order.orderType);

                                order.assignDeliveryMan(context, newValue ?? "",
                                    widget.orderModel!.id!);
                                selectedDeliveryId = newValue;
                              },
                            ),
                          ],
                        ),
                      ),

                // !widget.onlyDigital?
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                //   child: DeliveryManAssignWidget(orderType: widget.orderType,orderModel: widget.orderModel,
                //       orderId: widget.orderModel!.id),
                // ):const SizedBox(),
              ],
            );
          }),
        ],
      ),
    );
  }
}
