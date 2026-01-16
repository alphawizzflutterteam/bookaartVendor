import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/add_product_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/image_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/seller_category_model.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/globles.dart';

class SellerRepo {
  final DioClient? dioClient;
  SellerRepo({required this.dioClient});

  Future<ApiResponse> getAttributeList(String languageCode) async {
    try {
      final response = await dioClient!.get(
        AppConstants.attributeUri,
        options: Options(headers: {AppConstants.langKey: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBrandList(String languageCode) async {
    try {
      final response = await dioClient!.get(
        AppConstants.brandUri,
        options: Options(headers: {AppConstants.langKey: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSellerCategoryList(String languageCode) async {
    try {
      final response = await dioClient!.get(
        AppConstants.sellerCategoryUri,
        options: Options(headers: {AppConstants.langKey: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  Future<ApiResponse> getService() async {
    try {
      final response = await dioClient!.get(
        AppConstants.getServiceUri,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getEditProduct(int? id) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.editProductUri}/$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryList(String languageCode) async {
    try {
      final response = await dioClient!.getUri(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.categoryUri}'),
        options: Options(headers: {AppConstants.langKey: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubCategoryList() async {
    try {
      final response = await dioClient!.get(AppConstants.categoryUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubSubCategoryList() async {
    try {
      final response = await dioClient!.get(AppConstants.categoryUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addImage(BuildContext context, ImageModel imageForUpload,
      bool colorActivate) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.uploadProductImageUri}',
        ));

    if (kDebugMode) {
      // print('==image is exist or not=${imageForUpload.image!.path}');
    }
    request.headers.addAll(<String, String>{
      'Authorization':
          'Bearer ${Provider.of<AuthProvider>(context, listen: false).getUserToken()}'
    });
    if (Platform.isAndroid || Platform.isIOS && imageForUpload.image != null) {
      File file = File(imageForUpload.image!.path);
      request.files.add(http.MultipartFile(
          'image', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'type': imageForUpload.type!,
      'color': imageForUpload.color!,
      'colors_active': colorActivate.toString()
    });
    request.fields.addAll(fields);
    if (kDebugMode) {
      print('=====> ${request.url.path}\n${request.fields}');
    }

    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    print("responseresponse ${res.body}");
    if (kDebugMode) {
      print('=====Response body is here==>${res.body}');
    }

    try {
      return ApiResponse.withSuccess(Response(
          statusCode: response.statusCode,
          requestOptions: RequestOptions(path: ''),
          statusMessage: response.reasonPhrase,
          data: res.body));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addProduct(
      Product product,
      AddProductModel addProduct,
      Map<String, dynamic> attributes,
      List<String?>? productImages,
      String? thumbnail,
      String? metaImage,
      String token,
      bool isAdd,
      bool isActiveColor,
      List<ColorImage> colorImageObject,
      List<String?> tags,
      String subCategory,
      String subSubCategory) async {
    dioClient!.dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    Map<String, dynamic> fields = {};
    fields.addAll(<String, dynamic>{
      'name': addProduct.titleList,
      'description': addProduct.descriptionList,
      'unit_price': product.unitPrice,
      'purchase_price': product.purchasePrice,
      'discount': product.discount,
      'discount_type': product.discountType,
      'tax': product.tax,
      'tax_model': product.taxModel,
      'category_id': product.categoryIds![0].id,
      'sub_category_id': subCategory,
      'sub_sub_category_id': subSubCategory,
      'unit': product.unit,
      'brand_id': product.brandId,
      'meta_title': product.metaTitle,
      'meta_description': product.metaDescription,
      'lang': addProduct.languageList,
      'colors': addProduct.colorCodeList,
      'images': productImages,
      'color_image': colorImageObject,
      'thumbnail': thumbnail,
      'colors_active': isActiveColor,
      'video_url': addProduct.videoUrl,
      'meta_image': metaImage,
      'current_stock': product.currentStock,
      'shipping_cost': product.shippingCost,
      'multiply_qty': product.multiplyWithQuantity,
      'code': product.code,
      'minimum_order_qty': product.minimumOrderQty,
      'product_type': product.productType,
      "digital_product_type": product.digitalProductType,
      "digital_file_ready": product.digitalFileReady,
      "tags": tags
    });
    if (product.categoryIds!.length > 1) {
      fields.addAll(
          <String, dynamic>{'sub_category_id': product.categoryIds![1].id});
    }
    if (product.categoryIds!.length > 2) {
      fields.addAll(
          <String, dynamic>{'sub_sub_category_id': product.categoryIds![2].id});
    }
    if (!isAdd) {
      // fields.addAll(<String, dynamic>{'_method': 'put', 'id': product.id});
      fields.addAll(<String, dynamic>{'_method': 'put', 'id': product.id});
    }
    if (attributes.isNotEmpty) {
      fields.addAll(attributes);
    }

    print('==========Response Body======>$fields');
    if (kDebugMode) {
      print('==========Response Body======>$fields');
    }
    if (kDebugMode) {
      fields.forEach((key, value) {
        print('$key:$value');
      });
      print('==========Response Body======>$fields');
    }

    try {
      Response response = await dioClient!.post(
        '${AppConstants.baseUrl}${isAdd ? AppConstants.addProductUri : '${AppConstants.updateProductUri}/${product.id}'}',
        data: fields,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteProduct(int? productID) async {
    try {
      final response = await dioClient!.post(
          '${AppConstants.deleteProductUri}/$productID',
          data: {'_method': 'delete'});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> uploadDigitalProduct(File? filePath, String token) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.digitalProductUpload}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    if (filePath != null) {
      Uint8List list = await filePath.readAsBytes();
      var part = http.MultipartFile(
          'digital_file_ready', filePath.readAsBytes().asStream(), list.length,
          filename: basename(filePath.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{});

    request.fields.addAll(fields);
    if (kDebugMode) {
      print('=====> ${request.url.path}\n${request.fields}');
    }

    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    if (kDebugMode) {
      print('=====Response body is here==>${res.body}');
    }

    try {
      return ApiResponse.withSuccess(Response(
          statusCode: response.statusCode,
          requestOptions: RequestOptions(path: ''),
          statusMessage: response.reasonPhrase,
          data: res.body));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> uploadAfterSellDigitalProduct(
      File? filePath, String token, String orderId) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.digitalProductUploadAfterSell}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    if (kDebugMode) {
      print('Here is ===>$filePath');
    }
    if (filePath != null) {
      Uint8List list = await filePath.readAsBytes();
      var part = http.MultipartFile('digital_file_after_sell',
          filePath.readAsBytes().asStream(), list.length,
          filename: basename(filePath.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{'order_id': orderId, '_method': 'put'});

    request.fields.addAll(fields);
    if (kDebugMode) {
      print('=====> ${request.url.path}\n${request.fields}');
    }

    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    if (kDebugMode) {
      print('=====Response body is here==>${res.body}');
    }

    try {
      return ApiResponse.withSuccess(Response(
          statusCode: response.statusCode,
          requestOptions: RequestOptions(path: ''),
          statusMessage: response.reasonPhrase,
          data: res.body));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateProductQuantity(
      int productId, int currentStock, List<Variation> variation) async {
    try {
      final response =
          await dioClient!.post(AppConstants.updateProductQuantity, data: {
        "product_id": productId,
        "current_stock": currentStock,
        "variation": [],
        "_method": "put"
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> addservice(
      XFile? serviceImage,
      XFile? thumbnail,
      SellerServiceModel serviceModel,{int? id}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstants.token) ?? '';
    var headers = {
      'Authorization': 'Bearer $token'
    };

    // Position? position = await getCurrentLocation();
    // print(position);
    http.MultipartRequest request = http.MultipartRequest('POST',
        id== null
            ? Uri.parse('${AppConstants.baseUrl}${AppConstants.addServiceUri}')
            : Uri.parse('${AppConstants.baseUrl}${AppConstants.updateServiceUri}/$id')
    );
    if (serviceImage != null) {
      Uint8List list = await serviceImage.readAsBytes();
      var part = http.MultipartFile(
          'images[]', serviceImage.readAsBytes().asStream(), list.length,
          filename: basename(serviceImage.path));
      request.files.add(part);
    }
    if (thumbnail != null) {
      Uint8List list = await thumbnail.readAsBytes();
      var part = http.MultipartFile(
          'thumbnail', thumbnail.readAsBytes().asStream(), list.length,
          filename: basename(thumbnail.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'name': serviceModel.name!,
      'discount_type': serviceModel.discountType?.toLowerCase() ??'',
      'unit_price': serviceModel.unitPrice ??'',
      'discount': serviceModel.discount ??'',
      'service_type':serviceModel.serviceType?.toLowerCase() ??'home',
      'tax': serviceModel.tax ??'',
      'tax_model': serviceModel.taxModel?.toLowerCase() ??'',
      'description': serviceModel.description ??'',
      'is_faster': '${serviceModel.isFaster ?? 0}',
      'video_link': '',
      'shipping_cost': '',
      //'date': serviceModel.date ?? '',
      //"from_time": '07:22'/*serviceModel.fromTime*/ ?? '',
      //"to_time": '12:22'/*serviceModel.toTime*/ ?? '',
      "seller_category_id": serviceModel.sellerCategoryId ?? '',
      "seller_sub_category_id": serviceModel.sellerSubCategoryId ?? '',

    });

    for(int i=0; i<serviceModel.timeSlot!.length; i++) {
      fields['date[$i]'] = formatDate(serviceModel.timeSlot![i]['date'].toString());
      fields['from_time[$i]'] = formatTime(serviceModel.timeSlot![i]['fromTime']).toString();
      fields['to_time[$i]'] = formatTime(serviceModel.timeSlot![i]['toTime']).toString();
    }



    request.headers.addAll(headers);

    request.fields.addAll(fields);
    if (kDebugMode) {
      print(
          '=====> praara metet of registratioon ${request.url.path}\n${request.fields}');
    }

    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    if (kDebugMode) {
      print('=====Response body is here==>${res.body}');
    }

    try {
      return ApiResponse.withSuccess(Response(
          statusCode: response.statusCode,
          requestOptions: RequestOptions(path: ''),
          statusMessage: response.reasonPhrase,
          data: res.body));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteService(int? serviceID) async {
    try {
      final response = await dioClient!.post(
          '${AppConstants.deleteServiceUri}/$serviceID',
          data: {'_method': 'delete'});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
