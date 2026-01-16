import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../../../../data/model/body/login_model.dart';
import '../../../../localization/language_constrants.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/styles.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_snackbar.dart';
import '../../../base/textfeild/lable_textfeild.dart';
import '../registration_screen.dart';

class SigninWithMobile extends StatefulWidget {
  const SigninWithMobile({Key? key}) : super(key: key);

  @override
  SigninWithMobileState createState() => SigninWithMobileState();
}

class SigninWithMobileState extends State<SigninWithMobile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  LoginModel loginEmailBody = LoginModel();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passNode = FocusNode();
  bool _obscurePassword = true;

  GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserEmail();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).isActiveRememberMe;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKeyLogin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 50),
              LabeledTextField(
                label: "Phone",
                hint: "Enter Phone Number",
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                inputFormatters: [],
              ),

              const SizedBox(height: 40),

              Container(
                child: Provider.of<AuthProvider>(context).isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CommonCustomButton(
                  onPressed: () async {
                    // String mobile = _mobileController!.text.trim();
                    // String password = _passwordController!.text.trim();
                    // if (mobile.isEmpty) {
                    //   showCustomSnackBar(
                    //     // getTranslated('enter_email_address', context),
                    //       'Enter Mobile Number',
                    //       context);
                    // } else if (mobile.length != 10) {
                    //   showCustomSnackBar(
                    //       "Enter Valid Mobile Number", context);
                    // }
                    //
                    // if (_loginMethod != 'password' &&
                    //     isOtpReceived != true) {
                    //   getOtpFromMobileNumber();
                    //   return;
                    // }
                    //
                    // if (_loginMethod != 'password') {
                    //   if (otp == null || otp!.length != 4) {
                    //     showCustomSnackBar(
                    //         "Please Enter valid OTP", context);
                    //   } else {
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
                    // }
                  },
                  text:  'Send OTP',),
              ),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
