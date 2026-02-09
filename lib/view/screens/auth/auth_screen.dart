import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/screens/auth/login_screen.dart';

import '../../../utill/color_resources.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key, this.initialPage = 0}) : super(key: key);
  final int initialPage;

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).isActiveRememberMe;
    PageController pageController = PageController(initialPage: initialPage);

    return Scaffold(
      body: Consumer<AuthProvider>(builder: (context, auth, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 12,
                          bottom: 38),
                      child: Column(
                        children: [
                          Hero(
                              tag: 'logo',
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: Dimensions.paddingSizeExtraLarge),
                                child: Image.asset(Images.logoWhite, width: 80),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(getTranslated('seller', context)!,
                                  style: robotoMedium.copyWith(
                                      fontSize:
                                          Dimensions.fontSizeExtraLargeTwenty)),
                              const SizedBox(
                                  width: Dimensions.paddingSizeExtraSmall),
                              Text(getTranslated('app', context)!,
                                  style: robotoMedium.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize:
                                          Dimensions.fontSizeExtraLargeTwenty)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),*/
              _buildHeaderSection(context),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault, vertical: 5),
                child: Text(
                    getTranslated('manage_your_business_from_app', context)!,
                    style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).hintColor)),
              ),
              //const SizedBox(height: 50),
              /*Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Row(
                    children: [
                      InkWell(
                        onTap: () {
                          authProvider.updateSelectedIndex(0);
                          pageController.animateToPage(
                            0,
                            duration:
                            const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          'Login With OTP',
                          style: authProvider.selectedIndex == 0
                              ? titilliumSemiBold.copyWith(
                            color: ColorResources.primary,
                            decoration:
                            TextDecoration.underline,
                            fontSize: 16,
                          )
                              : titilliumRegular.copyWith(
                            fontSize: 16,
                            color: ColorResources.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: Dimensions.paddingSizeExtraLarge),
                      InkWell(
                        onTap: () {
                          authProvider.updateSelectedIndex(1);
                          pageController.animateToPage(
                            1,
                            duration:
                            const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          'Login With Email',
                          style: authProvider.selectedIndex == 1
                              ? titilliumSemiBold.copyWith(
                            color: ColorResources.primary,
                            decoration:
                            TextDecoration.underline,
                            fontSize: 16,
                          )
                              : titilliumRegular.copyWith(
                            fontSize: 16,
                            color: ColorResources.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
              SizedBox(
                height: 390, // IMPORTANT for PageView
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => PageView.builder(
                    controller: pageController,
                    itemCount: 1,
                    onPageChanged: (index) {
                      authProvider.updateSelectedIndex(index);
                    },
                    itemBuilder: (context, index) {
                      return index == 0
                          ? const SignInWidget() //const SigninWithMobile()
                          : const SignInWidget();
                    },
                  ),
                ),
              ),
              /*Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: Text(getTranslated('login', context)!,
                      style: titilliumBold.copyWith(
                          fontSize: Dimensions.fontSizeOverlarge))),*/

              //  const SizedBox(height: Dimensions.paddingSizeLarge),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Image.asset(
            "assets/image/logo_image.png",
            height: 180,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontSize: 22,
              color: ColorResources.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
