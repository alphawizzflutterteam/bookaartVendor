// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:sixvalley_vendor_app/view/screens/Service/vendor_service_model.dart';
// import 'package:sizer/sizer.dart';
//
// import 'package:http/http.dart' as http;
//
// import '../../../utill/app_constants.dart';
// import '../Subcriptionplans/app_token_data.dart';
// import '../Subcriptionplans/utility_hlepar.dart';
// import 'AddService.dart';
// import 'RemoveServiceModel.dart';
// import 'alert.dart';
// import 'alert_style.dart';
// import 'colors.dart';
// import 'dialog_button.dart';
// import 'edit_services.dart';
//
// class ManageService extends StatefulWidget {
//   const ManageService({
//     Key? key,
//   }) : super(key: key);
//   // final GetProfileResponse? profileResponse;
//   @override
//   State<ManageService> createState() => _ManageServiceState();
// }
//
// class _ManageServiceState extends State<ManageService> {
//   TextEditingController onpenTime = new TextEditingController();
//   TextEditingController imageC = new TextEditingController();
//   TextEditingController closeTime = new TextEditingController();
//   TextEditingController serviceCharge = new TextEditingController();
//   TextEditingController serviceName = new TextEditingController();
//   TextEditingController serviceIssue = new TextEditingController();
//   TextEditingController descriptionController = new TextEditingController();
//   TextEditingController servicePrice = new TextEditingController();
//   GlobalKey<FormState> _formKey = GlobalKey();
//
//   bool buttonLogin = false;
//   String? selectedCategory, selectSubCategory, selectChildCategory, selectModel;
//   double perMinServiceCharge = 0.0;
//   String? visitingCharge;
//   String? issue;
//   List serviceTypeId = [];
//   List specilizationTypeId = [];
//   String finalCharges = "0";
//   var servicePic;
//   var storeId;
//   DateTime dateTimeSelected = DateTime.now();
//   String showImage = '';
//   String service_price = "";
//   String service_name = "";
//   bool _switchValue = true;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     Future.delayed(Duration(milliseconds: 200), () {
//       return getVendorAllServices();
//     });
//   }
//
//   Future _refresh() async {
//     await Future.delayed(Duration(milliseconds: 1000));
//     return getVendorAllServices();
//   }
//
//   activeDeactiveService(String serviceid, String status) async {
//     var headers = {
//       'Cookie': 'ci_session=5d20c59aa4198d23adadefd0d956a319531a4aca'
//     };
//     var request = http.MultipartRequest(
//         'POST', Uri.parse('${AppConstants.baseUrl}vendor_service_status'));
//     request.fields
//         .addAll({'service_id': '${serviceid}', 'status': '${status}'});
//
//     request.headers.addAll(headers);
//     print('_________this${request.fields}_______');
//     http.StreamedResponse response = await request.send();
//     var data = jsonDecode("${await response.stream.bytesToString()}");
//     if (response.statusCode == 200) {
//       Fluttertoast.showToast(msg: "${data["msg"]}");
//     } else {
//       print(response.reasonPhrase);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//         title: Text(
//           "Manage Service",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => AddServicesScreen(
//                       // profileResponse: widget.profileResponse,
//                       ))).then((value) {
//             Future.delayed(Duration(milliseconds: 200), () {
//               return getVendorAllServices();
//             });
//           });
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: RefreshIndicator(
//             onRefresh: _refresh,
//             child: AnimatedContainer(
//               duration: Duration(milliseconds: 1000),
//               curve: Curves.easeInOut,
//               width: 100,
//               // decoration: BoxDecoration(
//               //   gradient: RadialGradient(
//               //     center: Alignment(0.0, -0.5),
//               //     colors: [
//               //       AppColor().colorBg1(),
//               //       AppColor().colorBg1(),
//               //     ],
//               //     radius: 0.8,
//               //   ),
//               // ),
//               padding: MediaQuery.of(context).viewInsets,
//               child: Column(
//                 children: [
//                   // Container(
//                   //   height: 9.92.h,
//                   //   width: 100.w,
//                   //   decoration: BoxDecoration(
//                   //       image: DecorationImage(
//                   //     image: AssetImage(profileBg),
//                   //     fit: BoxFit.fill,
//                   //   )),
//                   //   child: Center(
//                   //     child: Row(
//                   //       crossAxisAlignment: CrossAxisAlignment.center,
//                   //       children: [
//                   //         Container(
//                   //             width: 6.38.w,
//                   //             height: 6.38.w,
//                   //             alignment: Alignment.centerLeft,
//                   //             margin: EdgeInsets.only(left: 7.91.w),
//                   //             child: InkWell(
//                   //                 onTap: () {
//                   //                   Navigator.pop(context);
//                   //                 },
//                   //                 child: Image.asset(
//                   //                   back,
//                   //                   height: 4.0.h,
//                   //                   width: 8.w,
//                   //                 ))),
//                   //         SizedBox(
//                   //           width: 2.08.h,
//                   //         ),
//                   //         Container(
//                   //           width: 65.w,
//                   //           child: text(
//                   //             "Service List",
//                   //             textColor: Color(0xffffffff),
//                   //             fontSize: 14.sp,
//                   //             fontFamily: fontMedium,
//                   //             isCentered: true,
//                   //           ),
//                   //         ),
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                   SizedBox(
//                     height: 2.02,
//                   ),
//                   vendorServiceModel == null
//                       ? Center(
//                           child: Image.asset(
//                             "images/icons/loader.gif",
//                             // height: 500,
//                           ),
//                         )
//                       : vendorServiceModel!.restaurants!.length == 0
//                           ? Center(child: Text("No service to show"))
//                           : ListView.builder(
//                               shrinkWrap: true,
//                               physics: ClampingScrollPhysics(),
//                               itemCount:
//                                   vendorServiceModel!.restaurants!.length,
//                               itemBuilder: (context, index) {
//                                 return Card(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   margin: EdgeInsets.all(10.0),
//                                   child: Column(
//                                     children: [
//                                       ListTile(
//                                         leading: Container(
//                                           width: 100,
//                                           // height: 200,
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(10.0),
//                                             child: vendorServiceModel!
//                                                             .restaurants![index]
//                                                             .logo ==
//                                                         "" ||
//                                                     vendorServiceModel!
//                                                         .restaurants![index]
//                                                         .logo!
//                                                         .isEmpty
//                                                 ? Image.asset(
//                                                     "images/antsLogo.png")
//                                                 : Image.network(
//                                                     "${vendorServiceModel!.restaurants![index].logo![0].toString()}",
//                                                     fit: BoxFit.cover,
//                                                     width: 100,
//                                                     height: 200,
//                                                   ),
//                                           ),
//                                         ),
//                                         title: Text(
//                                           "${vendorServiceModel!.restaurants![index].resName}",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                         subtitle: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             SizedBox(
//                                               height: 8.0,
//                                             ),
//                                             Text(
//                                                 "${vendorServiceModel!.restaurants![index].cName}"),
//                                             SizedBox(
//                                               height: 5.0,
//                                             ),
//                                             Text(
//                                                 "₹ ${vendorServiceModel!.restaurants![index].price}"),
//                                             SizedBox(
//                                               height: 5.0,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 // Text.rich(
//                                                 //     TextSpan(children: [
//                                                 //       WidgetSpan(
//                                                 //           child: Icon(
//                                                 //             Icons
//                                                 //                 .watch_later_outlined,
//                                                 //             size: 15,
//                                                 //           )),
//                                                 //       TextSpan(
//                                                 //           text:
//                                                 //           " ${vendorModel.restaurants![index].hours}"),
//                                                 //     ])),
//                                                 Text.rich(TextSpan(children: [
//                                                   WidgetSpan(
//                                                       child: Icon(
//                                                     Icons.star,
//                                                     color: vendorServiceModel!
//                                                                 .restaurants![
//                                                                     index]
//                                                                 .reviewCount! >
//                                                             0
//                                                         ? Colors.yellow
//                                                         : Colors.grey,
//                                                     size: 15,
//                                                   )),
//                                                   TextSpan(
//                                                       text:
//                                                           " ${vendorServiceModel!.restaurants![index].reviewCount}"),
//                                                 ])),
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 5.0,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Divider(
//                                         indent: 15.0,
//                                         endIndent: 15.0,
//                                         thickness: 1.0,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         children: [
//                                           // TextButton.icon(
//                                           //   onPressed: () async {
//                                           //     //print(vendorServiceModel!.restaurants![index].type?.first.service,);
//                                           //     bool result =
//                                           //         await Navigator.push(
//                                           //             context,
//                                           //             MaterialPageRoute(
//                                           //                 builder:
//                                           //                     (context) =>
//                                           //                         EditServices(
//                                           //                           city: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .cityId,
//                                           //                           country: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .countryId,
//                                           //                           state: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .stateId,
//                                           //                           logo: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .logo,
//                                           //                           serviceName: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .resName,
//                                           //                           catId: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .catId,
//                                           //                           serviceCharge: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .price,
//                                           //
//                                           //                           addOntype: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .type,
//                                           //                           //  adddOnservice: vendorServiceModel!.restaurants![index].type?.first.service??"",
//                                           //                           //  hour: vendorServiceModel!.restaurants![index].type!.first.hrly??"",
//                                           //                           //  dayHour: vendorServiceModel!.restaurants![index].type!.first.daysHrs??"",
//                                           //                           // addOnPrice: vendorServiceModel!.restaurants![index].type!.first.priceA??"",
//                                           //                           //   serviceTime: vendorModel.restaurants![index].hours,
//                                           //                           subCatId: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .scatId,
//                                           //                           serviceId: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .resId,
//                                           //                           serviceImage: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .logo,
//                                           //                           subName: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .subCat,
//                                           //                           serviceDescription: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .resDesc,
//                                           //                           childName: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .cName,
//                                           //                           currency: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .baseCurrency,
//                                           //                           servicesOffered: vendorServiceModel!
//                                           //                               .restaurants![
//                                           //                                   index]
//                                           //                               .serviceOffered,
//                                           //                           // experts: vendorModel.restaurants![index].experts,
//                                           //                         )
//                                           //             )
//                                           //         );
//                                           //     if (result == true) {
//                                           //       setState(() {
//                                           //         CircularProgressIndicator();
//                                           //         getVendorAllServices();
//                                           //       });
//                                           //     }
//                                           //   },
//                                           //   icon: Icon(Icons.edit_note_outlined,
//                                           //       size: 18),
//                                           //   label: Text("Edit Service"),
//                                           //   style: TextButton.styleFrom(
//                                           //       foregroundColor: Colors.green,
//                                           //       shape: RoundedRectangleBorder(
//                                           //           borderRadius:
//                                           //               BorderRadius.circular(
//                                           //                   9),
//                                           //           side: BorderSide(
//                                           //               color: Colors.green))),
//                                           // ),
//                                           // TextButton.icon(
//                                           //   onPressed: () async {
//                                           //     Alert(
//                                           //       context: context,
//                                           //       title: "Delete Service",
//                                           //       desc:
//                                           //           "Are you sure you want to delete service?",
//                                           //       style: AlertStyle(
//                                           //         isCloseButton: false,
//                                           //         descStyle: TextStyle(
//                                           //             fontFamily: "MuliRegular",
//                                           //             fontSize: 15),
//                                           //         titleStyle: TextStyle(
//                                           //             fontFamily:
//                                           //                 "MuliRegular"),
//                                           //       ),
//                                           //       buttons: [
//                                           //         DialogButton(
//                                           //           child: Text(
//                                           //             "OK",
//                                           //             style: TextStyle(
//                                           //                 color: Colors.white,
//                                           //                 fontSize: 16,
//                                           //                 fontFamily:
//                                           //                     "MuliRegular"),
//                                           //           ),
//                                           //           onPressed: () async {
//                                           //             RemoveServiceModel?
//                                           //                 removeModel =
//                                           //                 await removeServices(
//                                           //                     vendorServiceModel!
//                                           //                         .restaurants![
//                                           //                             index]
//                                           //                         .resId);
//                                           //             if (removeModel!
//                                           //                     .responseCode ==
//                                           //                 "1") {
//                                           //               UtilityHlepar.getToast(
//                                           //                   "Service Deleted Successfully!");
//                                           //               setState(() {
//                                           //                 CircularProgressIndicator();
//                                           //                 getVendorAllServices();
//                                           //               });
//                                           //               Navigator.pop(context);
//                                           //             }
//                                           //           },
//                                           //           color: AppColor.PrimaryDark,
//                                           //         ),
//                                           //         DialogButton(
//                                           //           child: Text(
//                                           //             "Cancel",
//                                           //             style: TextStyle(
//                                           //                 color: Colors.white,
//                                           //                 fontSize: 16,
//                                           //                 fontFamily:
//                                           //                     "MuliRegular"),
//                                           //           ),
//                                           //           onPressed: () {
//                                           //             Navigator.of(context,
//                                           //                     rootNavigator:
//                                           //                         true)
//                                           //                 .pop();
//                                           //           },
//                                           //           color: AppColor.PrimaryDark,
//                                           //         ),
//                                           //       ],
//                                           //     ).show();
//                                           //   },
//                                           //
//                                           //   // onPressed: () async {
//                                           //   //   RemoveServiceModel?
//                                           //   //   removeModel = await removeServices(
//                                           //   //       vendorServiceModel!
//                                           //   //           .restaurants![index].resId);
//                                           //   //   if (removeModel!.responseCode == "1") {
//                                           //   //     UtilityHlepar.getToast(
//                                           //   //         "Service Deleted Successfully!");
//                                           //   //     setState(() {
//                                           //   //       CircularProgressIndicator();
//                                           //   //       getVendorAllServices();
//                                           //   //     });
//                                           //   //   }
//                                           //   // },
//                                           //   icon: Icon(Icons.delete_rounded,
//                                           //       size: 18),
//                                           //   label: Text("Delete"),
//                                           //   style: TextButton.styleFrom(
//                                           //       foregroundColor:
//                                           //           AppColor.PrimaryDark,
//                                           //       shape: RoundedRectangleBorder(
//                                           //           borderRadius:
//                                           //               BorderRadius.circular(
//                                           //                   9),
//                                           //           side: BorderSide(
//                                           //               color: AppColor
//                                           //                   .PrimaryDark))),
//                                           // ),
//                                         ],
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 20),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             CupertinoSwitch(
//                                               // thumbColor: Colors.red,
//                                               trackColor: Colors.red,
//                                               value: enablelist[index] == "0"
//                                                   ? false
//                                                   : true,
//
//                                               onChanged: (value) async {
//                                                 enablelist[index] =
//                                                     value == true ? "1" : "0";
//                                                 setState(() {});
//                                                 activeDeactiveService(
//                                                     "${vendorServiceModel?.restaurants?[index].resId}",
//                                                     "${enablelist[index]}");
//                                                 getVendorAllServices();
//                                               },
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Icon(Icons.location_on_rounded),
//                                                 Text(
//                                                   "${vendorServiceModel?.restaurants?[index].cityName}",
//                                                   maxLines: 1,
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                   // FutureBuilder(
//                   //     future: getVendorAllServices(),
//                   //     builder: (BuildContext context, AsyncSnapshot snapshot) {
//                   //       VendorServiceModel vendorModel = snapshot.data;
//                   //       //print("checking error ${snapshot.hasError} and ${snapshot.error}");
//                   //       if (snapshot.hasData) {
//                   //         return vendorModel.status == 1
//                   //             ? Container(
//                   //           child: ListView.builder(
//                   //             shrinkWrap: true,
//                   //             physics: ClampingScrollPhysics(),
//                   //             itemCount: vendorModel.restaurants!.length,
//                   //             itemBuilder: (context, index) {
//                   //               return Card(
//                   //                 shape: RoundedRectangleBorder(
//                   //                   borderRadius:
//                   //                   BorderRadius.circular(10.0),
//                   //                 ),
//                   //                 margin: EdgeInsets.all(10.0),
//                   //                 child: Column(
//                   //                   children: [
//                   //                     ListTile(
//                   //                       leading: Container(
//                   //                         width: 100,
//                   //                         // height: 200,
//                   //                         child: ClipRRect(
//                   //                           borderRadius:
//                   //                           BorderRadius.circular(10.0),
//                   //                           child: vendorModel.restaurants![index].logo == ""
//                   //                               ? Image.asset(
//                   //                               "images/Placeholder.png")
//                   //                               : Image.network(
//                   //                             "${vendorModel.restaurants![index].logo![0].toString()}",
//                   //                             fit: BoxFit.cover,
//                   //                             width: 100,
//                   //                             height: 200,
//                   //                           ),
//                   //                         ),
//                   //                       ),
//                   //                       title: Text(
//                   //                         "${vendorModel.restaurants![index].resName}",
//                   //                         style: TextStyle(
//                   //                             fontWeight: FontWeight.bold,
//                   //                             fontSize: 16),
//                   //                       ),
//                   //                       subtitle: Column(
//                   //                         crossAxisAlignment:
//                   //                         CrossAxisAlignment.start,
//                   //                         children: [
//                   //                           SizedBox(
//                   //                             height: 8.0,
//                   //                           ),
//                   //                           Text(
//                   //                               "${vendorModel.restaurants![index].cName}"),
//                   //                           SizedBox(
//                   //                             height: 5.0,
//                   //                           ),
//                   //                           Text(
//                   //                               "₹ ${vendorModel.restaurants![index].price}"),
//                   //                           SizedBox(
//                   //                             height: 5.0,
//                   //                           ),
//                   //                           Row(
//                   //                             mainAxisAlignment:
//                   //                             MainAxisAlignment
//                   //                                 .spaceBetween,
//                   //                             children: [
//                   //                               // Text.rich(
//                   //                               //     TextSpan(children: [
//                   //                               //       WidgetSpan(
//                   //                               //           child: Icon(
//                   //                               //             Icons
//                   //                               //                 .watch_later_outlined,
//                   //                               //             size: 15,
//                   //                               //           )),
//                   //                               //       TextSpan(
//                   //                               //           text:
//                   //                               //           " ${vendorModel.restaurants![index].hours}"),
//                   //                               //     ])),
//                   //                               Text.rich(
//                   //                                   TextSpan(children: [
//                   //                                     WidgetSpan(
//                   //                                         child: Icon(
//                   //                                           Icons.star,
//                   //                                           color: Colors.yellow,
//                   //                                           size: 15,
//                   //                                         )),
//                   //                                     TextSpan(text:
//                   //                                     " ${vendorModel.restaurants![index].reviewCount}"),
//                   //                                   ])),
//                   //                             ],
//                   //                           ),
//                   //                           SizedBox(
//                   //                             height: 5.0,
//                   //                           ),
//                   //                         ],
//                   //                       ),
//                   //                     ),
//                   //                     Divider(
//                   //                       indent: 15.0,
//                   //                       endIndent: 15.0,
//                   //                       thickness: 1.0,
//                   //                     ),
//                   //                     Row(
//                   //                       mainAxisAlignment:
//                   //                       MainAxisAlignment.spaceAround,
//                   //                       children: [
//                   //                         TextButton.icon(
//                   //                           onPressed: () async{
//                   //                             bool result = await Navigator.push(
//                   //                                 context,
//                   //                                 MaterialPageRoute(
//                   //                                     builder: (context) => EditServices(
//                   //                                       city: vendorModel.restaurants![index].cityId,
//                   //                                       country: vendorModel.restaurants![index].countryId,
//                   //                                       state: vendorModel.restaurants![index].stateId,
//                   //                                       logo: vendorModel.restaurants![index].logo,
//                   //                                       serviceName: vendorModel.restaurants![index].resName,
//                   //                                       catId: vendorModel.restaurants![index].catId,
//                   //                                       serviceCharge: vendorModel.restaurants![index].price,
//                   //                                       // serviceTime: vendorModel.restaurants![index].hours,
//                   //                                       subCatId: vendorModel.restaurants![index].scatId,
//                   //                                       serviceId: vendorModel.restaurants![index].resId,
//                   //                                       serviceImage: vendorModel.restaurants![index].logo,
//                   //                                       subName: vendorModel.restaurants![index].subCat,
//                   //                                       serviceDescription: vendorModel.restaurants![index].resDesc,
//                   //                                       childName: vendorModel.restaurants![index].cName,
//                   //                                       // experts: vendorModel.restaurants![index].experts,
//                   //                                     )));
//                   //                             if(result == true){
//                   //                               setState(() {
//                   //                                 CircularProgressIndicator();
//                   //                                 getVendorAllServices();
//                   //                               });
//                   //                             }
//                   //                           },
//                   //                           icon: Icon(
//                   //                               Icons.edit_note_outlined,
//                   //                               size: 18),
//                   //                           label: Text("Edit Service"),
//                   //                           style: TextButton.styleFrom(
//                   //                               primary: AppColor()
//                   //                                   .colorPrimaryDark()),
//                   //                         ),
//                   //                         TextButton.icon(
//                   //                           onPressed: () async {
//                   //                             RemoveServiceModel?
//                   //                             removeModel =
//                   //                             await removeServices(
//                   //                                 vendorModel
//                   //                                     .restaurants![index].resId);
//                   //                             if (removeModel!.responseCode == "1") {
//                   //                               UtilityHlepar.getToast(
//                   //                                   "Service Deleted Successfully!");
//                   //                               setState(() {
//                   //                                 CircularProgressIndicator();
//                   //                                 getVendorAllServices();
//                   //                               });
//                   //                             }
//                   //                           },
//                   //                           icon: Icon(Icons.delete_rounded,
//                   //                               size: 18),
//                   //                           label: Text("Delete"),
//                   //                           style: TextButton.styleFrom(
//                   //                               primary: Colors.green),
//                   //                         ),
//                   //                       ],
//                   //                     ),
//                   //                   ],
//                   //                 ),
//                   //               );
//                   //             },
//                   //           ),
//                   //         )
//                   //             : Container(
//                   //           height: MediaQuery.of(context).size.height/1.5,
//                   //               child: Center(
//                   //           child: Text("No Services Found"),
//                   //         ),
//                   //             );
//                   //       } else if (snapshot.hasError) {
//                   //         return Icon(Icons.error_outline);
//                   //       } else {
//                   //         return Container(
//                   //             height: MediaQuery.of(context).size.height/1.5,
//                   //             child: Center(child: Image.asset("images/icons/loader.gif")));
//                   //       }
//                   //     }),
//                   SizedBox(
//                     height: 4.02,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   VendorServiceModel? vendorServiceModel;
//   List enablelist = [];
//
//   Future getVendorAllServices() async {
//     // var userId = await MyToken.getUserID();
//     // print("usre id here ${userId}");
//     // var request = http.MultipartRequest('POST', Uri.parse('${Apipath.BASH_URL}get_cat_res'));
//     // request.fields.addAll({
//     //   'vid': '$userId'
//     // });
//     //
//     // http.StreamedResponse response = await request.send();
//     //       print("chcking response code ${response.statusCode}");
//     // if (response.statusCode == 200) {
//     //   final str = await response.stream.bytesToString();
//     //   return VendorServiceModel.fromJson(json.decode(str));
//     // }
//     // else {
//     //   return null;
//     // }
//     var userId = await MyToken.getUserID();
//     var headers = {
//       'Cookie': 'ci_session=a0fad83c35b72f9b6b96e4fc773d876b8d6ca021'
//     };
//     var request = http.MultipartRequest(
//         'POST', Uri.parse(AppConstants.baseUrl + 'get_cat_res'));
//     request.fields.addAll({'vid': '${userId}', 'type': "vendor"});
//     print("checking api with parameter here ${request.fields} and $request");
//     request.headers.addAll(headers);
//     http.StreamedResponse response = await request.send();
//     if (response.statusCode == 200) {
//       var finalResult = await response.stream.bytesToString();
//       //return VendorServiceModel.fromJson(json.decode(finalResult));
//       final jsonResult = VendorServiceModel.fromJson(json.decode(finalResult));
//       if (jsonResult.restaurants?.isNotEmpty ?? false) {
//         for (int i = 0; i < jsonResult.restaurants!.length; i++) {
//           enablelist.add("${jsonResult.restaurants?[i].status}");
//           print("${jsonResult.restaurants?[i].status}");
//         }
//       }
//       setState(() {
//         vendorServiceModel = jsonResult;
//       });
//     } else {
//       print(response.reasonPhrase);
//     }
//   }
//
//   Future<RemoveServiceModel?> removeServices(id) async {
//     var request = http.MultipartRequest(
//         'POST', Uri.parse('${AppConstants.baseUrl}delete_restaurant'));
//     request.fields.addAll({'id': '$id'});
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       final str = await response.stream.bytesToString();
//       return RemoveServiceModel.fromJson(json.decode(str));
//     } else {
//       return null;
//     }
//   }
// }
// import 'package:flutter/material.dart';

// import 'AddService.dart';

// class ManageServicesScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         title: const Text('Manage Services'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8.0),
//                       child: Image.network(
//                         'https://via.placeholder.com/80', // Replace with actual image URL
//                         height: 80,
//                         width: 80,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             '123 service',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const Text(
//                             'Photographers',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 14,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           const Text(
//                             '₹ 1000',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Row(
//                             children: const [
//                               Icon(Icons.star, size: 16, color: Colors.grey),
//                               SizedBox(width: 4),
//                               Text(
//                                 '0',
//                                 style: TextStyle(fontSize: 14),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 // Edit and Delete Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         // Add your Edit action here
//                       },
//                       icon: const Icon(Icons.edit, color: Colors.green),
//                       label: const Text(
//                         'Edit Service',
//                         style: TextStyle(color: Colors.green),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         side: const BorderSide(color: Colors.green),
//                       ),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         // Add your Delete action here
//                       },
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       label: const Text(
//                         'Delete',
//                         style: TextStyle(color: Colors.red),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         side: const BorderSide(color: Colors.red),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 // Toggle and Location
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Switch(
//                       value: true, // Replace with your logic
//                       onChanged: (bool value) {
//                         // Add your toggle logic here
//                       },
//                       activeColor: Colors.green,
//                     ),
//                     Row(
//                       children: const [
//                         Icon(Icons.location_on, color: Colors.black54),
//                         SizedBox(width: 4),
//                         Text(
//                           'Pune',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddServicesScreen()),
//           );
//         },
//         backgroundColor: Colors.blueAccent,
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: ManageServicesScreen(),
//   ));
// }

import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/data/model/response/manage_service_model.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/AddService.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/RemoveServiceModel.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/colors.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/dialog_button.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/editService.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/vendor_service_model.dart';
import 'package:sixvalley_vendor_app/view/screens/Subcriptionplans/app_token_data.dart';
import 'package:sixvalley_vendor_app/view/screens/Subcriptionplans/utility_hlepar.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../localization/language_constrants.dart';
import '../../../provider/shop_provider.dart';
import '../../base/custom_app_bar.dart';
import '../auth/widgets/service_card_widget.dart';
import 'edit_services.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({
    Key? key,
    //this.profileResponse
  }) : super(key: key);
  // final GetProfileResponse? profileResponse;
  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {


  bool buttonLogin = false;
  String? selectedCategory, selectSubCategory, selectChildCategory, selectModel;
  double perMinServiceCharge = 0.0;
  String? visitingCharge;
  String? issue;
  List serviceTypeId = [];
  List specilizationTypeId = [];
  String finalCharges = "0";
  var servicePic;
  var storeId;
  DateTime dateTimeSelected = DateTime.now();
  String showImage = '';
  String service_price = "";
  String service_name = "";
  bool _switchValue = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<SellerProvider>(context,listen: false).getService();

    // Future.delayed(Duration(milliseconds: 200), () {
    //   return getServiceList();
    // });
  }

  Future _refresh() async {
    Provider.of<SellerProvider>(context,listen: false).getService();

  }

  activeDeactiveService(String serviceid, String status) async {
    var headers = {
      'Cookie': 'ci_session=5d20c59aa4198d23adadefd0d956a319531a4aca'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${AppConstants.baseUrl}vendor_service_status'));
    request.fields
        .addAll({'service_id': '${serviceid}', 'status': '${status}'});

    request.headers.addAll(headers);
    print('_________this${request.fields}_______');
    http.StreamedResponse response = await request.send();
    var data = jsonDecode("${await response.stream.bytesToString()}");
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "${data["msg"]}");
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SellerProvider>(builder: (authContext, provider, _)
     {
       return  Scaffold(
         appBar: CustomAppBar(
           title: getTranslated('Manage_Services', context),
           isBackButtonExist: true,
         ),
         floatingActionButton: FloatingActionButton(
           onPressed: () {
             // ! uncomment
             Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) => AddServices(
                       // profileResponse: widget.profileResponse,
                     ))).then((value) {
               Future.delayed(Duration(milliseconds: 200), () {
                 return getServiceList();
               });
             });
           },
           backgroundColor: Theme.of(context).primaryColor,
           child: Icon(Icons.add, color: Colors.white),
         ),
         body: SafeArea(
           child: Consumer<SellerProvider>(builder: (context, provider, child) {
             return SingleChildScrollView(
               child: RefreshIndicator(
                 onRefresh: _refresh,
                 child: AnimatedContainer(
                   duration: Duration(milliseconds: 1000),
                   curve: Curves.easeInOut,
                   width: 100.w,
                   // decoration: BoxDecoration(
                   //   gradient: RadialGradient(
                   //     center: Alignment(0.0, -0.5),
                   //     colors: [
                   //       AppColor().colorBg1(),
                   //       AppColor().colorBg1(),
                   //     ],
                   //     radius: 0.8,
                   //   ),
                   // ),
                   padding: MediaQuery.of(context).viewInsets,
                   child: Column(
                     children: [
                       // Container(
                       //   height: 9.92.h,
                       //   width: 100.w,
                       //   decoration: BoxDecoration(
                       //       image: DecorationImage(
                       //     image: AssetImage(profileBg),
                       //     fit: BoxFit.fill,
                       //   )),
                       //   child: Center(
                       //     child: Row(
                       //       crossAxisAlignment: CrossAxisAlignment.center,
                       //       children: [
                       //         Container(
                       //             width: 6.38.w,
                       //             height: 6.38.w,
                       //             alignment: Alignment.centerLeft,
                       //             margin: EdgeInsets.only(left: 7.91.w),
                       //             child: InkWell(
                       //                 onTap: () {
                       //                   Navigator.pop(context);
                       //                 },
                       //                 child: Image.asset(
                       //                   back,
                       //                   height: 4.0.h,
                       //                   width: 8.w,
                       //                 ))),
                       //         SizedBox(
                       //           width: 2.08.h,
                       //         ),
                       //         Container(
                       //           width: 65.w,
                       //           child: text(
                       //             "Service List",
                       //             textColor: Color(0xffffffff),
                       //             fontSize: 14.sp,
                       //             fontFamily: fontMedium,
                       //             isCentered: true,
                       //           ),
                       //         ),
                       //       ],
                       //     ),
                       //   ),
                       // ),
                       SizedBox(
                         height: 2.02.h,
                       ),
                       provider.isServiceLoading == true
                           ? Center(child: CircularProgressIndicator())
                           : provider.manageServiceList?.isEmpty ?? true
                           ? Center(child: Text("No service to show"))
                           : ListView.builder(
                         shrinkWrap: true,
                         physics: NeverScrollableScrollPhysics(),
                         itemCount:   provider.manageServiceList!.length,
                         itemBuilder: (context, index) {
                           return ServiceCardWidget(service: provider.manageServiceList![index],);

                         },
                       ),
                       // FutureBuilder(
                       //     future: getVendorAllServices(),
                       //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                       //       VendorServiceModel vendorModel = snapshot.data;
                       //       //print("checking error ${snapshot.hasError} and ${snapshot.error}");
                       //       if (snapshot.hasData) {
                       //         return vendorModel.status == 1
                       //             ? Container(
                       //           child: ListView.builder(
                       //             shrinkWrap: true,
                       //             physics: ClampingScrollPhysics(),
                       //             itemCount: vendorModel.restaurants!.length,
                       //             itemBuilder: (context, index) {
                       //               return Card(
                       //                 shape: RoundedRectangleBorder(
                       //                   borderRadius:
                       //                   BorderRadius.circular(10.0),
                       //                 ),
                       //                 margin: EdgeInsets.all(10.0),
                       //                 child: Column(
                       //                   children: [
                       //                     ListTile(
                       //                       leading: Container(
                       //                         width: 100,
                       //                         // height: 200,
                       //                         child: ClipRRect(
                       //                           borderRadius:
                       //                           BorderRadius.circular(10.0),
                       //                           child: vendorModel.restaurants![index].logo == ""
                       //                               ? Image.asset(
                       //                               "images/Placeholder.png")
                       //                               : Image.network(
                       //                             "${vendorModel.restaurants![index].logo![0].toString()}",
                       //                             fit: BoxFit.cover,
                       //                             width: 100,
                       //                             height: 200,
                       //                           ),
                       //                         ),
                       //                       ),
                       //                       title: Text(
                       //                         "${vendorModel.restaurants![index].resName}",
                       //                         style: TextStyle(
                       //                             fontWeight: FontWeight.bold,
                       //                             fontSize: 16),
                       //                       ),
                       //                       subtitle: Column(
                       //                         crossAxisAlignment:
                       //                         CrossAxisAlignment.start,
                       //                         children: [
                       //                           SizedBox(
                       //                             height: 8.0,
                       //                           ),
                       //                           Text(
                       //                               "${vendorModel.restaurants![index].cName}"),
                       //                           SizedBox(
                       //                             height: 5.0,
                       //                           ),
                       //                           Text(
                       //                               "₹ ${vendorModel.restaurants![index].price}"),
                       //                           SizedBox(
                       //                             height: 5.0,
                       //                           ),
                       //                           Row(
                       //                             mainAxisAlignment:
                       //                             MainAxisAlignment
                       //                                 .spaceBetween,
                       //                             children: [
                       //                               // Text.rich(
                       //                               //     TextSpan(children: [
                       //                               //       WidgetSpan(
                       //                               //           child: Icon(
                       //                               //             Icons
                       //                               //                 .watch_later_outlined,
                       //                               //             size: 15,
                       //                               //           )),
                       //                               //       TextSpan(
                       //                               //           text:
                       //                               //           " ${vendorModel.restaurants![index].hours}"),
                       //                               //     ])),
                       //                               Text.rich(
                       //                                   TextSpan(children: [
                       //                                     WidgetSpan(
                       //                                         child: Icon(
                       //                                           Icons.star,
                       //                                           color: Colors.yellow,
                       //                                           size: 15,
                       //                                         )),
                       //                                     TextSpan(text:
                       //                                     " ${vendorModel.restaurants![index].reviewCount}"),
                       //                                   ])),
                       //                             ],
                       //                           ),
                       //                           SizedBox(
                       //                             height: 5.0,
                       //                           ),
                       //                         ],
                       //                       ),
                       //                     ),
                       //                     Divider(
                       //                       indent: 15.0,
                       //                       endIndent: 15.0,
                       //                       thickness: 1.0,
                       //                     ),
                       //                     Row(
                       //                       mainAxisAlignment:
                       //                       MainAxisAlignment.spaceAround,
                       //                       children: [
                       //                         TextButton.icon(
                       //                           onPressed: () async{
                       //                             bool result = await Navigator.push(
                       //                                 context,
                       //                                 MaterialPageRoute(
                       //                                     builder: (context) => EditServices(
                       //                                       city: vendorModel.restaurants![index].cityId,
                       //                                       country: vendorModel.restaurants![index].countryId,
                       //                                       state: vendorModel.restaurants![index].stateId,
                       //                                       logo: vendorModel.restaurants![index].logo,
                       //                                       serviceName: vendorModel.restaurants![index].resName,
                       //                                       catId: vendorModel.restaurants![index].catId,
                       //                                       serviceCharge: vendorModel.restaurants![index].price,
                       //                                       // serviceTime: vendorModel.restaurants![index].hours,
                       //                                       subCatId: vendorModel.restaurants![index].scatId,
                       //                                       serviceId: vendorModel.restaurants![index].resId,
                       //                                       serviceImage: vendorModel.restaurants![index].logo,
                       //                                       subName: vendorModel.restaurants![index].subCat,
                       //                                       serviceDescription: vendorModel.restaurants![index].resDesc,
                       //                                       childName: vendorModel.restaurants![index].cName,
                       //                                       // experts: vendorModel.restaurants![index].experts,
                       //                                     )));
                       //                             if(result == true){
                       //                               setState(() {
                       //                                 CircularProgressIndicator();
                       //                                 getVendorAllServices();
                       //                               });
                       //                             }
                       //                           },
                       //                           icon: Icon(
                       //                               Icons.edit_note_outlined,
                       //                               size: 18),
                       //                           label: Text("Edit Service"),
                       //                           style: TextButton.styleFrom(
                       //                               primary: AppColor()
                       //                                   .colorPrimaryDark()),
                       //                         ),
                       //                         TextButton.icon(
                       //                           onPressed: () async {
                       //                             RemoveServiceModel?
                       //                             removeModel =
                       //                             await removeServices(
                       //                                 vendorModel
                       //                                     .restaurants![index].resId);
                       //                             if (removeModel!.responseCode == "1") {
                       //                               UtilityHlepar.getToast(
                       //                                   "Service Deleted Successfully!");
                       //                               setState(() {
                       //                                 CircularProgressIndicator();
                       //                                 getVendorAllServices();
                       //                               });
                       //                             }
                       //                           },
                       //                           icon: Icon(Icons.delete_rounded,
                       //                               size: 18),
                       //                           label: Text("Delete"),
                       //                           style: TextButton.styleFrom(
                       //                               primary: Colors.green),
                       //                         ),
                       //                       ],
                       //                     ),
                       //                   ],
                       //                 ),
                       //               );
                       //             },
                       //           ),
                       //         )
                       //             : Container(
                       //           height: MediaQuery.of(context).size.height/1.5,
                       //               child: Center(
                       //           child: Text("No Services Found"),
                       //         ),
                       //             );
                       //       } else if (snapshot.hasError) {
                       //         return Icon(Icons.error_outline);
                       //       } else {
                       //         return Container(
                       //             height: MediaQuery.of(context).size.height/1.5,
                       //             child: Center(child: Image.asset("images/icons/loader.gif")));
                       //       }
                       //     }),
                       SizedBox(
                         height: 4.02.h,
                       ),
                     ],
                   ),
                 ),
               ),
             ) ;
           },)
         ),
       );
     } );


  }








  Future<bool> addTimeSlots(
    String fromTime,
    String toTime,
    String serviceId, {
    required BuildContext context,
  }) async {
    try {
      // Create the request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.baseUrl}/api/v3/seller/services/add_time_slots'),
      );

      // Add service_id and time slots to the request
      request.fields['service_id'] = serviceId;
      request.fields['from_time[]'] = fromTime;
      request.fields['to_time[]'] = toTime;

      // Retrieve the token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.token) ?? "";

      // Add authorization header
      request.headers.addAll({'Authorization': 'Bearer $token'});

      // Send the request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("Time slots added successfully.");
        final str = await response.stream.bytesToString();
        final jsonResponse = json.decode(str);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Time slots added successfully!')),
        );
        getServiceList();
        return true;
      } else {
        print("Failed to add time slots. Status Code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Exception occurred: $e");
      return false;
    }
  }

  Future<bool> editTimeSlot(
    String fromTime,
    String toTime,
    String slotId, {
    required BuildContext context,
  }) async {
    try {
      // Retrieve the token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(AppConstants.token) ?? "";

      // Create the request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppConstants.baseUrl}/api/v3/seller/services/upadte_time_slot',
        ),
      );

      // Add service_id and time slots to the request
      request.fields['slot_id'] = slotId;
      request.fields['from_time'] = fromTime;
      request.fields['to_time'] = toTime;
      request.headers['Authorization'] = 'Bearer $token';

      // Log request details

      print("Request Fields: ${request.fields}");

      // Send the request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        print("Service updated successfully: $jsonResponse");
        UtilityHlepar.getToast('Time slot updated successfully');
        getServiceList();
        return true;
      } else {
        print("Failed to edit slot. Status Code: ${response.statusCode}");

        return false;
      }
    } catch (e, stackTrace) {
      print("Exception occurred: $e");
      print("Stack trace: $stackTrace");
      UtilityHlepar.getToast('An error occurred. Please try again.');

      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

  Future<bool>? deleteTimeSlot(String id) async {
    // Define the URL for the API request
    final url =
        '${AppConstants.baseUrl}/api/v3/seller/services/delete_time_slot/$id';

    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.token) ?? "";

      // Set the headers with the Authorization token
      final headers = {'Authorization': 'Bearer $token'};

      // Send the DELETE request with headers
      final response = await http.post(Uri.parse(url), headers: headers);

      // Process the response
      if (response.statusCode == 200) {
        final responseBody = response.body;
        var value = json.decode(responseBody);
        UtilityHlepar.getToast(value["message"]);
        getServiceList();
        //Navigator.pop(context);
        return true;
      } else {
        // Handle non-200 responses
        print('Failed to delete service. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle exceptions
      print('Error occurred while deleting service: $e');
      return false;
    }
  }

  List<ManageServiceModel> manageServiceList = [];
  List enablelist = [];

  bool isLoading = true;
  var serviceData ;

  Future<void> getServiceList() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Retrieve user ID and token
      var userId = await MyToken.getUserID();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.token) ?? "";

      // Define headers
      var headers = {
        'Authorization': 'Bearer $token',
        'Cookie':
            'ci_session=a0fad83c35b72f9b6b96e4fc773d876b8d6ca021', // Include only if required
      };

      // Make GET request
      final response = await http.get(
        Uri.parse(
            "${AppConstants.baseUrl}/api/v3/seller/services/list"),
        headers: headers,
      );

      //log("sdsdsd ${response.body}");

      // Check for successful response
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body); // Parse JSON
        manageServiceList = (jsonData['data']as List).map((item) => ManageServiceModel.fromJson(item)).toList();
        serviceData= jsonData['data'] ;
        setState(() { isLoading = false;});
        // Update enablelist and vendorServiceModel
      } else {
        setState(() {
          isLoading = false;
        });
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Exception occurred: $e");
    }
  }

  Future<bool>? removeService(String id) async {
    // Define the URL for the API request
    final url =
        '${AppConstants.baseUrl}/api/v3/seller/services/delete/$id';

    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.token) ?? "";

      // Set the headers with the Authorization token
      final headers = {'Authorization': 'Bearer $token'};

      // Send the DELETE request with headers
      final response = await http.delete(Uri.parse(url), headers: headers);

      // Process the response
      if (response.statusCode == 200) {
        final responseBody = response.body;
        var value = json.decode(responseBody);
        UtilityHlepar.getToast(value["message"]);
        Navigator.pop(context);
        return true;
      } else {
        // Handle non-200 responses
        print('Failed to delete service. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle exceptions
      print('Error occurred while deleting service: $e');
      return false;
    }
  }
}

class Alert {}
