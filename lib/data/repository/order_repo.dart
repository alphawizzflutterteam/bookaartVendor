import 'package:dio/dio.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class OrderRepo {
  final DioClient? dioClient;
  OrderRepo({required this.dioClient});

  Future<ApiResponse> getOrderList(int offset, String status) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.orderListUri}?limit=10&offset=$offset&status=$status');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBookingList(int offset, String status, String startDate, String endDate,{String? search}) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.bookingListUri}?limit=100&offset=0&status=$status&from_date=$startDate&to_date=$endDate&booking_id=${search ??''}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  Future<ApiResponse> getOrderDetails(String orderID) async {
    try {
      final response =
          await dioClient!.get(AppConstants.orderDetails + orderID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> setDeliveryCharge(int? orderID, String? deliveryCharge,
      String? expectedDeliveryDate) async {
    try {
      final response =
          await dioClient!.post(AppConstants.deliveryChargeForDelivery, data: {
        "order_id": orderID,
        "_method": "put",
        "deliveryman_charge": deliveryCharge,
        "expected_delivery_date": expectedDeliveryDate
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> orderStatus(int? orderID, String? status) async {
    print("statsu is $status");
    try {
      Response response = await dioClient!.post(
        '${AppConstants.updateOrderStatus}$orderID',
        data: {'_method': 'put', 'order_status': status},
      );
      print("herereree ${{'_method': 'put', 'order_status': status}}");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> bookingStatus(int? orderID, String? status) async {
    print("statsu is $status");
    try {
      Response response = await dioClient!.post(
        '${AppConstants.updateBookingStatus}',
        data: { 'status': status,'booking_id':'$orderID'},
      );
      print("herereree ${{ 'status': status,'booking_id':'$orderID'}}");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> paymentStatus(int? orderID, String? status) async {
    print("statsu is $status");
    try {
      Response response = await dioClient!.post(
        AppConstants.updatePaymentStatus,
        data: { 'payment_status': status,'id':'$orderID'},
      );
      print("herereree ${{ 'status': status,'booking_id':'$orderID'}}");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOrderStatusList(String type) async {
    try {
      List<String> addressTypeList = [];
      if (type == 'inhouse_shipping') {
        addressTypeList = ['pending', 'confirmed', 'processing'];
      } else {
        addressTypeList = [
          'pending',
          'confirmed',
          'processing',
          'out_for_delivery',
          'delivered',
          'returned',
          'failed',
          'cancelled',
        ];
      }

      Response response = Response(
          requestOptions: RequestOptions(path: ''),
          data: addressTypeList,
          statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updatePaymentStatus(
      {int? orderId, String? status}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.paymentStatusUpdate,
        data: {"order_id": orderId, "payment_status": status},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getInvoiceData(int? orderId) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.invoice}?id=$orderId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOrderFilterData(String? type) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.businessAnalytics}$type');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBookingFilterData(String? type) async {
    try {
      final response =
      await dioClient!.get('${AppConstants.businessAnalytics2}$type');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> assignThirdPartyDeliveryMan(
      String name, String trackingId, int? orderId) async {
    try {
      final response = await dioClient!
          .post(AppConstants.thirdPartyDeliveryManAssign, data: {
        'delivery_service_name': name,
        'third_party_delivery_tracking_id': trackingId,
        'order_id': orderId
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeliveryManList() async {
    try {
      final response =
          await dioClient!.get('${AppConstants.getDeliveryManListApi}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> assignDeliveryMan(
      String deliveryManId, int orderId) async {
    try {
      final response = await dioClient!.post(AppConstants.assignDeliveryMan,
          data: {'order_id': orderId, 'delivery_man_id': deliveryManId});
      print("ressppsp ${{
        'order_id': orderId,
        'delivery_man_id': deliveryManId
      }}");
      print("ressppsp $response");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
