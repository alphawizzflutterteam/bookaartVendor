import 'package:flutter/material.dart';

import '../../../main.dart';
import 'order_service.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isNewOrderArrived = false;

  @override
  void initState() {
    super.initState();
    // Subscribe to the order check stream
    OrderService(context).orderCheckStream.listen((isNewOrder) {
      setState(() {
        isNewOrderArrived = isNewOrder;
      });
      if (isNewOrder) {
        // Show the dialog on the current screen
        showDialog(
          context: navigatorKey.currentState!.overlay!.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("New Order Arrived"),
              content: Text("You have a new order!"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  void closeDialog() {
    setState(() {
      isNewOrderArrived = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Order Notification'),
      ),
      body: Center(
        child: isNewOrderArrived
            ? AlertDialog(
          title: Text("New Order Arrived"),
          content: Text("You have a new order!"),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                closeDialog();
              },
            ),
          ],
        )
            : Text(
          'Your app content here',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}