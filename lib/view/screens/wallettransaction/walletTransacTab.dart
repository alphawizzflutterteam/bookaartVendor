import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/view/screens/transaction/transaction_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/wallettransaction/earningbonusScreen.dart';
import 'package:sixvalley_vendor_app/view/screens/wallettransaction/walletaddtransaction.dart';

import '../../../localization/language_constrants.dart';
import '../../../provider/auth_provider.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/styles.dart';
import '../../base/custom_app_bar.dart';

class WalletTransactionTab extends StatefulWidget {
  const WalletTransactionTab();

  @override
  State<WalletTransactionTab> createState() => _WalletTransactionTabState();
}

class _WalletTransactionTabState extends State<WalletTransactionTab>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);

    _tabController?.addListener(() {
      switch (_tabController!.index) {
        case 0:
          Provider.of<AuthProvider>(context, listen: false)
              .setIndexForTabBar(1, isNotify: true);
          break;
        case 1:
          Provider.of<AuthProvider>(context, listen: false)
              .setIndexForTabBar(0, isNotify: true);
          break;
        // case 2:
        //   Provider.of<AuthProvider>(context, listen: false)
        //       .setIndexForTabBar(0, isNotify: true);
        //   break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: getTranslated('transactions', context), isAction: true),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).cardColor,
                child: TabBar(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge),
                  controller: _tabController,
                  isScrollable: true, // Add this line
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).hintColor,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 1,
                  unselectedLabelStyle: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w400,
                  ),
                  labelStyle: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w700,
                  ),
                  physics: const ScrollPhysics(),
                  tabs: const [
                    Tab(text: "Wallet"),
                    Tab(text: "WithDrawl"),
                    // Tab(text: "Earning Bonus"),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: Dimensions.paddingSizeSmall,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                AalletaddTransaction(),
                TransactionScreen(),
                // EarningbonusScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
