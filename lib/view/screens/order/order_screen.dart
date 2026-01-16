import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/data/model/response/booking_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/globles.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/no_data_screen.dart';
import 'package:sixvalley_vendor_app/view/base/paginated_list_view.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';
import 'package:sixvalley_vendor_app/view/screens/home/widget/order_widget.dart';

import '../../../utill/images.dart';
import '../../base/custom_search_field.dart';

class OrderScreen extends StatefulWidget {
  final bool isBacButtonExist;
  final bool fromHome;
  const OrderScreen(
      {Key? key, this.isBacButtonExist = false, this.fromHome = false})
      : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  ScrollController scrollController = ScrollController();
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: CustomAppBar(
          title: /*getTranslated('my_order', context)*/'Bookings',
          isBackButtonExist: widget.isBacButtonExist),
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          //List<Order>? orderList = [];
          List<BookingData>? bookingList = [];
          bookingList = order.bookingModel?.data;
          //orderList = order.orderModel?.orders;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                    vertical: Dimensions.paddingSizeSmall),
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      OrderTypeButton(
                        text: getTranslated('all', context),
                        index: 0,
                      ),
                      const SizedBox(width: 5),
                      OrderTypeButton(
                          text: getTranslated('pending', context), index: 1),
                      // const SizedBox(width: 5),
                      // OrderTypeButton(text: getTranslated('processing', context), index: 2),
                      const SizedBox(width: 5),
                      OrderTypeButton(
                          text: getTranslated('confirmed', context), index: 7),
                      OrderTypeButton(
                          text: getTranslated('completed', context), index: 3),
                      // OrderTypeButton(
                      //     text: getTranslated('delivered', context), index: 3),
                      // const SizedBox(width: 5),
                      // OrderTypeButton(text: getTranslated('return', context), index: 4),
                      // const SizedBox(width: 5),
                      // OrderTypeButton(text: getTranslated('failed', context), index: 5),
                      const SizedBox(width: 5),
                      OrderTypeButton(
                          text: getTranslated('cancelled', context), index: 6),
                      const SizedBox(width: 5),

                      // const SizedBox(width: 5),
                      // OrderTypeButton(text: getTranslated('out_for_delivery', context), index: 8),
                    ],
                  ),
                ),
              ),

              Row(children: [
                Expanded(
                  child: SizedBox(height: 80,
                      child: Container(
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
                          child: CustomSearchField(
                            controller: searchController,
                            hint: 'Search by Booking id',
                            prefix: Images.iconsSearch,
                            iconPressed: () => (){},
                            onSubmit: (text) => (){},
                            onChanged: (value){
                              if(value.toString().isNotEmpty){

                                //searchProductController.initSellerProductList(userId.toString(), 1, context, 'en',value, reload: true);
                              }

                            },
                          ),
                        ),
                      )),
                ),
                ElevatedButton(
                  onPressed: () {

                    if(searchController.text.trim().isNotEmpty){
                      Provider.of<OrderProvider>(context, listen: false).setIndex(context, 0,search: searchController.text);

                    }

                  },
                  child: const Text('search'),
                ),
                SizedBox(width: 10,)

              ],),
              Padding(
          padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  Row(children: [
                    Text('From'),
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: () {
                        order.selectBookingDate('start', context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration:
                        BoxDecoration(
                          border:  Border.all(
                              width: 1, color: Theme.of(context).hintColor.withOpacity(.35)),

                          // color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),

                        ),child: Text( order.bookingStartDate== null ?'YYYY-MM-dd' : formatDate(order.bookingStartDate.toString())),),
                    ),
                  ],),
                  Row(children: [
                    Text('To'),
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: (){
                        order.selectBookingDate('end', context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration:
                        BoxDecoration(
                          border:  Border.all(
                              width: 1, color: Theme.of(context).hintColor.withOpacity(.35)),

                          // color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),

                        ),child: Text(order.endDate== null ?'YYYY-MM-dd' : formatDate(order.endDate.toString())),),
                    ),
                  ],),
                ],),
              ),
              order.bookingModel != null
                  ? bookingList!.isNotEmpty
                      ? Expanded(
                        child: SingleChildScrollView(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              //await order.getOrderList(context, 1, order.orderType);
                              await order.getBookingList(context, 1, order.orderType, order.startDate.toString(),order.endDate.toString());
                            },
                            child: PaginatedListView(
                              reverse: false,
                              scrollController: scrollController,
                              enabledPagination: true,
                              totalSize: order.bookingModel?.totalSize,
                              offset: order.bookingModel != null
                                  ? int.parse(
                                      order.bookingModel!.offset.toString())
                                  : null,
                              onPaginate: (int? offset) async {
                                await order.getBookingList(context, offset!, order.orderType, order.startDate.toString(),order.endDate.toString(),reload: false);
                               /* await order.getOrderList(
                                    context, offset!, order.orderType,
                                    reload: false);*/
                              },
                              itemView: ListView.builder(
                                itemCount: bookingList.length,
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return BookingWidget(
                                    bookingModel: bookingList![index],
                                    index: index,
                                  );

                                      /*OrderWidget(
                                    orderModel: bookingList![index],
                                    index: index,
                                  );*/
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                      : const Expanded(
                          child: NoDataScreen(
                          title: 'no_order_found',
                        ))
                  : const Expanded(child: OrderShimmer()),
            ],
          );
        },
      ),
    );
  }
}

class OrderShimmer extends StatelessWidget {
  const OrderShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          color: Theme.of(context).highlightColor,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10, width: 150, color: ColorResources.white),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: Container(height: 45, color: Colors.white)),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(height: 20, color: ColorResources.white),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                  height: 10, width: 70, color: Colors.white),
                              const SizedBox(width: 10),
                              Container(
                                  height: 10, width: 20, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OrderTypeButton extends StatelessWidget {
  final String? text;
  final int index;

  const OrderTypeButton({Key? key, required this.text, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Provider.of<OrderProvider>(context, listen: false)
              .setIndex(context, index);
        },
        child: Consumer<OrderProvider>(
          builder: (context, order, child) {
            return Container(
              height: 40,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeLarge,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: order.orderTypeIndex == index
                    ? Theme.of(context).primaryColor
                    : ColorResources.getButtonHintColor(context),
                borderRadius:
                    BorderRadius.circular(Dimensions.paddingSizeLarge),
              ),
              child: Text(text!,
                  style: order.orderTypeIndex == index
                      ? titilliumBold.copyWith(
                          color: order.orderTypeIndex == index
                              ? ColorResources.getWhite(context)
                              : ColorResources.getTextColor(context))
                      : robotoRegular.copyWith(
                          color: order.orderTypeIndex == index
                              ? ColorResources.getWhite(context)
                              : ColorResources.getTextColor(context))),
            );
          },
        ),
      ),
    );
  }
}
