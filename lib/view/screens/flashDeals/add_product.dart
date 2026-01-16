import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/flash_deals_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/colors.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/dialog_button.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/widget.dart';
import 'package:sixvalley_vendor_app/view/screens/Subcriptionplans/utility_hlepar.dart';
import 'package:sizer/sizer.dart';

class FlashDealsAddProduct extends StatefulWidget {
  final String token;
  final int id;
  const FlashDealsAddProduct({Key? key, required this.token, required this.id})
      : super(key: key);

  @override
  State<FlashDealsAddProduct> createState() => FlashDeals_AddProductState();
}

class FlashDeals_AddProductState extends State<FlashDealsAddProduct> {
  var selectedProduct = null;

  List<Product> productsList = <Product>[];
  List<FlashDealProductsModel> addedProducts = <FlashDealProductsModel>[];

  Dio? dio;

  void getData() async {
    try {
      dio = Dio();

      dio!
        ..options.baseUrl = AppConstants.baseUrl
        ..options.connectTimeout = const Duration(microseconds: 30000)
        ..options.receiveTimeout = const Duration(microseconds: 30000)
        ..httpClientAdapter
        ..options.headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${widget.token}'
        };
      var response =
          await dio?.get('${AppConstants.getFlashDealUri}${widget.id}');

      FlashDealsModel flashDealsModelList =
          FlashDealsModel.fromJson(response?.data);
      addedProducts = flashDealsModelList.products ?? [];
      setState(() {});
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  void getProducts() async {
    try {
      final sellerId = Provider.of<ProfileProvider>(context, listen: false)
          .userInfoModel!
          .id
          .toString();

      dio = Dio();

      dio!
        ..options.baseUrl = AppConstants.baseUrl
        ..options.connectTimeout =const Duration(microseconds: 30000)
        ..options.receiveTimeout = const Duration(microseconds: 30000)
        ..httpClientAdapter
        ..options.headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${widget.token}'
        };
      var response = await dio?.get(
          '${AppConstants.sellerProductUri}$sellerId/all-products?limit=10&&offset=0&search=');

      var tempProductsList = ProductModel.fromJson(response?.data).products!;

      tempProductsList.map((item) {});
      for (var i = 0; i < tempProductsList.length; i++) {
        var item = tempProductsList[i];
        if (item.status == 1) {
          productsList.add(item);
        }
      }
      setState(() {});
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  void addProduct() async {
    try {
      dio = Dio();

      dio!
        ..options.baseUrl = AppConstants.baseUrl
        ..options.connectTimeout = const Duration(microseconds: 30000)
        ..options.receiveTimeout = const Duration(microseconds: 30000)
        ..httpClientAdapter
        ..options.headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${widget.token}'
        };

      var selectedProductId =
          productsList.firstWhere((item) => item.name == selectedProduct);

      var resp = await dio?.post(
          '${AppConstants.addFlashListProductUri}${widget.id}',
          data: {"product_id": selectedProductId.id});

      selectedProduct = null;

      print("resssp $resp");

      UtilityHlepar.getToast("Product Added!");

      getData();

      setState(() {});
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  void removeProduct(flashDealId, productId) async {
    try {
      dio = Dio();

      dio!
        ..options.baseUrl = AppConstants.baseUrl
        ..options.connectTimeout = const Duration(microseconds: 30000)
        ..options.receiveTimeout = const Duration(microseconds: 30000)
        ..httpClientAdapter
        ..options.headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${widget.token}'
        };

      await dio?.post(
          "${AppConstants.deleteFlashDealProductUri}$flashDealId/$productId");

      UtilityHlepar.getToast("Product Deleted!");

      getData();

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
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      appBar:
          const CustomAppBar(title: "Add new product", isBackButtonExist: true),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Add new product",
                style: robotoMedium.copyWith(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 10),
              productsList.isNotEmpty
                  ? Container(
                      width: double.infinity,
                      height: 6.h,
                      decoration: boxDecoration(
                        radius: 10.0,
                        // color: AppColor().colorEdit(),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: const Row(
                            children: [
                              Text(
                                'Select Product',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                          items: productsList
                              .map((item) => DropdownMenuItem<String>(
                                    value: item.name,
                                    child: Text(
                                      item.name ?? "",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: selectedProduct,
                          onChanged: (value) {
                            setState(() {
                              selectedProduct = value.toString();
                            });
                          },
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                          ),

                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: 160,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              // color: AppColor().colorEdit(),
                            ),
                            elevation: 0,
                          ),

                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),

                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 8,
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStatePropertyAll(6),
                              thumbVisibility: MaterialStatePropertyAll(true),
                            ),
                          ),

                          // icon: const Icon(
                          //   Icons.arrow_drop_down,
                          //   color: Colors.grey,
                          // ),
                          // iconSize: 24,
                          // buttonHeight: 50,
                          // buttonWidth: 160,
                          // buttonPadding:
                          //     const EdgeInsets.only(left: 14, right: 14),
                          // buttonDecoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(14),
                          //   // color: AppColor().colorEdit(),
                          // ),
                          // buttonElevation: 0,
                          // itemHeight: 40,
                          // itemPadding:
                          //     const EdgeInsets.only(left: 14, right: 14),
                          // dropdownMaxHeight: 300,
                          // dropdownPadding: null,
                          // dropdownDecoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(14),
                          // ),
                          // dropdownElevation: 8,
                          // scrollbarRadius: const Radius.circular(40),
                          // scrollbarThickness: 6,
                          // scrollbarAlwaysShow: true,
                        ),
                      ))
                  : Center(
                      child: Text(
                      "No products found!",
                      style: robotoRegular.copyWith(
                          color: Colors.grey, fontSize: 12),
                    )),
              const SizedBox(height: 10),
              selectedProduct != null
                  ? CustomButton(
                      btnTxt: "Add",
                      backgroundColor: Theme.of(context).primaryColor,
                      onTap: () {
                        addProduct();
                      },
                    )
                  : const SizedBox.shrink(),
              // Existing products
              const SizedBox(height: 20),
              Text(
                "Products",
                style: robotoMedium.copyWith(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: addedProducts.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var item = addedProducts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).cardColor),
                        child: Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${item.name}",
                                style: robotoBold.copyWith(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              item.status == 1
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent.shade100,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Text("Active",
                                          style: robotoRegular.copyWith(
                                              fontSize: 12)),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.yellowAccent.shade100,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Text("Pending",
                                          style: robotoRegular.copyWith(
                                              fontSize: 12)),
                                    )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Price: ${item.unitPrice}",
                                  style: robotoRegular.copyWith(fontSize: 14)),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Column(
                                          children: [
                                            Text(
                                              "Delete Product",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              "Are you sure you want to delete product?",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          DialogButton(
                                            onPressed: () async {
                                              removeProduct(item.flashDealId,
                                                  item.productId);
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                            color: AppColor.PrimaryDark,
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: "MuliRegular"),
                                            ),
                                          ),
                                          DialogButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                            color: Colors.grey,
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: "MuliRegular"),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.redAccent.shade200,
                                  size: 20,
                                ),
                              )
                            ],
                          )
                        ]),
                      ),
                    );
                  })
            ]),
          ),
        ),
      ),
    );
  }
}
