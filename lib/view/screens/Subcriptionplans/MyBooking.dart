import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/view/screens/Subcriptionplans/MyBookingDetails.dart';

import '../../../localization/language_constrants.dart';
import '../../base/custom_app_bar.dart';
import '../Service/MyBookingModel.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({Key? key}) : super(key: key);

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  MyBookingModel? bookingServiceList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getBookingHistory();
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(milliseconds: 10));
    return getBookingHistory();
  }

  Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getBookingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.token) ?? "";

    try {
      setState(() => isLoading = true);
      final headers = {'Authorization': 'Bearer $token'};
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/v3/seller/services/my_booking'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        setState(() {
          bookingServiceList =
              MyBookingModel.fromJson(jsonDecode(response.body));
          isLoading = false;
        });
      } else {
        log('Error: ${response.reasonPhrase}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      log('Exception occurred: $e');
      setState(() => isLoading = false);
    }
  }

  Future<bool> acceptReject(
      {required String status,
      required String? id,
      required Data? bookingData}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.token) ?? "";

    try {
      final headers = {'Authorization': 'Bearer $token'};
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.baseUrl}/api/v3/seller/services/update_booking_status'),
      );

      request.fields.addAll({'booking_id': id ?? '', 'status': status});
      request.headers.addAll(headers);

      final response = await request.send();
      if (response.statusCode == 200) {
        log(await response.stream.bytesToString());

        Data? bData = bookingData!;

        // await Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => BookingDetailsScreen(
        //       bookingData: bData,
        //       status: int.parse(status),
        //     ),
        //   ),
        // );
        await getBookingHistory();
        return true;
      } else {
        log('Error: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      log('Exception occurred: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated('My Booking', context),
        isBackButtonExist: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : bookingServiceList == null ||
                      bookingServiceList?.data.isEmpty == true
                  ? const Center(child: Text('No booking found'))
                  : ListView.builder(
                      itemCount: bookingServiceList?.data.length ?? 0,
                      itemBuilder: (context, index) {
                        final booking = bookingServiceList?.data[index];

                        return InkWell(
                          onTap: () async {
                            if (bookingServiceList?.data[index].status == 1 ||
                                bookingServiceList?.data[index].status == 2) {
                              // await Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => BookingDetailsScreen(
                              //       bookingData:
                              //           bookingServiceList?.data[index],
                              //       status: bookingServiceList
                              //               ?.data[index].status ??
                              //           1,
                              //     ),
                              //   ),
                              // );
                              getBookingHistory();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blue),
                                color: Colors.grey.withOpacity(0.2)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            margin: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: DetailRow(
                                        label: "Name",
                                        value: booking?.patientName ?? '',
                                        isRequired: false),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DetailRow(
                                          label: "Number",
                                          value: booking?.patientMobile ?? '',
                                          isRequired: false),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      DetailRow(
                                          label: "Email",
                                          value: booking?.patientEmail ?? '',
                                          isRequired: false),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      DetailRow(
                                          label: "Address",
                                          value: booking?.googleAddress ?? '',
                                          isRequired: false),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                if (booking?.status == 1)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: const Text("Status: Accepted",
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 16)),
                                  )
                                else if (booking?.status == 2)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: const Text("Status: Completed",
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 16)),
                                  )
                                else if (booking?.status == 4)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: const Text("Status: Cancelled",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 16)),
                                  )
                                else
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          showConfirmationDialog(
                                              context: context,
                                              title: 'Accept Booking',
                                              message:
                                                  'Are you sure you want to accept this booking?',
                                              onConfirm: () async {
                                                var result = await acceptReject(
                                                    status: "1",
                                                    id: booking?.id.toString(),
                                                    bookingData:
                                                        bookingServiceList
                                                            ?.data[index]);
                                              });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        child: const Text('Accept',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          showConfirmationDialog(
                                            context: context,
                                            title: 'Cancel Booking',
                                            message:
                                                'Are you sure you want to cancel this booking?',
                                            onConfirm: () => acceptReject(
                                                status: "4",
                                                id: booking?.id.toString(),
                                                bookingData: bookingServiceList
                                                    ?.data[index]),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        child: const Text('Cancel',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
