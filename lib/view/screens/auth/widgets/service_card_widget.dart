import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/provider/shop_provider.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/AddService.dart';

import '../../../../data/model/response/manage_service_model.dart';
import '../../../../provider/splash_provider.dart';

class ServiceCardWidget extends StatefulWidget {
  const ServiceCardWidget({Key? key, required this.service}) : super(key: key);
  final ManageServiceModel? service;

  @override
  State<ServiceCardWidget> createState() => _ServiceCardWidgetState();
}

class _ServiceCardWidgetState extends State<ServiceCardWidget> {
  @override
  Widget build(BuildContext context) {
    final price = finalPrice(widget.service!);
    final hasDiscount = (widget.service?.discount ?? 0) > 0;
    // final image = widget.s['images'] != ''
    //     ? List<String>.from(json.decode(widget.s['images'] ?? '[]'))
    //     : [];


    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Colors.black12)
        ],
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          Stack(
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: widget.service?.thumbnail !=null
                      ? Image.network(
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${widget.service?.thumbnail}',
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        )
                      : Text(
                          widget.service?.name ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              if (widget.service?.featuredStatus == 1)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Featured",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.service?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    chip(widget.service?.serviceType ?? '', Colors.blue),
                    // const SizedBox(width: 6),
                    // chip(widget.s["product_type"], Colors.grey),
                  ],
                ),
                const SizedBox(height: 12),
                hasDiscount
                    ? Row(
                        children: [
                          Text(
                            "₹${price.toInt()}",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "₹${widget.service?.unitPrice}",
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "-${widget.service?.discount}${widget.service?.discountType == "percent" ? "%" : "₹"}",
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          )
                        ],
                      )
                    : Text(
                        "₹${widget.service?.unitPrice}",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                const SizedBox(height: 10),

                Html(data: widget.service?.details),
                // Text(
                //   widget.s["details"],
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                //   style: const TextStyle(color: Colors.grey),
                // ),
                const Divider(height: 24),
                Text(
                  "Total Bookings: ${''}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                //const SizedBox(height: 12),
                Row(
                  children: [
                    const Text("Status"),
                    const Spacer(),
                    Switch(
                      value: widget.service?.status == 1,
                      activeColor: Colors.green,
                      onChanged: (_) {
                        setState(() {
                          widget.service?.status = widget.service?.status == 1 ? 0 : 1;
                        });
                      },
                    ),
                    Text(
                      widget.service?.status == 1 ? "Active" : "Inactive",
                      style: TextStyle(
                          color: widget.service?.status == 1
                              ? Colors.green
                              : Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.edit, size: 16),
                        label: const Text("Edit"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddServices(service: widget.service,),));
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.delete, size: 16),
                        label: const Text("Delete"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () {
                          Provider.of<SellerProvider>(context,listen: false).deleteService(context, widget.service?.id);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text.toUpperCase(),
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

double finalPrice(ManageServiceModel s) {
  if (s.discountType == "flat") {
    return (s.unitPrice! - (s.discount??0)).toDouble();
  }
  if (s.discountType == "percent") {
    return s.unitPrice! - (s.unitPrice! * (s.discount ?? 0) / 100);
  }
  return s.unitPrice!.toDouble();
}
