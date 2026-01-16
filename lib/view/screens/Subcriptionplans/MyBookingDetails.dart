import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/data/model/response/booking_model.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/globles.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/MyBookingModel.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/widget.dart';
import 'package:sixvalley_vendor_app/widgets/app_dropdown.dart';
import 'package:sixvalley_vendor_app/widgets/booking_detail_card.dart';
import '../../../provider/splash_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../../utill/styles.dart';
import '../Service/RescheduleModel.dart';
import 'app_token_data.dart';

class BookingDetailsScreen extends StatefulWidget {
  final BookingData? bookingData;
  final int status;

  const BookingDetailsScreen(
      {Key? key, required this.bookingData, required this.status})
      : super(key: key);

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool _isLoading = false;

  String? paymentStatus;
  String? bookingStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentStatus = widget.bookingData?.isPaid == 1 ? "Paid" :'Unpaid';
    bookingStatus =
    widget.bookingData?.status == 0
        ? 'Pending': widget.bookingData?.status == 1
           ? 'Confirm': widget.bookingData?.status == 2
              ? 'Completed': widget.bookingData?.status == 4
                 ? 'Cancelled' : 'Re-scheduled';
  }
  @override
  Widget build(BuildContext context) {
    final booking = widget.bookingData;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Booking Details",
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                    ),
                    items: List<String>.from(json.decode(widget.bookingData?.service?.images ?? '[]'))
                        .map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Card(
                            elevation: 7,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              // decoration: BoxDecoration(color: Colors.amber),
                              child: Image.network(
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${url}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  bookingDetail(),
                  customerDetail(),
                  summary(),
                   statusAndPayment()



                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Text(
                          getStatusText(widget.status ?? 0),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: booking?.status == 4
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.bookingData?.patientName ?? '',
                    style: robotoRegular.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.black,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Text(widget.bookingData?.googleAddress ?? '',
                            style: robotoRegular.copyWith(
                                fontSize: 16, color: Colors.grey)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Booking Details',
                    style: robotoRegular.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.black,
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Seller Profile Picture
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholderImage,
                                  height: Dimensions.imageSize,
                                  width: Dimensions.imageSize,
                                  fit: BoxFit.cover,
                                  image:
                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.sellerImageUrl}/${widget.bookingData?.images ?? ''}',
                                  imageErrorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.asset(
                                    Images.placeholderImage,
                                    height: Dimensions.imageSize,
                                    width: Dimensions.imageSize,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              // Seller Name
                              Expanded(
                                child: Text(
                                  '${widget.bookingData?.patientName ?? ''}',
                                  style: robotoRegular.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15), // Add spacing

                          // Seller Phone
                          Row(
                            children: [
                              Icon(Icons.phone,
                                  color: ColorResources.primaryMaterial,
                                  size: 20),
                              SizedBox(width: 10),
                              Text(
                                '${widget.bookingData?.patientMobile ?? '' ?? 'N/A'}',
                                style: robotoRegular.copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.email_outlined,
                                  color: ColorResources.primaryMaterial,
                                  size: 20),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${widget.bookingData?.patientEmail ?? '' ?? 'N/A'}',
                                  style: robotoRegular.copyWith(fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () => _updateBookingStatus(
                                  status: "2",
                                  id: booking!.id.toString(),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: const Text(
                                    "Complete",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              isLoading == true
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 35.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        final shouldReschedule =
                                            await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Confirmation"),
                                              content: const Text(
                                                  "Are you sure you want to reschedule?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context,
                                                        false); // Cancel
                                                  },
                                                  child: const Text("No"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, true); // Yes
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (shouldReschedule == true) {
                                          showDatePickerPopup();
                                          // _rescheduleBooking(
                                          //   bookingdate: '2024-12-25',
                                          //   slotid: '4',
                                          //   id: booking!.id.toString(),
                                          // );
                                        } else {
                                          print("Reschedule canceled by user.");
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: const Text(
                                          "Reschedule",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),*/
                ]
                )
              ,),),);
  }

 Widget bookingDetail() {
    return BookingCard(children: [


      const SizedBox(height: 6),

      /// Created Date
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
          Text(
            'Booking ID #${widget.bookingData?.bookingId}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(children: [
            Icon(Icons.calendar_today, size: 14),
            SizedBox(width: 6),
            Text( formatDate(widget.bookingData?.createdAt, format: 'dd MMM yyyy hh:mm a'),
              style: TextStyle(fontSize: 13),
            ),
          ],)
        ],
      ),

      const SizedBox(height: 10),

      /// Booking Date And Time
      const Text(
        'Booking Date And Time',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),

      const SizedBox(height: 4),

      Row(
        children:  [
          Icon(Icons.calendar_today, size: 14),
          SizedBox(width: 6),
          Text(
            widget.bookingData?.bookingDatetime ?? '',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),

      const SizedBox(height: 10),

      /// Booking Slot
      const Text(
        'Booking Slot',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),

      const SizedBox(height: 4),

      Row(
        children:  [
          Icon(Icons.access_time, size: 14),
          SizedBox(width: 6),
          Text(
             '${widget.bookingData?.bookingTime} - ${widget.bookingData?.tillTime}',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),

      const SizedBox(height: 14),

      /// Status
      Row(
        children:  [
          SizedBox(
            width: 150,
            child: Text(
              'Status: ',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Text(
            getStatusText(widget.bookingData?.status ?? 0),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: getStatusColor(widget.bookingData?.status ?? 0),
            ),
          ),
        ],
      ),

      const SizedBox(height: 6),

      /// Payment Method
      Row(
        children: [
          SizedBox(
            width: 150,
            child: const Text(
              'Payment Method: ',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Text(
            widget.bookingData?.paymentMethod ?? '',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: getStatusColor(widget.bookingData?.status ?? 0),
            ),
          )
        ],
      ),

      const SizedBox(height: 6),

      /// Payment Status
      Row(
        children:  [
          SizedBox(
            width: 150,
            child: Text(
              'Payment Status: ',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Text(
           widget.bookingData?.isPaid == 1 ? 'Paid' :'UnPaid',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: widget.bookingData?.isPaid == 1 ? Colors.green :Colors.orange,
            ),
          ),
        ],
      ),
    ]);
  }

Widget customerDetail() {
    return BookingCard(children: [


      const SizedBox(height: 6),
      Row(
        children:  [
          Icon(Icons.person, size: 16),
          SizedBox(width: 10,),
          Text(
            'Customer Information',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
                 ],
      ),

      const SizedBox(height: 20),

      /// Booking Date And Time
      Row(
        children:  [
          SizedBox(
            width: 150,
            child: Text(
              'Name: ',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Text(
            '${widget.bookingData?.user?.fName}${widget.bookingData?.user?.lName}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: getStatusColor(widget.bookingData?.status ?? 0),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),

      Row(
        children:  [
          SizedBox(
            width: 150,
            child: Text(
              'Mobile: ',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Text(
            '${widget.bookingData?.user?.phone}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: getStatusColor(widget.bookingData?.status ?? 0),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),

      Row(
        children:  [
          SizedBox(
            width: 150,
            child: Text(
              'Email: ',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Text(
            '${widget.bookingData?.user?.email}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: getStatusColor(widget.bookingData?.status ?? 0),
            ),
          ),
        ],
      ),
    ]);
  }

  Widget summary() {
    return BookingCard(children: [


      const SizedBox(height: 6),
      Row(
        children:  [

          Text(
            'Booking Summary',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),

      const SizedBox(height: 20),

      /// Booking Date And Time
      Row(
        children:  [
          SizedBox(
            width: 150,
            child: Text(
              'Booking Name: ',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Text(
            '${widget.bookingData?.patientName}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: getStatusColor(widget.bookingData?.status ?? 0),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),

      Row(
        children:  [
          SizedBox(
            width: 150,
            child: Text(
              'Booking Mobile: ',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Text(
            '${widget.bookingData?.patientMobile}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: getStatusColor(widget.bookingData?.status ?? 0),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),

      Row(
        children:  [
          SizedBox(
            width: 150,
            child: Text(
              'Booking Email: ',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Text(
            '${widget.bookingData?.patientEmail}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: getStatusColor(widget.bookingData?.status ?? 0),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),

      Row(
        children:  [
          SizedBox(
            width: 150,
            child: Text(
              'Final Total: ',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Text(
            '₹${widget.bookingData?.paidAmount}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: getStatusColor(widget.bookingData?.status ?? 0),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),

      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          SizedBox(
            width: 150,
            child: Text(
              'Address: ',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              '${widget.bookingData?.googleAddress}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: getStatusColor(widget.bookingData?.status ?? 0),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),

      Row(
        children:  [
          Text(
            'Note: ',
            style: TextStyle(fontSize: 13),
          ),
          Text(
            '',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: getStatusColor(widget.bookingData?.status ?? 0),
            ),
          ),
        ],
      ),
    ]);
  }

  Widget statusAndPayment(){
    
    return Consumer<OrderProvider>(builder: (context, provider, child) {
      return BookingCard(children: [
        Text(
          'Booking Info',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20,),
        Row(children: [
          Expanded(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking Status',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                SizedBox(height: 6,),
                AppDropdown<String>(
                    margin: EdgeInsets.all(0),
                    items: ['Pending','Confirm','Completed','Re-scheduled', 'Cancelled'], value: bookingStatus, onChanged: (value){

                      if(value !=null){

                        String status = value=='Pending' ? '0' : value=='Confirm'? '1': value=='Completed'? '2' : value=='Completed'? '4' : '3';
                        provider.updateBookingStatus(widget.bookingData?.id, status, context, provider.orderType);

                        setState(() {
                          bookingStatus = value ;
                        });

                      }


                }),
              ],),
          ),
          SizedBox(width: 8,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Payment Status',
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault)),
                SizedBox(height: 6,),
                AppDropdown<String>(
                    margin: EdgeInsets.all(0),
                    items: ['Paid','Unpaid'], value: paymentStatus, onChanged: (value){

                      if(value!=null){
                        provider.updateBookingPaymentStatus(widget.bookingData?.id, value =='Paid'? '1':'0', context, provider.orderType);
                        setState(() {
                          paymentStatus = value ;
                        });
                      }else {

                      }



                })
              ],),
          )
        ],)
      ]) ;
    },);
    
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "Confirm";
      case 2:
        return "Completed";
      case 4:
        return "Cancelled";
      default:
        return "Pending";
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  DateTime? selectedDate;
  List<String> timeSlots = [];
  String? selectedTimeSlot;
  bool isLoading = false;

  Future<RescheduleModel?> fetchTimeSlots(DateTime date) async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.token) ?? "";
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppConstants.baseUrl}/api/v3/seller/services/get_timeslots',
        ),
      );
      request.fields.addAll({
        'service_id': widget.bookingData!.serviceId.toString(),
        'date': formattedDate,
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var result = await response.stream.bytesToString();
        print(result);
        final rescheduleModel = RescheduleModel.fromJson(json.decode(result));

        showDialog(
          context: context,
          builder: (context) {
            return timeSlotListPopup(rescheduleModel);
          },
        );
        setState(() {
          isLoading = false;
        });
        print("Success: ${rescheduleModel.toString()}");
        return rescheduleModel;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Something went wrong')));
        return null;
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
      return null;
    }
  }

  void showDatePickerPopup() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        selectedTimeSlot = null;
        timeSlots = [];
      });

      await fetchTimeSlots(pickedDate);
    }
  }

  Widget timeSlotListPopup(RescheduleModel? rescheduleModel) {
    return rescheduleModel == null
        ? SimpleDialog(
            children: [
              Center(
                child: text('No Time Slot Available'),
              ),
            ],
          )
        : SimpleDialog(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: text(
                    'Please Select Time Slot',
                    textColor: Colors.black,
                    fontSize: 20.0,
                  )),
              Divider(
                color: Colors.black,
              ),
              _isLoading == true
                  ? CircularProgressIndicator()
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: ListView.builder(
                        itemCount: rescheduleModel!.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _rescheduleBooking(
                                bookingdate: selectedDate ?? DateTime.now(),
                                id: widget.bookingData!.id.toString(),
                                slotid: rescheduleModel.data[index].slotId
                                    .toString(),
                              );
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              color: Colors.blue.shade100,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  text('From:', textColor: Colors.black),
                                  text(
                                      rescheduleModel!.data[index].fromTime ??
                                          '',
                                      textColor: Colors.black),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  text('To:', textColor: Colors.black),
                                  text(
                                      rescheduleModel!.data[index].toTime ?? '',
                                      textColor: Colors.black)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
            ],
          );
  }

  Future<void> _rescheduleBooking({
    required DateTime bookingdate,
    required String slotid,
    required String id,
  }) async {
    setState(() => _isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.token) ?? "";
      final formattedDate = DateFormat('yyyy-MM-dd').format(bookingdate);
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppConstants.baseUrl}/api/v3/seller/services/reschedule_service',
        ),
      );

      request.fields.addAll({
        'booking_date': formattedDate,
        'slot_id': slotid,
        'booking_id': id,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var result = await response.stream.bytesToString();
        print("Reschedule Success: $result");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Reschedule Success')));
      } else {
        var errorMessage = await response.stream.bytesToString();
        print("Error: $errorMessage");
        _showError(
            "Failed to reschedule booking. Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
      _showError("An error occurred: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateBookingStatus(
      {required String status, String? id}) async {
    setState(() => _isLoading = true);

    try {
      var userId = await MyToken.getUserID();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.token) ?? "";

      var headers = {'Authorization': 'Bearer $token'};
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppConstants.baseUrl}/api/v3/seller/services/update_booking_status',
        ),
      );
      request.fields.addAll({'booking_id': id ?? '', 'status': status});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var reslut = await response.stream.bytesToString();
        print(reslut);
        Navigator.pop(context);
      } else {
        _showError("Failed to update booking status.");
      }
    } catch (e) {
      _showError("An error occurred: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String? value;
  final Color? valueColor;
  final bool isRequired;

  const DetailRow(
      {Key? key,
      required this.label,
      required this.value,
      this.valueColor,
      required this.isRequired})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: isRequired == true
              ? Border.all(
                  color: Colors.grey,
                )
              : null,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 5,
            child: Text(
              value ?? "N/A",
              style: TextStyle(color: valueColor ?? Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
