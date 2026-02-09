import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/view/base/custom_bottom_sheet.dart';
import 'package:sixvalley_vendor_app/view/screens/Subcriptionplans/app_token_data.dart';
import 'package:sixvalley_vendor_app/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:sixvalley_vendor_app/view/screens/more/html_view_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/profile/profile_view_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/review/product_review_screen.dart';

import '../../base/custom_dialog.dart';
import '../Service/manage_Service.dart';
import '../Subcriptionplans/purchasepllan_history.dart';
import '../Subcriptionplans/subscription_screen.dart';

class MenuBottomSheet extends StatefulWidget {
  const MenuBottomSheet({Key? key}) : super(key: key);

  @override
  State<MenuBottomSheet> createState() => _MenuBottomSheetState();
}

class _MenuBottomSheetState extends State<MenuBottomSheet> {
  String userType = '';
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MyToken.getUserType(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userType = snapshot.data.toString();
            print("asdads ${userType}");
            List<CustomBottomSheet> activateMenu = userType == 'goods'
                ? [
                    CustomBottomSheet(
                      image: Provider.of<ProfileProvider>(context,
                                      listen: false)
                                  .userInfoModel ==
                              null
                          ? "https://placehold.co/600x400"
                          : '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.sellerImageUrl}/'
                              '${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.image}',
                      isProfile: true,
                      title: getTranslated('profile', context),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreenView(),
                        ),
                      ),
                    ),

                    // CustomBottomSheet(
                    //   image: Images.myShop,
                    //   title: getTranslated('my_shop', context),
                    //   onTap: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => const ShopScreen(),
                    //     ),
                    //   ),
                    // ),

                    CustomBottomSheet(
                      image: Images.addProduct,
                      title: getTranslated('Manage_Services', context),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManageServicesScreen(),
                        ),
                      ),
                    ),

                    CustomBottomSheet(
                      image: Images.reviewIcon,
                      title: getTranslated('reviews', context),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductReview(),
                        ),
                      ),
                    ),
                    //
                    // CustomBottomSheet(
                    //   image: Images.wallet,
                    //   title: getTranslated('wallet', context),
                    //   onTap: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => const WalletScreen(),
                    //     ),
                    //   ),
                    // ),

                    /*CustomBottomSheet(
                          image: Images.flash,
                          title: "Flash Deals",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FlashDeals(),
                            ),
                          ),
                        ),

                        CustomBottomSheet(
                          image: Images.message,
                          title: getTranslated('message', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InboxScreen(),
                            ),
                          ),
                        ),*/

                    CustomBottomSheet(
                      image: Images.termsAndCondition,
                      title: getTranslated('terms_and_condition', context),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HtmlViewScreen(
                              title:
                                  getTranslated('terms_and_condition', context),
                              url: Provider.of<SplashProvider>(context,
                                      listen: false)
                                  .configModel!
                                  .termsConditions),
                        ),
                      ),
                    ),

                    CustomBottomSheet(
                      image: Images.aboutUs,
                      title: getTranslated('about_us', context),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HtmlViewScreen(
                            title: getTranslated('about_us', context),
                            url: Provider.of<SplashProvider>(context,
                                    listen: false)
                                .configModel!
                                .aboutUs,
                          ),
                        ),
                      ),
                    ),
                    CustomBottomSheet(
                      image: Images.bankCard,
                      title: getTranslated('Subscription_Plans', context),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SubscriptionScreen(),
                          ),
                        );
                      },
                    ),
                    CustomBottomSheet(
                      image: Images.bankCard,
                      title: getTranslated('Plan_History', context),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const PlanHistoryPage()));
                      },
                    ),
                    CustomBottomSheet(
                      image: Images.logOut,
                      title: getTranslated('logout', context),
                      onTap: () => showCupertinoModalPopup(
                        context: context,
                        builder: (_) => const SignOutConfirmationDialog(),
                      ),
                    ),
                    CustomBottomSheet(
                      image: Images.delete,
                      title: getTranslated('delete_account', context),
                      onTap: () => showAnimatedDialog(context,
                          const SignOutConfirmationDialog(isDelete: true),
                          isFlip: true),
                    ),

                    // CustomBottomSheet(image: Images.appInfo, title: 'v - ${AppConstants.appVersion}',
                    //     onTap: (){}),
                  ]
                : userType == 'service'
                    ? [
                        CustomBottomSheet(
                          image: Provider.of<ProfileProvider>(context,
                                          listen: false)
                                      .userInfoModel ==
                                  null
                              ? "https://placehold.co/600x400"
                              : '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.sellerImageUrl}/'
                                  '${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.image}',
                          isProfile: true,
                          title: getTranslated('profile', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreenView(),
                            ),
                          ),
                        ),

                        // CustomBottomSheet(
                        //   image: Images.myShop,
                        //   title: getTranslated('my_shop', context),
                        //   onTap: () => Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) => const ShopScreen(),
                        //     ),
                        //   ),
                        // ),

                        CustomBottomSheet(
                          image: Images.addProduct,
                          title: getTranslated('Manage_Services', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ManageServicesScreen(),
                            ),
                          ),
                        ),

                        CustomBottomSheet(
                          image: Images.reviewIcon,
                          title: getTranslated('reviews', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProductReview(),
                            ),
                          ),
                        ),
                        //
                        // CustomBottomSheet(
                        //   image: Images.wallet,
                        //   title: getTranslated('wallet', context),
                        //   onTap: () => Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) => const WalletScreen(),
                        //     ),
                        //   ),
                        // ),

                        /*CustomBottomSheet(
                          image: Images.flash,
                          title: "Flash Deals",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FlashDeals(),
                            ),
                          ),
                        ),

                        CustomBottomSheet(
                          image: Images.message,
                          title: getTranslated('message', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InboxScreen(),
                            ),
                          ),
                        ),*/

                        CustomBottomSheet(
                          image: Images.termsAndCondition,
                          title: getTranslated('terms_and_condition', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HtmlViewScreen(
                                  title: getTranslated(
                                      'terms_and_condition', context),
                                  url: Provider.of<SplashProvider>(context,
                                          listen: false)
                                      .configModel!
                                      .termsConditions),
                            ),
                          ),
                        ),

                        CustomBottomSheet(
                          image: Images.aboutUs,
                          title: getTranslated('about_us', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HtmlViewScreen(
                                title: getTranslated('about_us', context),
                                url: Provider.of<SplashProvider>(context,
                                        listen: false)
                                    .configModel!
                                    .aboutUs,
                              ),
                            ),
                          ),
                        ),
                        CustomBottomSheet(
                          image: Images.bankCard,
                          title: getTranslated('Subscription_Plans', context),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SubscriptionScreen(),
                              ),
                            );
                          },
                        ),
                        CustomBottomSheet(
                          image: Images.bankCard,
                          title: getTranslated('Plan_History', context),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const PlanHistoryPage()));
                          },
                        ),
                        CustomBottomSheet(
                          image: Images.logOut,
                          title: getTranslated('logout', context),
                          onTap: () => showCupertinoModalPopup(
                            context: context,
                            builder: (_) => const SignOutConfirmationDialog(),
                          ),
                        ),
                        CustomBottomSheet(
                          image: Images.delete,
                          title: getTranslated('delete_account', context),
                          onTap: () => showAnimatedDialog(context,
                              const SignOutConfirmationDialog(isDelete: true),
                              isFlip: true),
                        ),

                        // CustomBottomSheet(image: Images.appInfo, title: 'v - ${AppConstants.appVersion}',
                        //     onTap: (){}),
                      ]
                    : [
                        CustomBottomSheet(
                          image: Provider.of<ProfileProvider>(context,
                                          listen: false)
                                      .userInfoModel ==
                                  null
                              ? "https://placehold.co/600x400"
                              : '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.sellerImageUrl}/'
                                  '${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.image}',
                          isProfile: true,
                          title: getTranslated('profile', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreenView(),
                            ),
                          ),
                        ),

                        // CustomBottomSheet(
                        //   image: Images.myShop,
                        //   title: getTranslated('my_shop', context),
                        //   onTap: () => Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) => const ShopScreen(),
                        //     ),
                        //   ),
                        // ),

                        CustomBottomSheet(
                          image: Images.addProduct,
                          title: getTranslated('Manage_Services', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ManageServicesScreen(),
                            ),
                          ),
                        ),

                        CustomBottomSheet(
                          image: Images.reviewIcon,
                          title: getTranslated('reviews', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProductReview(),
                            ),
                          ),
                        ),
                        //
                        // CustomBottomSheet(
                        //   image: Images.wallet,
                        //   title: getTranslated('wallet', context),
                        //   onTap: () => Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) => const WalletScreen(),
                        //     ),
                        //   ),
                        // ),

                        /*CustomBottomSheet(
                          image: Images.flash,
                          title: "Flash Deals",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FlashDeals(),
                            ),
                          ),
                        ),

                        CustomBottomSheet(
                          image: Images.message,
                          title: getTranslated('message', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InboxScreen(),
                            ),
                          ),
                        ),*/

                        CustomBottomSheet(
                          image: Images.termsAndCondition,
                          title: getTranslated('terms_and_condition', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HtmlViewScreen(
                                  title: getTranslated(
                                      'terms_and_condition', context),
                                  url: Provider.of<SplashProvider>(context,
                                          listen: false)
                                      .configModel!
                                      .termsConditions),
                            ),
                          ),
                        ),

                        CustomBottomSheet(
                          image: Images.aboutUs,
                          title: getTranslated('about_us', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HtmlViewScreen(
                                title: getTranslated('about_us', context),
                                url: Provider.of<SplashProvider>(context,
                                        listen: false)
                                    .configModel!
                                    .aboutUs,
                              ),
                            ),
                          ),
                        ),
                        CustomBottomSheet(
                          image: Images.bankCard,
                          title: getTranslated('Subscription_Plans', context),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SubscriptionScreen(),
                              ),
                            );
                          },
                        ),
                        CustomBottomSheet(
                          image: Images.bankCard,
                          title: getTranslated('Plan_History', context),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const PlanHistoryPage()));
                          },
                        ),
                        CustomBottomSheet(
                          image: Images.logOut,
                          title: getTranslated('logout', context),
                          onTap: () => showCupertinoModalPopup(
                            context: context,
                            builder: (_) => const SignOutConfirmationDialog(),
                          ),
                        ),
                        CustomBottomSheet(
                          image: Images.delete,
                          title: getTranslated('delete_account', context),
                          onTap: () => showAnimatedDialog(context,
                              const SignOutConfirmationDialog(isDelete: true),
                              isFlip: true),
                        ),

                        // CustomBottomSheet(image: Images.appInfo, title: 'v - ${AppConstants.appVersion}',
                        //     onTap: (){}),
                      ];
            return Container(
              decoration: BoxDecoration(
                color: ColorResources.getHomeBg(context),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Theme.of(context).hintColor,
                      size: Dimensions.iconSizeLarge,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeVeryTiny),
                  Consumer<ProfileProvider>(
                      builder: (context, profileProvider, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeDefault),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: activateMenu,
                      ),
                    );
                  }),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
