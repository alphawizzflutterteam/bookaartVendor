import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/body/register_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class AuthRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> login(
      {String? mobile,
      String? password,
      String? deviceToken,
      required bool isOtpLogin,
      String? otp}) async {
    print("sdfsffsdfjsdkfsf ${{
      "email": mobile,
      "password": password,
      "device_token": deviceToken
    }}");
    try {
      Response response = await dioClient!.post(
        isOtpLogin == true
            ? "/api/v3/seller/auth/verify_otp"
            : AppConstants.loginUri,
        data: isOtpLogin == true
            ? {"phone": mobile, "otp": otp}
            : {
                "email": mobile,
                "password": password,
                "device_token": deviceToken
              }, //emailAddress
      );
      print('dgdfhdghfgn${{
        "email": mobile,
        "password": password,
        "device_token": deviceToken
      }}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> forgetPassword(String identity) async {
    try {
      Response response = await dioClient!
          .post(AppConstants.forgetPasswordUri, data: {"identity": identity});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> resetPassword(String identity, String otp,
      String password, String confirmPassword) async {
    try {
      Response response =
          await dioClient!.post(AppConstants.resetPasswordUri, data: {
        "_method": "put",
        "identity": identity.trim(),
        "otp": otp,
        "password": password,
        "confirm_password": confirmPassword
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyOtp(String identity, String otp) async {
    try {
      Response response = await dioClient!.post(AppConstants.verifyOtpUri,
          data: {"identity": identity.trim(), "otp": otp});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateToken() async {
    try {
      String? deviceToken = await _getDeviceToken();
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
      Response response = await dioClient!.post(
        AppConstants.tokenUri,
        data: {"_method": "put", "cm_firebase_token": deviceToken},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String?> _getDeviceToken() async {
    String? deviceToken;
    if (Platform.isIOS) {
      deviceToken = await FirebaseMessaging.instance.getAPNSToken();
    } else {
      deviceToken = await FirebaseMessaging.instance.getToken();
    }

    if (deviceToken != null) {
      if (kDebugMode) {
        print('--------Device Token---------- $deviceToken');
      }
    }
    return deviceToken;
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient!.token = token;
    dioClient!.dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      await sharedPreferences!.setString(AppConstants.token, token);
    } catch (e) {
      rethrow;
    }
  }

  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.token);
  }

  Future<bool> clearSharedData() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
    return sharedPreferences!.remove(AppConstants.token);
    //return sharedPreferences.clear();
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences!.setString(AppConstants.userPassword, password);
      await sharedPreferences!.setString(AppConstants.userEmail, number);
    } catch (e) {
      rethrow;
    }
  }

  String getUserEmail() {
    return sharedPreferences!.getString(AppConstants.userEmail) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences!.getString(AppConstants.userPassword) ?? "";
  }

  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // If not, request the user to enable location services.
        await Geolocator.openLocationSettings();
        return null;
      }

      // Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, show an error.
          print("Location permissions are denied.");
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        print("Location permissions are permanently denied.");
        return null;
      }

      // Fetch the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
      return position;
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences!.remove(AppConstants.userPassword);
    return await sharedPreferences!.remove(AppConstants.userEmail);
  }

  Future<ApiResponse> registration(
    XFile? profileImage,
    XFile? shopLogo,
    XFile? shopBanner,
    XFile? secondaryBanner,
    RegisterModel registerModel,
    String type,
    String lat,
    String long,
    XFile? aadhar,
    XFile? panCard,
    XFile? aadharBack,
  ) async {
    // Position? position = await getCurrentLocation();
    // print(position);
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.baseUrl}${AppConstants.registration}'));
    if (profileImage != null) {
      Uint8List list = await profileImage.readAsBytes();
      var part = http.MultipartFile(
          'image', profileImage.readAsBytes().asStream(), list.length,
          filename: basename(profileImage.path));
      request.files.add(part);
    }
    if (aadhar != null) {
      Uint8List list = await aadhar.readAsBytes();
      var part = http.MultipartFile(
          'aadhar_front_img', aadhar.readAsBytes().asStream(), list.length,
          filename: basename(aadhar.path));
      request.files.add(part);
    }
    if (aadharBack != null) {
      Uint8List list = await aadharBack.readAsBytes();
      var part = http.MultipartFile(
          'aadhar_back_img', aadharBack.readAsBytes().asStream(), list.length,
          filename: basename(aadharBack.path));
      request.files.add(part);
    }
    if (panCard != null) {
      Uint8List list = await panCard.readAsBytes();
      var part = http.MultipartFile(
          'pan_card', panCard.readAsBytes().asStream(), list.length,
          filename: basename(panCard.path));
      request.files.add(part);
    }
    if (shopLogo != null) {
      Uint8List list = await shopLogo.readAsBytes();
      var part = http.MultipartFile(
          'logo', shopLogo.readAsBytes().asStream(), list.length,
          filename: basename(shopLogo.path));
      request.files.add(part);
    }
    if (shopBanner != null) {
      Uint8List list = await shopBanner.readAsBytes();
      var part = http.MultipartFile(
          'banner', shopBanner.readAsBytes().asStream(), list.length,
          filename: basename(shopBanner.path));
      request.files.add(part);
    }
    if (secondaryBanner != null) {
      Uint8List list = await secondaryBanner.readAsBytes();
      var part = http.MultipartFile('bottom_banner',
          secondaryBanner.readAsBytes().asStream(), list.length,
          filename: basename(secondaryBanner.path));
      request.files.add(part);
    }
    String? deviceToken = await _getDeviceToken();
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'f_name': registerModel.fName!,
      'device_token': deviceToken ?? '',
      'l_name': registerModel.lName!,
      'phone': registerModel.phone!,
      'email': registerModel.email!,
      'password': registerModel.password!,
      //'confirm_password': registerModel.confirmPassword!,
      'shop_name': registerModel.shopName!,
      'shop_address': registerModel.shopAddress!,
      'seller_category_id': registerModel.sellerCategory!,
      'seller_sub_category_id': registerModel.sellerSubCategory!,
      'aadhar_num': registerModel.aadharNumber!,
      'type': type,
      "latitude": lat.toString(),
      "longitude": long.toString(),
      "area": registerModel.area ?? '',
      "zipcode": registerModel.zipCode ?? '',
      "state": registerModel.state ?? "",
      "city": registerModel.city ?? '',
      "gst": registerModel.gstNumber ?? ''
    });

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
}
