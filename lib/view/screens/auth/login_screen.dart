import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sixvalley_vendor_app/view/screens/auth/registration_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/forgetPassword/forget_password_screen.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../utill/app_constants.dart';
import '../../base/textfeild/lable_textfeild.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  SignInWidgetState createState() => SignInWidgetState();
}

class SignInWidgetState extends State<SignInWidget> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController? _mobileController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;
  bool otpSent = false;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _mobileController = TextEditingController();
    _passwordController = TextEditingController();

    _mobileController!.text =
        (Provider.of<AuthProvider>(context, listen: false).getUserEmail());
    _passwordController!.text =
        (Provider.of<AuthProvider>(context, listen: false).getUserPassword());
  }

  @override
  void dispose() {
    _mobileController!.dispose();
    _passwordController!.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  void _resendOtp() {
    // Your resend OTP logic here
    print("OTP Resent!");
    getOtpFromMobileNumber();
    _startTimer();
  }

  String _loginMethod = 'password';

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).isActiveRememberMe;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => Form(
        key: _formKeyLogin,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              /*RadioListTile<String>(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                title: const Text('Login with mobile number and password'),
                value: 'password',
                groupValue: _loginMethod,
                onChanged: (value) {
                  setState(() {
                    isOtpReceived = false;
                    _loginMethod = value!;
                  });
                },
              ),
              RadioListTile<String>(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                title: const Text('Login with OTP'),
                value: 'otp',
                groupValue: _loginMethod,
                onChanged: (value) {
                  setState(() {
                    _loginMethod = value!;
                  });
                },
              ),*/
              const SizedBox(
                height: 50,
              ),
              LabeledTextField(
                label: "Phone",
                hint: "Enter Phone",
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                inputFormatters: [],
              ),
              /*Container(
                  margin: const EdgeInsets.only(
                      left: Dimensions.paddingSizeLarge,
                      right: Dimensions.paddingSizeLarge,
                      bottom: Dimensions.paddingSizeSmall),
                  child: CustomTextField(
                    maxLength: 10,
                    border: true,
                    prefixIconImage: Images.callIcon,
                    hintText: 'Enter Mobile Number',
                    focusNode: _emailFocus,
                    nextNode: _passwordFocus,
                    textInputType: TextInputType.phone,
                    controller: _mobileController,
                  )),*/
              const SizedBox(height: Dimensions.paddingSizeSmall),

              _loginMethod != 'password'
                  ? otpLayout()
                  : LabeledTextField(
                      label: "Password",
                      hint: getTranslated('password_hint', context) ?? "",
                      controller: _passwordController,
                      inputFormatters: [],
                      textInputAction: TextInputAction.done,
                      obSecure: true,
                    ),

              /* Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.paddingSizeLarge,
                          right: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeDefault),
                      child: CustomTextField(
                        border: true,
                        isPassword: true,
                        prefixIconImage: Images.lock,
                        hintText: getTranslated('password_hint', context),
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.done,
                        controller: _passwordController,
                      ),
                    ),*/
              _loginMethod != 'password' && otpSent
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _canResend
                              ? "Didn't receive OTP?"
                              : "Resend OTP in $_secondsRemaining sec",
                          style: const TextStyle(fontSize: 12),
                        ),
                        InkWell(
                          onTap: _canResend ? _resendOtp : null,
                          child: const Text("Resend OTP"),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              _loginMethod != 'password'
                  ? const SizedBox(
                      height: 30,
                    )
                  : Container(),

              Container(
                margin: const EdgeInsets.only(
                    left: 24, top: 5, right: Dimensions.paddingSizeLarge),
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => InkWell(
                    onTap: () => authProvider.toggleRememberMe(),
                    child: Row(
                      children: [
                        Container(
                          width: Dimensions.iconSizeDefault,
                          height: Dimensions.iconSizeDefault,
                          decoration: BoxDecoration(
                              color: authProvider.isActiveRememberMe
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).cardColor,
                              border: Border.all(
                                  color: authProvider.isActiveRememberMe
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .hintColor
                                          .withOpacity(.5)),
                              borderRadius: BorderRadius.circular(3)),
                          child: authProvider.isActiveRememberMe
                              ? const Icon(Icons.done,
                                  color: ColorResources.white,
                                  size: Dimensions.iconSizeSmall)
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Text(
                          getTranslated('remember_me', context)!,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: ColorResources.getHintColor(context)),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgetPasswordScreen(),
                            ),
                          ),
                          child: Text(
                              getTranslated('forget_password', context)!,
                              style: robotoRegular.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeButton),

              !authProvider.isLoading
                  ? CommonCustomButton(
                      onPressed: () async {
                        String mobile = _mobileController!.text.trim();
                        String password = _passwordController!.text.trim();
                        if (mobile.isEmpty) {
                          showCustomSnackBar(
                              // getTranslated('enter_email_address', context),
                              'Enter Mobile Number',
                              context);
                        } else if (mobile.length != 10) {
                          showCustomSnackBar(
                              "Enter Valid Mobile Number", context);
                        }

                        // if (_loginMethod != 'password' &&
                        //     isOtpReceived != true) {
                        //   getOtpFromMobileNumber();
                        //   return;
                        // }

                        // if (_loginMethod != 'password') {
                        //   if (otp == null || otp!.length != 4) {
                        //     showCustomSnackBar(
                        //         "Please Enter valid OTP", context);
                        //   }
                        //   else {
                        //     authProvider
                        //         .login(context,
                        //         mobile: mobile,
                        //         password: password,
                        //         isOtpLogin: true,
                        //         otp: otp)
                        //         .then((status) async {
                        //       if (status.response!.statusCode == 200) {
                        //         if (authProvider.isActiveRememberMe) {
                        //           authProvider.saveUserNumberAndPassword(
                        //               mobile, password);
                        //         } else {
                        //           authProvider.clearUserEmailAndPassword();
                        //         }
                        //         Navigator.of(context).pushReplacement(
                        //             MaterialPageRoute(
                        //                 builder: (_) =>
                        //                 const DashboardScreen()));
                        //       }
                        //     }); /////
                        //   }
                        // } else {
                        if (password.isEmpty) {
                          showCustomSnackBar(
                              getTranslated('enter_password', context),
                              context);
                        } else if (password.length < 6) {
                          showCustomSnackBar(
                              getTranslated('password_should_be', context),
                              context);
                        } else {
                          authProvider
                              .login(context,
                                  mobile: mobile,
                                  password: password,
                                  isOtpLogin: false,
                                  otp: otp)
                              .then((status) async {
                            if (status.response!.statusCode == 200) {
                              if (authProvider.isActiveRememberMe) {
                                authProvider.saveUserNumberAndPassword(
                                    mobile, password);
                              } else {
                                authProvider.clearUserEmailAndPassword();
                              }
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const DashboardScreen()));
                            }
                          });
                        }
                        // }
                      },
                      text: _loginMethod == 'password' || isOtpReceived == true
                          ? getTranslated('login', context)!
                          : 'Send OTP',
                    )
                  : Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    )),

              // Provider.of<SplashProvider>(context, listen: false).configModel!.sellerRegistration == "1"?
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeDefault),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const RegistrationScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getTranslated('dont_have_an_account', context)!,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Text('SignUp',
                          style: robotoTitleRegular.copyWith(
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline)),
                    ],
                  ),
                ),
              ),
              // : const SizedBox(),

              /* Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeBottomSpace),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => HtmlViewScreen(
                                    title: getTranslated(
                                        'terms_and_condition', context),
                                    url: Provider.of<SplashProvider>(context,
                                            listen: false)
                                        .configModel!
                                        .termsConditions,
                                  )));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(getTranslated('terms_and_condition', context)!,
                            style: robotoMedium.copyWith(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline)),
                      ],
                    )),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  String? otp;
  bool isOtpReceived = false;

  Widget otpLayout() {
    if (isOtpReceived != true) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 50.0,
        end: 50.0,
      ),
      child: Center(
        child: PinFieldAutoFill(
            decoration: UnderlineDecoration(
              textStyle: const TextStyle(fontSize: 20, color: Colors.black),
              colorBuilder: const FixedColorBuilder(Colors.blue),
            ),
            currentCode: otp,
            codeLength: 4,
            onCodeChanged: (String? code) {
              otp = code;
            },
            onCodeSubmitted: (String code) {
              otp = code;
            }),
      ),
    );
  }

  Future<void> getOtpFromMobileNumber() async {
    try {
      var data = {"phone": _mobileController!.text};
      Response response = await post(
        Uri.parse("${AppConstants.baseUrl}/api/v3/seller/auth/send-otp"),
        body: data,
      ).timeout(
        const Duration(seconds: 10),
      );

      print("jahsgahgs ${data.toString()}");
      var getdata = json.decode(response.body);
      bool? error = getdata["error"];
      String? msg = getdata["message"];

      //print(getdata);

      // if(widget.checkForgot == "false"){

      if (msg!.contains('Successfully')) {
        String otp = getdata['otp'].toString();
        // setSnackbar(otp.toString());
        // Fluttertoast.showToast(msg: otp.toString(),
        //     backgroundColor: colors.primary
        // );
        //print("OTP : $otp");
        setState(() {
          isOtpReceived = true;
          _startTimer();
          otpSent = true;
        });
        showCustomSnackBar(msg, context);
        // settingsProvider.setPrefrence(MOBILE, mobile!);
        // settingsProvider.setPrefrence(COUNTRY_CODE, countrycode!);
      } else {
        showCustomSnackBar(msg, context);
      }
    } on TimeoutException catch (_) {
      showCustomSnackBar("Something went wrong", context);
    }
  }
}
