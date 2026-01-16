import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/data/model/response/delivery_man_add_new_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/custom_search_field.dart';
import 'package:sixvalley_vendor_app/view/screens/Subcriptionplans/utility_hlepar.dart';

class addDeliveryManNew extends StatefulWidget {
  const addDeliveryManNew({Key? key}) : super(key: key);

  @override
  State<addDeliveryManNew> createState() => _addDeliveryManNewState();
}

class _addDeliveryManNewState extends State<addDeliveryManNew> {
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  List<UnassignedDeliveryMen> dataList = <UnassignedDeliveryMen>[];

  Dio? dio;
  String? token;

  void getData() async {
    setState(() => isLoading = true);
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString(AppConstants.token);
      print("token $token");
      dio = Dio();

      dio!
        ..options.baseUrl = AppConstants.baseUrl
        ..options.connectTimeout = const Duration(milliseconds: 30000)
        ..options.receiveTimeout = const Duration(milliseconds: 30000)
        ..httpClientAdapter
        ..options.headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        };
      var response = await dio?.get(
        AppConstants.deliveryManListNewUri,
      );

      DeliveryManAddNewModel flashDealsModelList =
          DeliveryManAddNewModel.fromJson(response?.data);
      dataList = flashDealsModelList.unassignedDeliveryMen ?? [];
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
    setState(() => isLoading = false);
  }

  void addDeliveryMan(id) async {
    setState(() => isLoading = true);
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
      var response = await dio?.post(AppConstants.addDeliveryManNewUri,
          data: {"delivery_man_id": id});

      UtilityHlepar.getToast("Delivery Man Added!");

      Navigator.pop(context);
    } on SocketException catch (e) {
      UtilityHlepar.getToast("Failed to add!");
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      UtilityHlepar.getToast("Failed to add!");
      throw const FormatException("Unable to process the data");
    } catch (e) {
      UtilityHlepar.getToast("Failed to add!");
      rethrow;
    } finally {
      setState(() => isLoading = false);
    }
  }

  void search(value) async {
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
        "${AppConstants.deliveryManListNewUri}?search=$value",
      );

      DeliveryManAddNewModel flashDealsModelList =
          DeliveryManAddNewModel.fromJson(response?.data);
      dataList = flashDealsModelList.unassignedDeliveryMen ?? [];

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
      appBar: const CustomAppBar(
          title: "Add Delivery Man", isBackButtonExist: true),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
        },
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CustomSearchField(
                        controller: searchController,
                        hint: getTranslated('search', context),
                        prefix: Images.iconsSearch,
                        iconPressed: () => () {},
                        onSubmit: (text) => () {},
                        onChanged: (value) {
                          if (value.toString().isNotEmpty) {
                            search(value);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                          itemCount: dataList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var item = dataList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("${item.fName} ${item.lName}",
                                              style: robotoMedium.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 16)),
                                          const SizedBox(height: 4),
                                          Text("${item.phone}",
                                              style: robotoBold.copyWith(
                                                  color: Colors.grey,
                                                  fontSize: 14))
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          addDeliveryMan(item.id);
                                        },
                                        child: Container(
                                          height: 26,
                                          width: 70,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius: BorderRadius
                                                  .circular(Dimensions
                                                      .paddingSizeExtraSmall)),
                                          child: Text("Add",
                                              style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeDefault,
                                                color: Colors.white,
                                              )),
                                        ),
                                      )
                                    ]),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
