import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/booking_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/business_analytics_filter_data.dart';
import 'package:sixvalley_vendor_app/data/model/response/delivery_man_detail_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/invoice_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_details_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/data/repository/order_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';

import '../utill/globles.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;
  OrderProvider({required this.orderRepo});

  String? _paymentStatus;
  String? get paymentStatus => _paymentStatus;
  String? _orderStatus;
  String? get orderStatus => _orderStatus;
  BookingModel? _bookingModel;
  BookingModel? get bookingModel => _bookingModel;
  OrderModel? _orderModel;
  OrderModel? get orderModel => _orderModel;

  double _discountOnProduct = 0;
  double get discountOnProduct => _discountOnProduct;

  double _totalTaxAmount = 0;
  double get totalTaxAmount => _totalTaxAmount;
  final int _offset = 1;
  int get offset => _offset;

  List<OrderDetailsModel>? _orderDetails;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;

  //////////
  ///
  List<DeliveryMan>? _deliveryManList = [];
  List<DeliveryMan>? get deliveryManList => _deliveryManList;

  ///
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _orderTypeIndex = 0;
  int get orderTypeIndex => _orderTypeIndex;

  List<String> _orderStatusList = [];
  String? _orderStatusType = '';
  List<String> get orderStatusList => _orderStatusList;
  String? get orderStatusType => _orderStatusType;

  String? _addOrderStatusErrorText;
  String? get addOrderStatusErrorText => _addOrderStatusErrorText;

  List<String>? _paymentImageList;
  List<String>? get paymentImageList => _paymentImageList;

  int _paymentMethodIndex = 0;
  int get paymentMethodIndex => _paymentMethodIndex;
  File? _selectedFileForImport;
  File? get selectedFileForImport => _selectedFileForImport;

  DateTime? bookingStartDate ;
  DateTime? endDate ;

  void setOrderStatusErrorText(String errorText) {
    _addOrderStatusErrorText = errorText;
    notifyListeners();
  }

  Future<ApiResponse> updateOrderStatus(
      int? id, String? status, BuildContext context, String? type) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse;
    apiResponse = await orderRepo!.orderStatus(id, status);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      getOrderList(Get.context!, 1, type ?? "all");
      _isLoading = false;
      Map map = apiResponse.response!.data;
      String? message = map['message'];

      showCustomSnackBar(message, Get.context!,
          isToaster: true, isError: false);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


  Future<ApiResponse> updateBookingStatus( int? id, String? status, BuildContext context, String? type) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse;
    apiResponse = await orderRepo!.bookingStatus(id, status);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      getBookingList(context, offset, type ?? 'all', formatDate(bookingStartDate.toString()), formatDate(endDate.toString()));
      _isLoading = false;
      Map map = apiResponse.response!.data;
      String? message = map['message'];

      showCustomSnackBar(message, Get.context!,
          isToaster: true, isError: false);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> updateBookingPaymentStatus( int? id, String? status, BuildContext context, String? type) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse;
    apiResponse = await orderRepo!.paymentStatus(id, status);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      getBookingList(context, offset, type ?? 'all', formatDate(bookingStartDate.toString()), formatDate(endDate.toString()));
      _isLoading = false;
      Map map = apiResponse.response!.data;
      String? message = map['message'];

      showCustomSnackBar(message, Get.context!,
          isToaster: true, isError: false);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }



  Future<void> getOrderList(BuildContext? context, int offset, String status,
      {bool reload = true}) async {
    if (reload) {
      _orderModel = null;
    }
    _isLoading = true;
    ApiResponse apiResponse = await orderRepo!.getOrderList(offset, status);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (offset == 1) {
        _orderModel = OrderModel.fromJson(apiResponse.response!.data);
      } else {
        _orderModel!.totalSize =
            OrderModel.fromJson(apiResponse.response!.data).totalSize;
        _orderModel!.offset =
            OrderModel.fromJson(apiResponse.response!.data).offset;
        _orderModel!.orders!
            .addAll(OrderModel.fromJson(apiResponse.response!.data).orders!);
      }

      for (Order order in _orderModel!.orders!) {
        _paymentStatus = order.paymentStatus;
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }


  Future<void> getBookingList(BuildContext? context, int offset, String status,String startDate, String endDate,
      {bool reload = true, String? search}) async {
    if (reload) {
      _bookingModel = null;
    }
    _isLoading = true;
    String status1 = status =='all' ?'': status =='pending' ?'0':status =='confirmed' ?'1':status =='completed' ?'2':'4';
    ApiResponse apiResponse = await orderRepo!.getBookingList(offset, status1, startDate, endDate,search: search);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (offset == 1) {
        _bookingModel = BookingModel.fromJson(apiResponse.response!.data);
      } else {
        _bookingModel!.totalSize =
            OrderModel.fromJson(apiResponse.response!.data).totalSize;
        _bookingModel!.offset =
            OrderModel.fromJson(apiResponse.response!.data).offset;
        _bookingModel!.data!
            .addAll(BookingModel.fromJson(apiResponse.response!.data).data!);
      }

      // for (Order order in _orderModel!.orders!) {
      //   _paymentStatus = order.paymentStatus;
      // }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }
  void selectBookingDate(String type, BuildContext context){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((date) {
      if (type == 'start'){
        bookingStartDate = date;

        getBookingList(context, offset, _orderType, formatDate(bookingStartDate.toString()), formatDate(endDate.toString()));

      }else{
        endDate = date;
        getBookingList(context, offset, _orderType, formatDate(bookingStartDate.toString()), formatDate(endDate.toString()));

      }
      if(date == null){

      }
      notifyListeners();
    });
  }






  void setPaymentStatus(String? status) {
    _paymentStatus = status;
  }

  String _orderType = 'all';
  String get orderType => _orderType;

  void setIndex(BuildContext context, int index, {bool notify = true, String search = ''}) {
    _orderTypeIndex = index;
    if (_orderTypeIndex == 0) {
      _orderType = 'all';
      //getOrderList(context, 1, 'all');

      getBookingList(context,1,'all',formatDate(bookingStartDate.toString()),formatDate(endDate.toString()),search: search);


    } else if (_orderTypeIndex == 1) {
      _orderType = 'pending';
      getBookingList(context,1,'pending',formatDate(bookingStartDate.toString()),formatDate(endDate.toString()));
     // getOrderList(context, 1, 'pending');
    } else if (_orderTypeIndex == 2) {
      _orderType = 'processing';
      getOrderList(context, 1, 'processing');
    } else if (_orderTypeIndex == 3) {
      //_orderType = 'delivered';

      _orderType = 'completed';
     // getOrderList(context, 1, 'delivered');
      getBookingList(context,1,'completed',formatDate(bookingStartDate.toString()),formatDate(endDate.toString()));

    } else if (_orderTypeIndex == 4) {
      _orderType = 'return';
      getOrderList(context, 1, 'returned');
    } else if (_orderTypeIndex == 5) {
      _orderType = 'failed';
      getOrderList(context, 1, 'failed');
    } else if (_orderTypeIndex == 6) {
      _orderType = 'cancelled';
     // getOrderList(context, 1, 'canceled');
      getBookingList(context,1,'cancelled',formatDate(bookingStartDate.toString()),formatDate(endDate.toString()));

    } else if (_orderTypeIndex == 7) {
      _orderType = 'confirmed';
      getBookingList(context,1,'confirmed',formatDate(bookingStartDate.toString()),formatDate(endDate.toString()));
     // getOrderList(context, 1, 'confirmed');
    } else if (_orderTypeIndex == 8) {
      _orderType = 'out_for_delivery';
      getOrderList(context, 1, 'out_for_delivery');
    }
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> getOrderDetails(String orderID) async {
    _orderDetails = null;
    ApiResponse apiResponse = await orderRepo!.getOrderDetails(orderID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response!.data.forEach(
          (order) => _orderDetails!.add(OrderDetailsModel.fromJson(order)));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void initOrderStatusList(String type) async {
    ApiResponse apiResponse = await orderRepo!.getOrderStatusList(type);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _orderStatusList = [];
      _orderStatusList.addAll(apiResponse.response!.data);
      _orderStatusType = apiResponse.response!.data[0];
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void updateStatus(String? value, {bool notify = true}) {
    _orderStatusType = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setPaymentMethodIndex(int index) {
    _paymentMethodIndex = index;
    notifyListeners();
  }

  final bool _selfDelivery = false;
  final bool _thirdPartyDelivery = false;
  bool get selfDelivery => _selfDelivery;
  bool get thirdPartyDelivery => _thirdPartyDelivery;

  Future updatePaymentStatus(
      {int? orderId, String? status, BuildContext? context}) async {
    ApiResponse apiResponse =
        await orderRepo!.updatePaymentStatus(orderId: orderId, status: status);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      getOrderList(Get.context!, 1, 'all');
      String? message =
          getTranslated('payment_status_updated_successfully', context!);
      showCustomSnackBar(message, Get.context!,
          isToaster: true, isError: false);
    } else if (apiResponse.response!.statusCode == 202) {
      Map map = apiResponse.response!.data;
      String? message = map['message'];
      showCustomSnackBar(message, Get.context!, isError: true);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void downloadFile(String url, String dir) async {
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir,
      showNotification: true,
      saveInPublicStorage: true,
      openFileFromNotification: true,
    );
  }

  void setSelectedFileName(File? fileName) {
    _selectedFileForImport = fileName;
    notifyListeners();
  }

  Future setDeliveryCharge(
      {int? orderId,
      String? deliveryCharge,
      String? deliveryDate,
      BuildContext? context}) async {
    ApiResponse apiResponse = await orderRepo!
        .setDeliveryCharge(orderId, deliveryCharge, deliveryDate);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? message = map['message'];
      showCustomSnackBar(message, Get.context!, isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  DateTime? _startDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime? get startDate => _startDate;
  DateFormat get dateFormat => _dateFormat;

  Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((date) {
      _startDate = date;

      notifyListeners();
    });
  }

  InvoiceModel? _invoice;
  InvoiceModel? get invoice => _invoice;
  Future<void> getInvoiceData(int? orderId) async {
    _isLoading = true;
    ApiResponse response = await orderRepo!.getInvoiceData(orderId);
    if (response.response != null && response.response!.statusCode == 200) {
      _discountOnProduct = 0;
      _totalTaxAmount = 0;
      _invoice = InvoiceModel.fromJson(response.response!.data);
      for (int i = 0; i < _invoice!.details!.length; i++) {
        _discountOnProduct += invoice!.details![i].discount!;
        if (invoice!.details![i].productDetails!.taxModel == "exclude") {
          _totalTaxAmount += invoice!.details![i].tax!;
        }
      }
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }

  String? _analyticsName = '';
  String? get analyticsName => _analyticsName;
  int _analyticsIndex = 0;
  int get analyticsIndex => _analyticsIndex;

  void setAnalyticsFilterName(
      BuildContext context, String? filterName, bool notify) {
    _analyticsName = filterName;
    getAnalyticsFilterData(context, _analyticsName);
    if (notify) {
      notifyListeners();
    }
  }

  void setAnalyticsFilterType(int index, bool notify) {
    _analyticsIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  BusinessAnalyticsFilterData? _businessAnalyticsFilterData;
  BusinessAnalyticsFilterData? get businessAnalyticsFilterData => _businessAnalyticsFilterData;

  Future<void> getAnalyticsFilterData(
      BuildContext context, String? type) async {
    _isLoading = true;
    ApiResponse response = await orderRepo!.getBookingFilterData(type);
    if (response.response != null && response.response!.statusCode == 200) {
      _businessAnalyticsFilterData =
          BusinessAnalyticsFilterData.fromJson(response.response!.data);
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }






  bool assigning = false;
  Future<ApiResponse> assignThirdPartyDeliveryMan(BuildContext context,
      String name, String trackingId, int? orderId) async {
    assigning = true;
    notifyListeners();
    ApiResponse apiResponse =
        await orderRepo!.assignThirdPartyDeliveryMan(name, trackingId, orderId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(
          getTranslated('third_party_delivery_type_successfully', Get.context!),
          Get.context!,
          isToaster: true,
          isError: false);
      assigning = false;
      getOrderList(Get.context!, 1, 'all');
    } else {
      assigning = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<void> getDeliveryManList(BuildContext context) async {
    _isLoading = true;
    ApiResponse response = await orderRepo!.getDeliveryManList();
    if (response.response!.statusCode == 200) {
      _isLoading = false;


      _deliveryManList = [];
      response.response!.data['data'].forEach((deliveryMan) =>
          _deliveryManList!.add(DeliveryMan.fromJson(deliveryMan)));
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<ApiResponse> assignDeliveryMan(
      BuildContext context, String deliveryManId, int orderId) async {
    notifyListeners();
    ApiResponse apiResponse =
        await orderRepo!.assignDeliveryMan(deliveryManId, orderId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(apiResponse.response!.data['message'], Get.context!,
          isToaster: true, isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }
}
