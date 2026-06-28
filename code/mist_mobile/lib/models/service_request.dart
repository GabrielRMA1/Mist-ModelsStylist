import 'booking_status.dart';

class ServiceRequest {
  final int id;
  final String client;
  final String clientInitials;
  final String service;
  final String date;
  final String time;
  final String description;
  BookingStatus status;

  ServiceRequest({
    required this.id,
    required this.client,
    required this.clientInitials,
    required this.service,
    required this.date,
    required this.time,
    required this.description,
    required this.status,
  });
}
