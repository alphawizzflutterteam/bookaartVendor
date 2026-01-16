class RescheduleModel {
  RescheduleModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final List<Datum> data;

  factory RescheduleModel.fromJson(Map<String, dynamic> json) {
    return RescheduleModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.slotId,
    required this.fromTime,
    required this.toTime,
    required this.isBooked,
  });

  final int? slotId;
  final String? fromTime;
  final String? toTime;
  final int? isBooked;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      slotId: json["slot_id"],
      fromTime: json["from_time"],
      toTime: json["to_time"],
      isBooked: json["is_booked"],
    );
  }
}
