import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/flash_deals_model.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/screens/flashDeals/add_product.dart';

class FlashDeals extends StatefulWidget {
  const FlashDeals({Key? key}) : super(key: key);

  @override
  State<FlashDeals> createState() => _FlashDealsState();
}

class _FlashDealsState extends State<FlashDeals> {
  List<FlashDealsModel> dataList = <FlashDealsModel>[];

  Dio? dio;
  String? token;

  void getData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString(AppConstants.token);
      dio = Dio();

      dio!
        ..options.baseUrl = AppConstants.baseUrl
        ..options.connectTimeout = const Duration(microseconds: 30000)
        ..options.receiveTimeout = const Duration(microseconds: 30000)
        ..httpClientAdapter
        ..options.headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        };
      var response = await dio?.get(
        AppConstants.getFlashDealsUri,
      );

      FlashDealsModelList flashDealsModelList =
          FlashDealsModelList.fromJson(response?.data);
      dataList = flashDealsModelList.data ?? [];
      setState(() {});
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      appBar: const CustomAppBar(title: "Flash Deals", isBackButtonExist: true),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dataList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = dataList[index];
                  return FlashDealItem(
                      item: item, token: token!, getData: getData);
                }),
          ),
        ),
      ),
    );
  }
}

class FlashDealItem extends StatelessWidget {
  final FlashDealsModel item;
  final String token;
  var getData;

  FlashDealItem(
      {Key? key, required this.item, required this.token, this.getData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime tempDateStart = DateTime.parse(item.startDate!).toLocal();
    DateTime tempDateEnd = DateTime.parse(item.endDate!).toLocal();

    String dateStart = DateFormat("dd-MMM-yy").format(tempDateStart);
    String dateEnd = DateFormat("dd-MMM-yy").format(tempDateEnd);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FlashDealsAddProduct(token: token, id: item.id!),
          ),
        ).then((value) => getData()),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).cardColor),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.title ?? '',
                  style: robotoBold.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                item.status == 1
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.shade100,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text("Active",
                            style: robotoRegular.copyWith(fontSize: 12)),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.shade100,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text("Inactive",
                            style: robotoRegular.copyWith(fontSize: 12)),
                      )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Duration: $dateStart - $dateEnd",
                  style: robotoRegular.copyWith(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                    item.sellerProductsCount != null
                        ? "${item.sellerProductsCount}"
                        : "0",
                    style: robotoRegular.copyWith(fontSize: 14)),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
