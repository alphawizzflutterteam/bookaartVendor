import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/booking_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/provider/bank_info_provider.dart';
import 'package:sixvalley_vendor_app/provider/delivery_man_provider.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/provider/product_provider.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/shipping_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/view/base/custom_loader.dart';
import 'package:sixvalley_vendor_app/view/screens/home/widget/completed_order_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/home/widget/on_going_order_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/home/widget/order_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/home/widget/stock_out_product_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/product/top_selling_product.dart';

class HomePageScreen extends StatefulWidget {
  final Function? callback;
  const HomePageScreen({
    Key? key,
    this.callback,
  }) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final ScrollController _scrollController = ScrollController();
  Future<void> _loadData(BuildContext context, bool reload) async {
    Provider.of<ProfileProvider>(context, listen: false).getSellerInfo();
    Provider.of<BankInfoProvider>(context, listen: false).getBankInfo(context);
    /*Provider.of<OrderProvider>(context, listen: false)
        .getOrderList(context, 1, 'all');*/
    Provider.of<OrderProvider>(context, listen: false).getBookingList(context, 1, 'pending','','');
    Provider.of<OrderProvider>(context, listen: false)
        .getAnalyticsFilterData(context, 'overall');
    Provider.of<SplashProvider>(context, listen: false).getColorList();
    Provider.of<ProductProvider>(context, listen: false)
        .getStockOutProductList(1, 'en');
    Provider.of<ProductProvider>(context, listen: false)
        .getMostPopularProductList(1, context, 'en');
    Provider.of<ProductProvider>(context, listen: false)
        .getTopSellingProductList(1, context, 'en');
    Provider.of<ShippingProvider>(context, listen: false)
        .getCategoryWiseShippingMethod();
    Provider.of<ShippingProvider>(context, listen: false)
        .getSelectedShippingMethodType(context);
    Provider.of<DeliveryManProvider>(context, listen: false)
        .getTopDeliveryManList(context);
    Provider.of<BankInfoProvider>(context, listen: false)
        .getDashboardRevenueData(context, 'yearEarn');
  }

  @override
  void initState() {
    _loadData(context, false);
    Provider.of<OrderProvider>(context, listen: false).setAnalyticsFilterName(context, 'overall', false);
    Provider.of<OrderProvider>(context, listen: false).setAnalyticsFilterType(0, false);
    Provider.of<ProfileProvider>(context, listen: false).getSellerInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double limitedStockCardHeight = MediaQuery.of(context).size.width / 1.4;
    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const AddServices()),
      //     );
      //   },
      //   child: Icon(Icons.add),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          List<BookingData>? bookingList = [];
          bookingList = order.bookingModel?.data;
          return order.bookingModel != null
              ? RefreshIndicator(
                  onRefresh: () async {
                    Provider.of<OrderProvider>(context, listen: false)
                        .setAnalyticsFilterName(context, 'overall', true);
                    Provider.of<OrderProvider>(context, listen: false)
                        .setAnalyticsFilterType(0, true);
                    await _loadData(context, true);
                  },
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        floating: true,
                        elevation: 0,
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                        backgroundColor: Theme.of(context).primaryColor,
                        title: Image.asset(Images.logoWithAppName, height: 55),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            OngoingOrderWidget(
                              callback: widget.callback,
                            ),
                          //  CompletedOrderWidget(callback: widget.callback),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            const SizedBox(
                              height: 20,
                            ),

                            ListView.builder(
                              itemCount: bookingList?.length ?? 0,
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





                            double.parse(Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.wallet_maintain
                                        .toString()) > double.parse(Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.wallet!.totalEarning.toString())
                                ? const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    // child: Text(
                                    //   "Maintain minimum balance is ${Provider.of<SplashProvider>(context, listen: false).myCurrency!.symbol}${double.parse(Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.wallet_maintain.toString())} ",
                                    //   style: const TextStyle(
                                    //       fontWeight: FontWeight.w500,
                                    //       fontSize: Dimensions.fontSizeDefault,
                                    //       color: Colors.red),
                                    // ),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 20,
                            ),
                            // Consumer<ProductProvider>(
                            //     builder: (context, prodProvider, child) {
                            //   List<Product> productList;
                            //   productList = prodProvider.stockOutProductList;
                            //   return productList.isNotEmpty
                            //       ? Container(
                            //           height: limitedStockCardHeight,
                            //           decoration: BoxDecoration(
                            //             color: Theme.of(context).cardColor,
                            //             boxShadow: [
                            //               BoxShadow(
                            //                   color: ColorResources.getPrimary(
                            //                           context)
                            //                       .withOpacity(.05),
                            //                   spreadRadius: -3,
                            //                   blurRadius: 12,
                            //                   offset:
                            //                       Offset.fromDirection(0, 6))
                            //             ],
                            //           ),
                            //           child: StockOutProductView(
                            //               scrollController: _scrollController,
                            //               isHome: true),
                            //         )
                            //       : const SizedBox();
                            // }),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            // const ChartWidget(),
                            // const SizedBox(height: Dimensions.paddingSizeSmall),

                            //const TopSellingProductScreen(isMain: true),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            // Container(
                            //   color: Theme.of(context).primaryColor,
                            //     child: const MostPopularProductScreen(isMain: true)),
                            // const SizedBox(height: Dimensions.paddingSizeSmall),
                            //
                            // const TopDeliveryManView(isMain: true)
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : const CustomLoader();
        },
      ),
    );
  }
}
