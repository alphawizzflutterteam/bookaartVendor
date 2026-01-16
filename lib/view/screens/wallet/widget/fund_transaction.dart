import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/model/response/fund_transaction_model.dart';
import '../../../../utill/app_constants.dart';
import '../../../base/custom_app_bar.dart';

class FundTransactionScreen extends StatefulWidget {
  FundTransactionScreen();

  @override
  State<FundTransactionScreen> createState() => _FundTransactionScreenState();
}

class _FundTransactionScreenState extends State<FundTransactionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: CustomAppBar(
            title: 'Transactions' /*getTranslated('plans', context)*/,
            isBackButtonExist: true,
          )),
      body: Column(
        children: [
          isLoading == true
              ? Center(child: CircularProgressIndicator())
              : fundList.isEmpty
                  ? Center(child: Text('No Data Found'))
                  : ListView.builder(
                      itemCount: fundList.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Transaction Id: ${fundList[index].transactionId}'),
                                      Text(
                                        fundList[index].status == 0
                                            ? 'Pending'
                                            : fundList[index].status == 1
                                                ? 'Approved'
                                                : 'Rejected',
                                        style: TextStyle(
                                            color: fundList[index].status == 0
                                                ? Colors.yellow
                                                : fundList[index].status == 1
                                                    ? Colors.green
                                                    : Colors.red,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Amount: ${fundList[index].amount}'),
                                      Text('${fundList[index].createdAt}'),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
        ],
      ),
    );
  }

  bool isLoading = false;
  List<FundTransactionData> fundList = [];
  Future<void> getTransaction() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.token);
    isLoading = true;
    setState(() {});

    final uri = Uri.parse(
        '${AppConstants.baseUrl}/api/v3/seller/get_request_money');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    // var userid = Provider.of<AuthProvider>(context, listen: false).getAuthID();
    // Add other fields to the request if needed
    // request.fields['user_id'] = '$userid';
    final response = await request.send();
    print("object AAAArequest ${request.fields}");
    print("object AAAArequest ${request.url}");
    // print("object AAAArequest ${response.}");

    final responseData = await http.Response.fromStream(response);
    Map<String, dynamic> responseMap = json.decode(responseData.body);
    print('Response Map: $responseMap');
    isLoading = false;
    setState(() {});
    // Fluttertoast.showToast(msg: responseMap['message']);
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      if (responseMap['status'] == true) {
        fundList = (responseMap['data'] as List)
            .map((e) => FundTransactionData.fromJson(e))
            .toList();
        // Navigator.pop(context);
      }
    } else {
      print('Image upload failed');
    }
  }
}
