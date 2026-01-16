import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/price_converter.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../utill/app_constants.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../base/custom_app_bar.dart';
//
// import '../../../helper/price_converter.dart';
// import '../../../localization/language_constrants.dart';
// import '../../../provider/auth_provider.dart';
// import '../../../provider/plan_provider.dart';
// import '../../../provider/theme_provider.dart';
// import '../../../provider/wallet_transaction_provider.dart';
// import '../../../utill/dimensions.dart';
// import '../../../utill/images.dart';
// import '../../basewidget/custom_app_bar.dart';
// import '../dashboard/dashboard_screen.dart';

class FundScreen extends StatefulWidget {
  final type;
  final id;
  final amount;
  FundScreen({Key? key, this.type, this.amount, this.id}) : super(key: key);
  // ContinueToPayScreen();

  @override
  State<FundScreen> createState() => _FundScreenState();
}

class _FundScreenState extends State<FundScreen> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final _transactionIdController = TextEditingController();
  final _amountController = TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }
  //
  // route(
  //   bool isRoute,
  //   String? token,
  //   String? tempToken,
  //   String? errorMessage,
  // ) async {
  //   Fluttertoast.showToast(msg: "Plan Buy Successfully");
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (_) => const DashBoardScreen()),
  //       (route) => false);
  // }
  //
  // Future<void> purchasePlan(
  //     userid, planId, transactionId, amount, remark) async {
  //   // await Provider.of<AuthProvider>(context, listen: false).registration(register, route);
  //   await Provider.of<PlanProvider>(context, listen: false).purchasePlan(
  //       userid, planId, transactionId, amount, remark, widget.type, route);
  // }

  @override
  Widget build(BuildContext context) {
    // bool darkMode =
    //     Provider.of<ThemeProvider>(context, listen: false).darkTheme;
    // Provider.of<WalletTransactionProvider>(context, listen: false)
    //     .getTransactionList(context, 1);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: CustomAppBar(
            title: 'Add Wallet Balance' /*getTranslated('plans', context)*/,
            isBackButtonExist: true,
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Consumer<WalletTransactionProvider>(
                //     builder: (context, profile, _) {
                //       return Column(
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Container(
                //                 height: MediaQuery.of(context).size.width / 2.85,
                //                 width: MediaQuery.of(context).size.width / 2.28,
                //                 padding: const EdgeInsets.symmetric(
                //                     horizontal: Dimensions.paddingSizeSmall),
                //                 margin: const EdgeInsets.symmetric(
                //                     horizontal: Dimensions.paddingSizeSmall),
                //                 decoration: BoxDecoration(
                //                   color: Theme.of(context).primaryColor,
                //                   borderRadius: BorderRadius.circular(
                //                       Dimensions.paddingSizeSmall),
                //                   boxShadow: [
                //                     BoxShadow(
                //                         color: Colors.grey,
                //                         spreadRadius: 0.5,
                //                         blurRadius: 0.3)
                //                   ],
                //                 ),
                //                 child: Center(
                //                   child: Row(
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: [
                //                       const SizedBox(
                //                         height: 10,
                //                       ),
                //                       Column(
                //                         mainAxisAlignment: MainAxisAlignment.center,
                //                         crossAxisAlignment:
                //                         CrossAxisAlignment.center,
                //                         children: [
                //                           SizedBox(
                //                               width: Dimensions.iconSizeDefault,
                //                               height: Dimensions.iconSizeDefault,
                //                               child: Image.asset(Images.wallet)),
                //                           const SizedBox(
                //                             height: 10,
                //                           ),
                //                           Text("Fund Wallet",
                //                               style: const TextStyle(
                //                                   fontWeight: FontWeight.w400,
                //                                   color: Colors.white,
                //                                   fontSize:
                //                                   Dimensions.fontSizeSmall)),
                //                           const SizedBox(
                //                             height: Dimensions.paddingSizeSmall,
                //                           ),
                //                           Text(
                //                               PriceConverter.convertPrice(
                //                                   context,
                //                                   (profile.walletBalance!
                //                                       .total_fund_wallet !=
                //                                       null &&
                //                                       profile.walletBalance!
                //                                           .total_fund_wallet !=
                //                                           null)
                //                                       ? profile.walletBalance!
                //                                       .total_fund_wallet ??
                //                                       0
                //                                       : 0),
                //                               style: const TextStyle(
                //                                   fontWeight: FontWeight.w700,
                //                                   color: Colors.white,
                //                                   fontSize:
                //                                   Dimensions.fontSizeDefault)),
                //                         ],
                //                       ),
                //                       const SizedBox(
                //                         width: Dimensions.iconSizeDefault,
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //               SizedBox(
                //                 height: Dimensions.paddingSizeSmall,
                //               ),
                //             ],
                //           ),
                //           SizedBox(
                //             height: 20,
                //           ),
                //           ElevatedButton(
                //             onPressed: () {
                //               int _randomNumber = 0;
                //
                //               final random = Random();
                //               setState(() {
                //                 _randomNumber = random.nextInt(
                //                     100); // Generates a random number between 0 and 99
                //               });
                //               if (double.parse(widget.amount.toString()) <=
                //                   double.parse(profile
                //                       .walletBalance!.total_fund_wallet
                //                       .toString())) {
                //                 Provider.of<PlanProvider>(context, listen: false)
                //                     .isPlanList();
                //                 purchasePlan(
                //                     Provider.of<AuthProvider>(context,
                //                         listen: false)
                //                         .getAuthID(),
                //                     widget.id,
                //                     _randomNumber.toString(),
                //                     widget.amount,
                //                     "success");
                //               } else {
                //                 Fluttertoast.showToast(
                //                     msg:
                //                     'Please Add Amount In Wallet By Scan Qr Code And Upload screeenshot of payment and enter amount and transaction id');
                //               }
                //               // if (_formKey.currentState!.validate()) {
                //               //   // Process the data
                //               //   print('Transaction ID: ${_transactionIdController.text}');
                //               //   if (_image == null) {
                //               //     Fluttertoast.showToast(
                //               //         msg: 'Upload Screen short of transaction');
                //               //     print('Image path: ${_image!.path}');
                //               //   } else {
                //               //
                //               //   }
                //               // }
                //             },
                //             child: Text('Purchase plan'),
                //           ),
                //         ],
                //       );
                //     }),
                SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),
                Image.asset('assets/image/qr.jpeg'),
                SizedBox(height: 16.0),
                Text(
                  'Upload screeenshot of payment , enter amount and transaction id',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: _pickImage,
                  child: _image == null
                      ? Container(
                          height: 150,
                          width: 150,
                          color: Colors.grey[300],
                          child:
                              Icon(Icons.camera_alt, color: Colors.grey[700]),
                        )
                      : Image.file(
                          _image!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _transactionIdController,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Transaction ID',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a transaction ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Enter Amount',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process the data
                      print('Transaction ID: ${_transactionIdController.text}');
                      if (_image == null) {
                        Fluttertoast.showToast(
                            msg: 'Upload Screen short of transaction');
                        print('Image path: ${_image!.path}');
                      } else {
                        _uploadQrImage();
                      }
                    }
                  },
                  child: Text('Add Money'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = false;

  Future<void> _uploadQrImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.token);

    if (token == null) {
      Fluttertoast.showToast(msg: "Token not found!");
      return;
    }

    isLoading = true;
    setState(() {});

    if (_image == null) return;

    final uri = Uri.parse(
        '${AppConstants.baseUrl}/api/v3/seller/request_money');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    request.fields['amount'] = _amountController.text;
    request.fields['transaction_id'] = _transactionIdController.text;

    // Adding the token to the headers
    request.headers['Authorization'] = 'Bearer $token';

    // Send the request
    final response = await request.send();
    print("Request Fields: ${request.fields}");
    print("Request URL: ${request.url}");
    print("Request URL: ${token}");

    final responseData = await http.Response.fromStream(response);
    var responseMap = json.decode(responseData.body);
    print('Response: $responseMap');

    isLoading = false;
    setState(() {});

    Fluttertoast.showToast(msg: responseMap['message']);

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      if (responseMap['status'] == true) {
        Navigator.pop(context);
      }
    } else {
      print('Image upload failed');
    }
  }
}
