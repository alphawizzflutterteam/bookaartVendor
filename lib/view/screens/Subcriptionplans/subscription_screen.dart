import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sixvalley_vendor_app/data/model/response/subscrption_model.dart';
import 'package:sixvalley_vendor_app/view/screens/Subcriptionplans/purchase_plan_model.dart';
import 'package:sixvalley_vendor_app/view/screens/Subcriptionplans/utility_hlepar.dart';

import '../../../localization/language_constrants.dart';
import '../../../utill/app_constants.dart';
import '../../base/custom_app_bar.dart';
import 'app_token_data.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  Razorpay _razorpay = Razorpay();
  String? email;
  String? userId;
  String? phone;
  int? price;
  var amounts;
  var planT;
  var planI;

  String planID = '';
  String planeAmount = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserDetails();
    //UNCOMMENT
    Future.delayed(Duration(milliseconds: 200), () {
      return getPlans();
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    return Scaffold(
        appBar: CustomAppBar(
          title: getTranslated('Subscription', context),
          isBackButtonExist: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.040, vertical: height * 0.014),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             /* SizedBox(height: height * 0.025),
              Center(
                  child: Image.asset("assets/image/subscription.png",
                      height: height * 0.25)),
              SizedBox(height: height * 0.025),
              const Text(
                "Subscription Plans",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: height * 0.025),*/
              plansModel == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : plansModel!.data == null
                      ? const Center(child: Text("No Data Found"))
                      : Expanded(
                        child: ListView.builder(
                                             itemCount: plansModel?.data?.length ?? 0,
                                            itemBuilder: (context, index) {
                                           SubscriptionList plan = plansModel!.data![index];
                            bool isPopular = index == 0;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildPlanCard(plan, isPopular),
                          );
                        },),
                      )

              /*SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: CarouselSlider(
                            options: CarouselOptions(
                              autoPlayInterval: const Duration(seconds: 4),
                              autoPlay: true,
                              aspectRatio: .5,
                              enlargeCenterPage: true,
                              // enlargeStrategy: CenterPageEnlargeStrategy.height,
                            ),
                            items: plansModel!.data!
                                .map<Widget>((item) => Container(
                                      margin: const EdgeInsets.all(5.0),
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5.0)),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Card(
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                              height: height *
                                                                  0.0125),
                                                          item.amount == 0
                                                              ? const SizedBox
                                                                  .shrink()
                                                              : const Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Special Offer",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                          const SizedBox(
                                                              height: 20),
                                                          Text(
                                                            item.title ?? "",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 20),
                                                          Text(
                                                            "₹ ${item.amount.toString()}",
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 30,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 20),
                                                          Text(
                                                            "${item.days} Days",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Html(
                                                            data:
                                                                item.description ??
                                                                    "",
                                                            style: {
                                                              "body": Style(
                                                                  fontSize:
                                                                      FontSize
                                                                          .small),
                                                            },
                                                          ),
                                                          const Divider(
                                                              color:
                                                                  Colors.blue),
                                                          const SizedBox(
                                                              height: 10),
                                                          const Row(
                                                            children: [
                                                              SizedBox(
                                                                  width: 5),
                                                              Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  color: Color(
                                                                      0xff0007a3),
                                                                  size: 20),
                                                              SizedBox(
                                                                  width: 6),
                                                              Expanded(
                                                                child: Text(
                                                                  "Lifetime Service Support",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          const Row(
                                                            children: [
                                                              SizedBox(
                                                                  width: 5),
                                                              Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  color: Color(
                                                                      0xff0007a3),
                                                                  size: 18),
                                                              SizedBox(
                                                                  width: 6),
                                                              Expanded(
                                                                child: Text(
                                                                  "User Priority Support",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          const Row(
                                                            children: [
                                                              SizedBox(
                                                                  width: 5),
                                                              Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  color: Color(
                                                                      0xff0007a3),
                                                                  size: 18),
                                                              SizedBox(
                                                                  width: 6),
                                                              Expanded(
                                                                child: Text(
                                                                  "Basic Plan",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 20),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Expanded(
                                              //   child: Card(
                                              //     elevation: 5,
                                              //     shape: RoundedRectangleBorder(
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               20.0),
                                              //     ),
                                              //     child: Column(
                                              //       children: [
                                              //         SizedBox(
                                              //             height:
                                              //                 height * 0.0125),
                                              //         item.amount == 0
                                              //             ? const SizedBox
                                              //                 .shrink()
                                              //             : Align(
                                              //                 alignment:
                                              //                     Alignment
                                              //                         .topRight,
                                              //               ),
                                              //         const SizedBox(
                                              //           height: 20,
                                              //         ),
                                              //         Text(
                                              //           "${item.title}",
                                              //           style: const TextStyle(
                                              //               fontSize: 18,
                                              //               fontWeight:
                                              //                   FontWeight
                                              //                       .bold),
                                              //         ),
                                              //         const SizedBox(
                                              //           height: 20,
                                              //         ),
                                              //         Text(
                                              //           "₹ ${item.amount.toString()}",
                                              //           style: TextStyle(
                                              //               fontWeight:
                                              //                   FontWeight.bold,
                                              //               fontSize: 30,
                                              //               color: Colors.blue),
                                              //         ),
                                              //         const SizedBox(
                                              //           height: 20,
                                              //         ),
                                              //         Text(
                                              //           "${item.days} Days",
                                              //           style: const TextStyle(
                                              //               fontWeight:
                                              //                   FontWeight
                                              //                       .w600),
                                              //         ),
                                              //         Html(
                                              //           data:
                                              //               item.description ??
                                              //                   "",
                                              //           style: {
                                              //             "body": Style(
                                              //               fontSize:
                                              //                   FontSize.small,
                                              //             ),
                                              //           },
                                              //         ),
                                              //         const Divider(
                                              //           color: Colors.blue,
                                              //         ),
                                              //         SizedBox(
                                              //           height: 10,
                                              //         ),
                                              //         const Row(
                                              //           children: [
                                              //             SizedBox(
                                              //               width: 5,
                                              //             ),
                                              //             Icon(
                                              //               Icons.check_circle,
                                              //               color: Color(
                                              //                   0xff0007a3),
                                              //               size: 20,
                                              //             ),
                                              //             SizedBox(width: 6),
                                              //             Expanded(
                                              //               child: Text(
                                              //                 "Lifetime Survice Support",
                                              //                 style: TextStyle(
                                              //                   color: Colors
                                              //                       .black,
                                              //                   fontSize: 16,
                                              //                 ),
                                              //               ),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //         const SizedBox(
                                              //             height: 10),
                                              //         Row(
                                              //           children: [
                                              //             SizedBox(
                                              //               width: 5,
                                              //             ),
                                              //             const Icon(
                                              //               Icons.check_circle,
                                              //               color: Color(
                                              //                   0xff0007a3),
                                              //               size: 18,
                                              //             ),
                                              //             const SizedBox(
                                              //                 width: 6),
                                              //             Expanded(
                                              //               child: Text(
                                              //                 "User Priority Support",
                                              //                 style:
                                              //                     const TextStyle(
                                              //                   color: Colors
                                              //                       .black,
                                              //                   fontSize: 16,
                                              //                 ),
                                              //               ),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //         const SizedBox(
                                              //             height: 10),
                                              //         Row(
                                              //           children: [
                                              //             SizedBox(
                                              //               width: 5,
                                              //             ),
                                              //             const Icon(
                                              //               Icons.check_circle,
                                              //               color: Color(
                                              //                   0xff0007a3),
                                              //               size: 18,
                                              //             ),
                                              //             const SizedBox(
                                              //                 width: 6),
                                              //             Expanded(
                                              //               child: Text(
                                              //                 "Basic Plan",
                                              //                 style:
                                              //                     const TextStyle(
                                              //                   color: Colors
                                              //                       .black,
                                              //                   fontSize: 16,
                                              //                 ),
                                              //               ),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //         const SizedBox(
                                              //             height: 20),
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),
                                              (item.amount == 0 ||
                                                      item.amount == "0")
                                                  ? Container()
                                                  : ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .blue)),
                                                      onPressed: () async {
                                                        var userId =
                                                            await MyToken
                                                                .getUserID();
                                                        planI =
                                                            item.id.toString();
                                                        if (item.amount == 0 ||
                                                            item.amount ==
                                                                "0") {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Plan amount is not valid");
                                                        } else {
                                                          planID = item.id
                                                              .toString();
                                                          planeAmount = item
                                                              .amount
                                                              .toString();
                                                          checkOut(item.amount);
                                                        }
                                                      },
                                                      child: const Text(
                                                        "Buy Plan",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))
                                            ],
                                          )),
                                    ))
                                .toList(),
                          ),
                        ),*/
            ],
          ),
        ));
  }







  SubscriptionModel? plansModel;

  getPlans() async {
    var request = http.Request('GET',
        Uri.parse('${AppConstants.baseUrl}/api/v1/auth/get_plans'));
    http.StreamedResponse response = await request.send();
    print("sfsfsfs${request}");
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      print(str);
      var finalResponse = SubscriptionModel.fromJson(json.decode(str));
      setState(() {
        plansModel = finalResponse;
      });
      log(finalResponse.toString());
      //return PlansModel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }

  checkOut(price) {
    print(price);
    var options = {
      'key': "rzp_test_CpvP0qcfS4CSJD",
      'amount': price * 100,
      'currency': 'INR',
      'name': 'Glowdrop',
      'description': '',
      "image":
          "${AppConstants.baseUrl}/storage/app/public/company/2025-08-14-689db8bde2f15.png",
      // 'prefill': {'contact': userMobile, 'email': userEmail},
    };
    print("OPTIONS ===== $options");
    _razorpay.open(options);
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    UtilityHlepar.getToast("Payment Successful");
    purchasePlan(
        planId: planID, txnId: "${response.paymentId}", amount: planeAmount);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("FAILURE === ${response.message}");
    UtilityHlepar.getToast("Payment Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  Future purchasePlan(
      {required String planId,
      required String txnId,
      required String amount}) async {
    var userIdValue = await MyToken.getUserID();
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.baseUrl}/api/v1/auth/purchase_plan'));
    request.fields.addAll({
      'user_id': userIdValue,
      'plan_id': planId,
      'transaction_id': txnId,
      'amount': amount,
      'remark': 'ok'
    });

    print(request);
    print("PURCHACE PLAN PARAM" + request.fields.toString());

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final jsonResponse = PurchasePlanModel.fromJson(json.decode(str));
      if (jsonResponse.responseCode == "1") {
        UtilityHlepar.getToast("Plan Purchases Successfully!");
        Navigator.pop(context, true);
      }
      return PurchasePlanModel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }



  Widget _buildPlanCard(SubscriptionList plan, bool isPopular) {
    final finalPrice = calculateFinalPrice((plan.amount?? 0), (plan.discountAmount??0));
    final discountPercent = calculateDiscount((plan.amount??0), (plan.discountAmount??0));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:  Border.all(color: Theme.of(context).primaryColor, width: 2) ,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Badge
          if (isPopular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withValues(alpha: 0.5)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.star, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Most Popular',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          // Plan Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isPopular ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isPopular ? 0 : 14),
                topRight: Radius.circular(isPopular ? 0 : 14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.title ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [

                    if (plan.status == 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Active',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Pricing
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹${finalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if ((plan.discountAmount??0) > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        '₹${plan.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                if ((plan.discountAmount ?? 0) > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_offer, size: 12, color: Colors.red[700]),
                        const SizedBox(width: 4),
                        Text(
                          'Save $discountPercent% (₹${plan.discountAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')})',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      '${plan.days} Days Validity',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Features
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KEY FEATURES',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                
                
                Html(data: plan.description, style: {
                  "h1": Style(fontSize: FontSize(22), fontWeight: FontWeight.bold),
                  "h3": Style(fontSize: FontSize(18), fontWeight: FontWeight.w600),
                  "p": Style(fontSize: FontSize(14)),
                  "li": Style(fontSize: FontSize(14)),
                  "hr": Style(margin: Margins.symmetric(vertical: 16)),
                },),


                // _buildFeatureItem('Verified Badge & KYC Support'),
                // _buildFeatureItem('Exclusive Marketing & Branding'),
                // _buildFeatureItem('12-15% Commission Only'),
                // _buildFeatureItem('Fast Payouts (2-3 Days)'),
                // _buildFeatureItem('Featured Listing & Priority Leads'),
                // _buildFeatureItem('Limited Competition Zone-wise'),
                const SizedBox(height: 16),
                /*// Guarantee
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade50, Colors.orange.shade50],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      left: BorderSide(color: Colors.amber, width: 4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Minimum Business Guarantee',
                        style: TextStyle(
                          color: Colors.amber[900],
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        getGuaranteeText(plan.id ?? 0),
                        style: TextStyle(
                          color: Colors.amber[800],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),*/
                // Subscribe Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => handleSubscribe(plan),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      backgroundColor: isPopular ? Theme.of(context).primaryColor : Colors.orange,
                    ),
                    child: const Text(
                      'Subscribe Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handleSubscribe(SubscriptionList plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Subscribe to ${plan.title}'),
        content: Text('Do you want to subscribe to this plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Subscribed to ${plan.title}!')),
              );

              planID = plan.id
                  .toString();
              planeAmount = ((plan.amount ?? 0) - (plan.discountAmount ??0)).toString();
              checkOut((plan.amount ?? 0) - (plan.discountAmount ??0));
            },
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
  }

  int calculateDiscount(int amount, int discountAmount) {
    if (discountAmount > 0) {
      return ((discountAmount / amount) * 100).round();
    }
    return 0;
  }

  int calculateFinalPrice(int amount, int discountAmount) {
    return amount - discountAmount;
  }
  String getGuaranteeText(int planId) {
    return planId == 1
        ? '₹50,000 business return guaranteed in 1 year'
        : '₹1,50,000 business return guaranteed in 1 year';
  }
}
