import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/provider/transaction_provider.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_edit_dialog.dart';
import 'package:sixvalley_vendor_app/view/screens/wallet/widget/fund_screen.dart';

import '../../../../provider/splash_provider.dart';
import '../../wallettransaction/walletdialog.dart';

class WithdrawBalanceWidget extends StatefulWidget {
  const WithdrawBalanceWidget({Key? key}) : super(key: key);

  @override
  State<WithdrawBalanceWidget> createState() => _WithdrawBalanceWidgetState();
}

class _WithdrawBalanceWidgetState extends State<WithdrawBalanceWidget> {
  Razorpay? _razorpay;
  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false)
        .getWithdrawMethods(context);
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await Provider.of<TransactionProvider>(context, listen: false)
        .addMoney(context, response.paymentId, pricerazorpayy);

    Provider.of<ProfileProvider>(context, listen: false).getSellerInfo();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment cancelled by user");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  double pricerazorpayy = 0.0;

  void openCheckout(amount) async {
    double res = double.parse(amount.toString());
    pricerazorpayy = int.parse(res.toStringAsFixed(0)) * 100;
    // Navigator.of(context).pop();
    var options = {
      'key': 'rzp_live_RjWvwz0w0hjKkI',//'rzp_test_1DP5mmOlF5G5ag',
      'amount': "$pricerazorpayy",
      'name': 'Townway',
      'image': 'assets/images/Group 165.png',
      'description': 'Townway',
    };
    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode =
        Provider.of<ThemeProvider>(context, listen: false).darkTheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeDefault,
              0, Dimensions.paddingSizeMedium),
          color: Theme.of(context).cardColor,
          alignment: Alignment.center,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width / 2,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: Dimensions.paddingSizeDefault),
                margin: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius:
                      BorderRadius.circular(Dimensions.paddingSizeSmall),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[darkMode ? 900 : 200]!,
                        spreadRadius: 0.5,
                        blurRadius: 0.3)
                  ],
                ),
              ),
              Positioned(
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width - 70,
                  height: MediaQuery.of(context).size.width / 2.2,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(.10),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(
                              MediaQuery.of(context).size.width / 2.5))),
                ),
              ),
              Consumer<ProfileProvider>(builder: (context, seller, child) {
                return Container(
                  height: MediaQuery.of(context).size.width / 2.1,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  margin: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: Dimensions.logoHeight,
                              height: Dimensions.logoHeight,
                              child: Image.asset(Images.cardWhite)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Available Balance',
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: Colors.white)),
                              const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall,
                              ),
                              Text(
                                  PriceConverter.convertPrice(
                                      context,
                                      seller.userInfoModel!.wallet != null
                                          ? seller.userInfoModel!.wallet!
                                                  .totalEarning ??
                                              0
                                          : 0),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: Dimensions
                                          .fontSizeWithdrawableAmount)),
                            ],
                          ),
                          const SizedBox(
                            width: Dimensions.logoHeight,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Dimensions.paddingSizeLarge,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /*InkWell(
                            onTap: () async {
                              var data = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddMoneyDialog();
                                },
                              );

                              if (data != null) {
                                print('object open $data');
                                openCheckout(data);
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 130,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFEEF6FF),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeSmall)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             FundScreen()));
                                      // var data = await showDialog(
                                      //   context: context,
                                      //   builder: (BuildContext context) {
                                      //     return AddMoneyDialog();
                                      //   },
                                      // );
                                      // if (data != null) {
                                      //   print('object open $data');
                                      //   // openCheckout(data);
                                      // }
                                    },
                                    child: Text('Add Money',
                                        style: titilliumRegular.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize:
                                                Dimensions.fontSizeLarge)),
                                  ),
                                ],
                              ),
                            ),
                          ),*/

                          /// Her Other Main Wallet
                          InkWell(
                            onTap: () {
                              double balance =
                                  seller.userInfoModel?.wallet?.totalEarning ??
                                      0.0;
                              if (seller.userInfoModel?.wallet?.totalEarning ==
                                  null) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Please maintain amount grater than 500");
                                return;
                              } else if (balance < 500) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Please maintain amount grater than 500");
                                return;
                              }

                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) => CustomEditDialog(
                                        type: 2,
                                      ));
                            },
                            child: Container(
                              height: 40,
                              width: 130,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFEEF6FF),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeSmall)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () => showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (_) => CustomEditDialog(
                                              type: 2,
                                            )),
                                    child: Text('Withdraw',
                                        style: titilliumRegular.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize:
                                                Dimensions.fontSizeLarge)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          "Note: You need to add minimum ${Provider.of<SplashProvider>(context, listen: false).myCurrency!.symbol}${double.parse(Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.wallet_maintain.toString())} in your wallet to get orders.",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: Dimensions.fontSizeDefault,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
