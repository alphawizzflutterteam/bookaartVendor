import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sixvalley_vendor_app/provider/transaction_provider.dart';
import 'package:sixvalley_vendor_app/view/screens/wallet/wallet_screen.dart';

class AddMoneyDialog extends StatefulWidget {
  @override
  _AddMoneyDialogState createState() => _AddMoneyDialogState();
}

class _AddMoneyDialogState extends State<AddMoneyDialog> {
  TextEditingController _controller = TextEditingController();
  Razorpay? _razorpay;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Provider.of<TransactionProvider>(context, listen: false)
        .addMoney(context, response.paymentId, pricerazorpayy);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(msg: "Payment cancelled by user");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  double pricerazorpayy = 0.0;

  void openCheckout(amount) async {
    double res = double.parse(amount.toString());
    pricerazorpayy = int.parse(res.toStringAsFixed(0)) * 100;
    // Navigator.of(context).pop();
    var options = {
      'key': 'rzp_live_RjWvwz0w0hjKkI',//'rzp_test_1DP5mmOlF5G5ag',
      'amount': "$pricerazorpayy",
      'name': 'Townway',
      'image': 'assets/images/Group 165.png',
      'description': 'Townway',
    };
    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Money to Wallet'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Enter amount'),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text(
            'Add',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            // Perform add money operation
            if (_controller.text.isNotEmpty) {
              // Handle adding money to wallet (e.g., update state, database, etc.)
              // For simplicity, just print the amount
              print('Added ${_controller.text} to wallet');
            }
            pricerazorpayy = double.parse(_controller.text.toString());
            // openCheckout(pricerazorpayy);

            Navigator.pop(context, pricerazorpayy);
          },
        ),
      ],
    );
  }
}
