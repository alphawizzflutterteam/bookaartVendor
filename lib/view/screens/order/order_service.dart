import 'dart:async';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/main.dart';

import '../../../data/model/response/order_model.dart';
import '../../../main.dart';
import '../../../provider/order_provider.dart';

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService(context) => _instance;

  OrderService._internal() {
    // Initialize the timer for periodic order checks
    _startOrderCheckTimer();
  }

  final _orderCheckController = StreamController<bool>.broadcast();
  Stream<bool> get orderCheckStream => _orderCheckController.stream;

  Future<void> _startOrderCheckTimer() async {
    int length=0;
    int x=0;
 //   Provider.of<OrderProvider>(Get.context!, listen: false).getOrderList(Get.context!,1,'all');
    Timer.periodic(Duration(seconds: 10), (timer) async {
    List<Order>? orderList = [];
    orderList =  Provider.of<OrderProvider>(Get.context!, listen: false).orderModel?.orders;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('orderList Langth${await prefs.getInt('ordersList')}');
     x = await prefs.getInt('ordersList') ?? 0 ;
     length = orderList?.length ?? 0;
    if( length > x) {
      await prefs.setInt('ordersList',orderList?.length  ?? 0);
      _orderCheckController.add(true);
    }
else{
      _orderCheckController.add(false);
    }
    });
    // print("time of order alert${length} ${x}");
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   // Emit a signal to indicate the need to check for new orders
    //   if( length > x!)
    //     _orderCheckController.add(true);
    //   else
    //     _orderCheckController.add(false);
    // });
  }

  void dispose() {
    _orderCheckController.close();
  }


}