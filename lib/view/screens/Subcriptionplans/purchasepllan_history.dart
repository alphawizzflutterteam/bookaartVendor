import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/data/model/response/plan_history_model.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';

import '../../../localization/language_constrants.dart';
import '../../base/custom_app_bar.dart';
import '../Service/colors.dart';
import 'app_token_data.dart';

class PlanHistoryPage extends StatefulWidget {
  const PlanHistoryPage({Key? key}) : super(key: key);

  @override
  State<PlanHistoryPage> createState() => _PlanHistoryPageState();
}

class _PlanHistoryPageState extends State<PlanHistoryPage>with SingleTickerProviderStateMixin  {
  var planStatus;

  PlanhistoryModel? planHistoryModel;

  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    getPlanHistory();
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  int getDaysRemaining(String expireDateStr) {
    try {
      final expireDate = DateTime.parse(expireDateStr);
      final now = DateTime.now();
      return expireDate.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: /*AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'My Plan & History',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3,
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.card_membership, size: 18),
                    SizedBox(width: 8),
                    Text('Active Plan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 18),
                    SizedBox(width: 8),
                    Text('History', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),*/CustomAppBar(
          title: getTranslated('Purchase_Plan_History', context),
          isBackButtonExist: true,
          height: 90,
          bottom: TabBar(
            controller: _tabController,
            labelColor: ColorResources.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3,
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.card_membership, size: 18),
                    SizedBox(width: 8),
                    Text('Active Plan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 18),
                    SizedBox(width: 8),
                    Text('History', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator(),)
            : TabBarView(
          controller: _tabController,
          children: [
            planHistoryModel?.data != null ? _buildActivePlanTab() : SizedBox(),
            planHistoryModel?.data?.planHistory != null ? _buildHistoryTab() : SizedBox(),
          ],
        )





    );
  }

  Widget listTile(PlanHistory planHistory) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Title : ${planHistory.plan!.title}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(
                    //   height: 5.0,
                    // ),
                    // Text(
                    //     "Description : ${planHistory.plan!.description}"),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                        "Expiry Date: ${planHistory.expireDate.toString().split(" ")[0]}"),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text("₹ ${planHistory.plan!.amount}"),
                  ],
                ),
              ),
              // Wrap(
              //   children: [
              //     Chip(
              //         backgroundColor: AppColor().colorPrimary(),
              //         label: Text(
              //           "Purchase Date: ${planHistory.plan!.createdAt.toString().split(" ")[0]}",
              //           style: TextStyle(color: Colors.white),
              //         )),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  getPlanHistory() async {
    try {
      var userId = await MyToken.getUserID();

      var request = http.MultipartRequest('POST',
          Uri.parse('${AppConstants.baseUrl}/api/v1/auth/my_plan'));
      request.fields.addAll({'user_id': userId});

      http.StreamedResponse response = await request.send();
      print("sfsfsfs${request}");

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        print(str);
        var finalResponse = PlanhistoryModel.fromJson(json.decode(str));
        setState(() {
          planHistoryModel = finalResponse;
        });
        log(finalResponse.toString());
        //return PlansModel.fromJson(json.decode(str));
      } else {
        return null;
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  Widget _buildActivePlanTab() {
    final daysRemaining = getDaysRemaining(planHistoryModel?.data?.expireDate.toString() ?? '');
    final finalPrice = (planHistoryModel?.data?.activePlan?.amount ?? 0) - (planHistoryModel?.data?.activePlan?.discountAmount ?? 0);
    final activePlan = planHistoryModel?.data?.activePlan ;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Plan Card
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor.withValues(alpha: 0.6), Theme.of(context).primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.workspace_premium,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  planHistoryModel?.data?.activePlan?.title ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'ACTIVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              icon: Icons.calendar_today,
                              label: 'Start Date',
                              value: formatDate(planHistoryModel?.data?.purchaseDate.toString() ?? ''),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          Expanded(
                            child: _buildInfoItem(
                              icon: Icons.event,
                              label: 'Expire Date',
                              value: formatDate(planHistoryModel?.data?.expireDate.toString() ?? ''),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.white, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              '$daysRemaining days remaining',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${planHistoryModel?.data?.activePlan?.days ?? 0} days',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Plan Details
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plan Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Original Price', '₹${activePlan!.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                _buildDetailRow('Discount', '- ₹${activePlan.discountAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', isDiscount: true),
                const Divider(height: 24),
                _buildDetailRow('Final Price', '₹${finalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', isBold: true),
                const SizedBox(height: 16),
               /* Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade50, Colors.orange.shade50],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.verified, color: Colors.amber.shade700, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Minimum Business Guarantee',
                              style: TextStyle(
                                color: Colors.amber.shade900,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹50,000 business return in 1 year',
                              style: TextStyle(
                                color: Colors.amber.shade800,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),*/
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Benefits
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plan Benefits',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Html(data: activePlan.description, style: {
                  "h1": Style(fontSize: FontSize(22), fontWeight: FontWeight.bold),
                  "h3": Style(fontSize: FontSize(18), fontWeight: FontWeight.w600),
                  "p": Style(fontSize: FontSize(14)),
                  "li": Style(fontSize: FontSize(14)),
                  "hr": Style(margin: Margins.symmetric(vertical: 16)),
                },),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return planHistoryModel?.data?.planHistory?.isEmpty ?? true
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No History Found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    )
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: planHistoryModel?.data?.planHistory?.length ?? 0,
      itemBuilder: (context, index) {
        final history = planHistoryModel?.data?.planHistory?[index];
        return _buildHistoryCard(history);
      },
    );
  }

  Widget _buildHistoryCard(PlanHistory? history) {
    final isSuccess = history?.status?.toLowerCase() == 'success';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSuccess ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_circle : Icons.cancel,
                    color: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        history?.plan?.title ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatDate(history?.createdAt.toString() ?? ''),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSuccess ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    history?.status ?? '',
                    style: TextStyle(
                      color: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHistoryDetailRow('Transaction ID', history?.transactionId ?? ''),
                const SizedBox(height: 12),
                _buildHistoryDetailRow('Amount', '₹${history?.amount ?? ''}'),
                const SizedBox(height: 12),
                _buildHistoryDetailRow('Expire Date', formatDate(history?.expireDate.toString() ?? '')),
                if (history?.remark?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  _buildHistoryDetailRow('Remark', history?.remark ?? ''),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isDiscount = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDiscount ? Colors.red : (isBold ? Colors.black87 : Colors.grey[800]),
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
