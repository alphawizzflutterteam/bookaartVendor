import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

import '../../../../provider/profile_provider.dart';
import '../../../base/custom_edit_dialog.dart';

class WalletCard extends StatelessWidget {
  final String? amount;
  final String? title;
  final Color? color;
  const WalletCard({Key? key, this.amount, this.title, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
      ),
      color: color,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.width / 3.8,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(amount.toString(),
                      style: robotoBold.copyWith(
                          color: ColorResources.getWhite(context),
                          fontSize: Dimensions.fontSizeWallet)),
                  Text(title!,
                      textAlign: TextAlign.center,
                      style: robotoRegular.copyWith(
                          color: ColorResources.getWhite(context),
                          fontSize: Dimensions.fontSizeLarge)),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width / 2.4,
              height: MediaQuery.of(context).size.width / 3.8,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(.15),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(100))),
            ),
          )
        ],
      ),
    );
  }
}

class WalletAddCard extends StatelessWidget {
  final String? amount;
  final String? title;
  final Color? color;
  const WalletAddCard({Key? key, this.amount, this.title, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
      ),
      color: color,
      child: Stack(
        children: [
          Consumer<ProfileProvider>(builder: (context, seller, child) {
            return Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.width / 3.8,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(amount.toString(),
                        style: robotoBold.copyWith(
                            color: ColorResources.getWhite(context),
                            fontSize: Dimensions.fontSizeWallet)),
                    Text(title!,
                        textAlign: TextAlign.center,
                        style: robotoRegular.copyWith(
                            color: ColorResources.getWhite(context),
                            fontSize: Dimensions.fontSizeLarge)),
                    SizedBox(
                      height: 2,
                    ),
                    InkWell(
                      onTap: () {
                        double balance =
                            seller.userInfoModel?.earning_wallet ?? 0.0;
                        if (seller.userInfoModel!.earning_wallet == null) {
                          Fluttertoast.showToast(
                              msg: "Please maintain amount grater than 500");
                          return;
                        } else if (balance < 500) {
                          Fluttertoast.showToast(
                              msg: "Please maintain amount grater than 500");
                          return;
                        }

                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            context: context,
                            builder: (_) => CustomEditDialog(
                                  type: 1,
                                ));
                      },
                      child: Container(
                        height: 30,
                        width: 110,
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
                                  builder: (_) => CustomEditDialog(type: 1)),
                              child: Text('Withdraw',
                                  style: titilliumRegular.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeLarge)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          Positioned(
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width / 2.4,
              height: MediaQuery.of(context).size.width / 3.8,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(.15),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(100))),
            ),
          )
        ],
      ),
    );
  }
}
