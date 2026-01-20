import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/booking_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/screens/order/order_details_screen.dart';

import '../../../../provider/order_provider.dart';
import '../../Subcriptionplans/MyBookingDetails.dart';

class OrderWidget extends StatelessWidget {
  final Order orderModel;
  final int? index;

  const OrderWidget({Key? key, required this.orderModel, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, order, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                print("Order Type:${orderModel.orderType} ");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(
                              orderModel: orderModel,
                              orderId: orderModel.id,
                              orderType: orderModel.orderType,
                              extraDiscount: orderModel.extraDiscount,
                              extraDiscountType: orderModel.extraDiscountType,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.paddingSizeSmall),
                    boxShadow: [
                      BoxShadow(
                          color: Provider.of<ThemeProvider>(context,
                                      listen: false)
                                  .darkTheme
                              ? Theme.of(context).primaryColor.withOpacity(0)
                              : Theme.of(context).primaryColor.withOpacity(.09),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(1, 2))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft:
                                  Radius.circular(Dimensions.paddingSizeSmall),
                              topRight: Radius.circular(
                                  Dimensions.paddingSizeSmall))),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.05),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeExtraSmall)),
                              child: Row(
                                children: [
                                  Text(
                                    '${getTranslated('order_no', context)}# ',
                                    style: robotoRegular.copyWith(
                                        color:
                                            ColorResources.getPrimary(context),
                                        fontSize: Dimensions.fontSizeLarge),
                                  ),
                                  Text(
                                    '${orderModel.id} ${orderModel.orderType == 'POS' ? '(POS)' : ''} ',
                                    style: robotoMedium.copyWith(
                                        color: ColorResources.getTextColor(
                                            context),
                                        fontSize: Dimensions.fontSizeLarge),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeExtraSmall)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  PriceConverter.convertPrice(
                                      context, orderModel.orderAmount ?? 0),
                                  style: robotoMedium.copyWith(
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(Dimensions.paddingSizeSmall),
                              bottomRight: Radius.circular(
                                  Dimensions.paddingSizeSmall))),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Dimensions.paddingSizeSmall,
                            0,
                            Dimensions.paddingSizeSmall,
                            Dimensions.paddingSizeSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            orderModel.createdAt != null
                                ? Text(
                                    DateConverter.localDateToIsoStringAMPM(
                                        DateTime.parse(orderModel.createdAt!)),
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).hintColor))
                                : const SizedBox(),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Order Note"),
                                Text('${orderModel.orderNote ?? ""}')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: Dimensions.iconSizeSmall,
                                      width: Dimensions.iconSizeSmall,
                                      child: Image.asset(orderModel
                                                  .orderStatus ==
                                              'pending'
                                          ? Images.orderPendingIcon
                                          : orderModel.orderStatus ==
                                                  'out_for_delivery'
                                              ? Images.outIcon
                                              : orderModel.orderStatus ==
                                                      'returned'
                                                  ? Images.returnIcon
                                                  : orderModel.orderStatus ==
                                                          'delivered'
                                                      ? Images.deliveredIcon
                                                      : Images.confirmPurchase),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          '${orderModel.orderStatus}' /*getTranslated(orderModel.orderStatus, context)!*/,
                                          style: robotoRegular.copyWith(
                                              color: ColorResources.getPrimary(
                                                  context))),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        orderModel.paymentMethod != null
                                            ? getTranslated(
                                                    orderModel.paymentMethod!,
                                                    context) ??
                                                ''
                                            : '',

                                        // Text(
                                        //     orderModel.paymentMethod != null
                                        //         ? getTranslated(
                                        //             orderModel.paymentMethod ?? '',
                                        //             context)!
                                        //         : '',
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color:
                                                Theme.of(context).hintColor)),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),
                                    SizedBox(
                                      height: Dimensions.iconSizeDefault,
                                      width: Dimensions.iconSizeDefault,
                                      child: Image.asset(
                                          orderModel.paymentMethod ==
                                                  'cash_on_delivery'
                                              ? Images.paymentIcon
                                              : orderModel.paymentMethod ==
                                                      'pay_by_wallet'
                                                  ? Images.payByWalletIcon
                                                  : Images.digitalPaymentIcon),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            orderModel.orderStatus == 'pending'
                                ? SizedBox()
                                : Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: (orderModel.orderStatus ==
                                                        'confirmed' ||
                                                    orderModel.orderStatus ==
                                                        'delivered' ||
                                                    orderModel.orderStatus ==
                                                        'processing' ||
                                                    orderModel.orderStatus ==
                                                        'out_for_delivery') &&
                                                orderModel.deliveryManStatus !=
                                                    2
                                            ? ColorResources.green
                                            : ColorResources.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child: Text(
                                      (orderModel.orderStatus == 'confirmed' ||
                                                  orderModel.orderStatus ==
                                                      'delivered' ||
                                                  orderModel.orderStatus ==
                                                      'processing' ||
                                                  orderModel.orderStatus ==
                                                      'out_for_delivery') &&
                                              orderModel.deliveryManStatus != 2
                                          ? "Accepted"
                                          : orderModel.deliveryManStatus == 2
                                              ? "Rejected by driver"
                                              : "Rejected",
                                      style: const TextStyle(
                                          color: ColorResources.white),
                                    ))),
                            orderModel.orderStatus == 'pending'
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          order.updateOrderStatus(
                                              orderModel.id,
                                              'confirmed',
                                              context,
                                              orderModel.orderStatus!);
                                        },
                                        child: Container(
                                            height: 30,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            decoration: BoxDecoration(
                                              color: ColorResources.green,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                                child: Text(
                                              "Accept",
                                              style: TextStyle(
                                                  color: ColorResources.white),
                                            ))),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print("tap herere");
                                          order.updateOrderStatus(
                                              orderModel.id,
                                              'canceled',
                                              context,
                                              orderModel.orderStatus!);
                                        },
                                        child: Container(
                                          height: 30,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          decoration: BoxDecoration(
                                            color: ColorResources.red,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Reject",
                                              style: TextStyle(
                                                  color: ColorResources.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],
        ),
      );
    });
  }
}

class BookingWidget extends StatelessWidget {
  final BookingData bookingModel;
  final int? index;

  const BookingWidget({Key? key, required this.bookingModel, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, order, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BookingDetailsScreen(
                              bookingData: bookingModel,
                              status: bookingModel.status ?? 0,
                            ) /*OrderDetailsScreen(
                          orderModel: orderModel,
                          orderId: orderModel.id,
                          orderType: orderModel.orderType,
                          extraDiscount: orderModel.extraDiscount,
                          extraDiscountType: orderModel.extraDiscountType,
                        )*/
                        ));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.paddingSizeSmall),
                    boxShadow: [
                      BoxShadow(
                          color: Provider.of<ThemeProvider>(context,
                                      listen: false)
                                  .darkTheme
                              ? Theme.of(context).primaryColor.withOpacity(0)
                              : Theme.of(context).primaryColor.withOpacity(.09),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(1, 2))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft:
                                  Radius.circular(Dimensions.paddingSizeSmall),
                              topRight: Radius.circular(
                                  Dimensions.paddingSizeSmall))),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.05),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeExtraSmall)),
                              child: Row(
                                children: [
                                  Text(
                                    '${getTranslated('booking_no', context)}# ',
                                    style: robotoRegular.copyWith(
                                        color:
                                            ColorResources.getPrimary(context),
                                        fontSize: Dimensions.fontSizeLarge),
                                  ),
                                  Text(
                                    '${bookingModel.bookingId}',
                                    style: robotoMedium.copyWith(
                                        color: ColorResources.getTextColor(
                                            context),
                                        fontSize: Dimensions.fontSizeLarge),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeExtraSmall)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  PriceConverter.convertPrice(
                                      context, bookingModel.paidAmount ?? 0),
                                  style: robotoMedium.copyWith(
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(Dimensions.paddingSizeSmall),
                              bottomRight: Radius.circular(
                                  Dimensions.paddingSizeSmall))),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Dimensions.paddingSizeSmall,
                            0,
                            Dimensions.paddingSizeSmall,
                            Dimensions.paddingSizeSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bookingModel.createdAt != null
                                ? Text(
                                    DateConverter.localDateToIsoStringAMPM(
                                        DateTime.parse(
                                            bookingModel.createdAt!)),
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).hintColor))
                                : const SizedBox(),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Service:',
                                ),
                                Text(
                                  '${bookingModel.service?.name}',
                                ),
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Booking Note"),
                                Text(bookingModel.orderNote ?? "")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: Dimensions.iconSizeSmall,
                                      width: Dimensions.iconSizeSmall,
                                      child:
                                          Image.asset(bookingModel.status == 0
                                              ? Images.orderPendingIcon
                                              : bookingModel.status == 1
                                                  ? Images.confirmPurchase
                                                  : bookingModel.status == 2
                                                      ? Images.deliveredIcon
                                                      : bookingModel.status == 4
                                                          ? Images.deliveredIcon
                                                          : Images.outIcon),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          bookingModel.status == 0
                                              ? 'Pending'
                                              : bookingModel.status == 1
                                                  ? 'Confirmed'
                                                  : bookingModel.status == 2
                                                      ? 'Completed'
                                                      : 'Cancelled' /*getTranslated(orderModel.orderStatus, context)!*/,
                                          style: robotoRegular.copyWith(
                                              color: ColorResources.getPrimary(
                                                  context))),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        bookingModel.paymentMethod != null
                                            ? bookingModel.paymentMethod!
                                            : '',

                                        // Text(
                                        //     orderModel.paymentMethod != null
                                        //         ? getTranslated(
                                        //             orderModel.paymentMethod ?? '',
                                        //             context)!
                                        //         : '',
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color:
                                                Theme.of(context).hintColor)),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),
                                    SizedBox(
                                      height: Dimensions.iconSizeDefault,
                                      width: Dimensions.iconSizeDefault,
                                      child: Image.asset(
                                          bookingModel.paymentMethod == ''
                                              ? Images.paymentIcon
                                              : bookingModel.paymentMethod ==
                                                      'wallet'
                                                  ? Images.payByWalletIcon
                                                  : Images.digitalPaymentIcon),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            bookingModel.status != 0
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: (){

                                              //Confirm == '1', Cancel o r reject == '4' for api
                                              order.updateBookingStatus(bookingModel.id, '1', context, order.orderType);


                                            },
                                            child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: ColorResources.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                    child: Text(
                                                  "Accept",
                                                  style: const TextStyle(
                                                      color:
                                                          ColorResources.white),
                                                ))),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: (){
                                              //Confirm == '1', Cancel o r reject == '4' for api
                                              order.updateBookingStatus(bookingModel.id, '4', context, order.orderType);
                                            },
                                            child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: ColorResources.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                    child: Text(
                                                  "Reject",
                                                  style: const TextStyle(
                                                      color:
                                                          ColorResources.white),
                                                ))),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                            /*bookingModel.orderStatus == 'pending'
                                ? Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    order.updateOrderStatus(
                                        orderModel.id,
                                        'confirmed',
                                        context,
                                        orderModel.orderStatus!);
                                  },
                                  child: Container(
                                      height: 30,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          4,
                                      decoration: BoxDecoration(
                                        color: ColorResources.green,
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child: Text(
                                            "Accept",
                                            style: TextStyle(
                                                color: ColorResources.white),
                                          ))),
                                ),
                                InkWell(
                                  onTap: () {
                                    print("tap herere")
                                    ;                                          order.updateOrderStatus(
                                        orderModel.id,
                                        'canceled',
                                        context,
                                        orderModel.orderStatus!);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        4,
                                    decoration: BoxDecoration(
                                      color: ColorResources.red,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Reject",
                                        style: TextStyle(
                                            color: ColorResources.white),
                                      ),),),
                                )
                              ],
                            )
                                : SizedBox()*/
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],
        ),
      );
    });
  }
}
