import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/transaction_provider.dart';
import '../../base/no_data_screen.dart';
import '../transaction/widget/transaction_widget.dart';

class AalletaddTransaction extends StatefulWidget {
  const AalletaddTransaction();

  @override
  State<AalletaddTransaction> createState() => _AalletaddTransactionState();
}

class _AalletaddTransactionState extends State<AalletaddTransaction> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false)
        .initget_wallet_transaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TransactionProvider>(
          builder: (context, transactionProvider, child) {
        return transactionProvider.walletList != null
            ? transactionProvider.walletList!.isNotEmpty
                ? ListView.builder(
                    itemCount: transactionProvider.walletList!.length,
                    itemBuilder: (context, index) => TransactionGetWalletWidget(
                        transactionModel:
                            transactionProvider.walletList![index]))
                : const NoDataScreen()
            : Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor)));
      }),
    );
  }
}
