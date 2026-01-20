import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/helper/network_info.dart';
import 'package:sixvalley_vendor_app/helper/notification_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/manage_Service.dart';
import 'package:sixvalley_vendor_app/view/screens/home/home_page_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/menu/menu_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/order/order_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/refund/refund_screen.dart';

import '../../base/custom_button.dart';
import '../Subcriptionplans/subscription_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).getSellerInfo();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   checkPlanAndShowDialog();
    // });
    _screens = [
      HomePageScreen(callback: () {
        setState(() {
          _setPage(1);
        });
      }),
      const OrderScreen(),
      const ManageServicesScreen()
     //const RefundScreen(),
    ];

    NetworkInfo.checkConnectivity(context);

    var androidInitialize =
        const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin!.initialize(initializationsSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("onMessage: ${message.data}");
      NotificationHelper.showNotification(
          message, flutterLocalNotificationsPlugin, false);
      /*Provider.of<OrderProvider>(context, listen: false)
          .getOrderList(context, 1, 'all');*/
      Provider.of<OrderProvider>(context, listen: false)
          .getBookingList(context, 1, 'all','','');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("onMessageOpenedApp: ${message.data}");
    });
  }

  void checkPlanAndShowDialog() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.getSellerInfo();
    final sellerInfo = profileProvider.userInfoModel;
    if (sellerInfo != null) {
      int planStatus = sellerInfo.planStatus ?? 0;
      String endDateString = sellerInfo.endDate ?? '';

      DateTime today = DateTime.now();
      DateTime? endDate;

      try {
        endDate = DateTime.parse(endDateString);
      } catch (e) {
        endDate = null;
      }

      bool shouldShowDialog = false;

      if (planStatus == 0) {
        shouldShowDialog = true;
      } else if (planStatus == 1 &&
          endDate != null &&
          endDate.year == today.year &&
          endDate.month == today.month &&
          endDate.day == today.day) {
        shouldShowDialog = true;
      }

      if (shouldShowDialog) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => _buildCustomDialog(context),
        );
      }
    }
  }

  Widget _buildCustomDialog(BuildContext context) {
    return Dialog(
      backgroundColor: ColorResources.getBottomSheetColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Plan Expired",
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Dimensions.paddingSizeLarge,
                      13,
                      Dimensions.paddingSizeLarge,
                      0,
                    ),
                    child: Text(
                      "Please purchase a plan to continue using the service.",
                      style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        Dimensions.paddingSizeDefault,
                        24,
                        Dimensions.paddingSizeDefault,
                        Dimensions.paddingSizeDefault,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              borderRadius: 15,
                              btnTxt: 'Buy Plan',
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              fontColor: Colors.white,
                              isColor: true,
                              onTap: () {
                                // Add your logout logic or action here
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SubscriptionScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(
                            child: CustomButton(
                              borderRadius: 15,
                              btnTxt: getTranslated('no', context),
                              isColor: true,
                              fontColor: ColorResources.getTextColor(context),
                              backgroundColor:
                                  Theme.of(context).hintColor.withOpacity(.25),
                              onTap: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).highlightColor,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: ColorResources.colorLightBlack,
          selectedFontSize: Dimensions.fontSizeSmall,
          unselectedFontSize: Dimensions.fontSizeSmall,
          selectedLabelStyle: robotoBold,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            _barItem(Images.home, getTranslated('home', context), 0),
            _barItem(Images.order, getTranslated('my_order', context), 1),
            _barItem(Images.settings, /*getTranslated('refund', context)*/'Service', 2),
            _barItem(Images.menu, getTranslated('menu', context), 3)
          ],
          onTap: (int index) {
            if (index != 3) {
              setState(() {
                _setPage(index);
              });
            } else {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (con) => const MenuBottomSheet(),
              );
            }
          },
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(String icon, String? label, int index) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding:
            const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
                width: index == _pageIndex
                    ? Dimensions.iconSizeLarge
                    : Dimensions.iconSizeMedium,
                child: Image.asset(
                  icon,
                  color: index == _pageIndex
                      ? Theme.of(context).primaryColor
                      : ColorResources.colorLightBlack,
                )),
          ],
        ),
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;

      if (_pageIndex == 0) {
        //SchedulerBinding.instance.addPostFrameCallback((_) => checkPlanAndShowDialog());
      }
    });
  }
}
