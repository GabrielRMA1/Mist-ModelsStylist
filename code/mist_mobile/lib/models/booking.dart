import 'booking_status.dart';

class Booking {
  final int id;
  final String stylist;
  final String stylistInitials;
  final String service;
  final String date;
  final String time;
  final BookingStatus status;
  final String address;
  final String price;
  final String notes;

  const Booking({
    required this.id,
    required this.stylist,
    required this.stylistInitials,
    required this.service,
    required this.date,
    required this.time,
    required this.status,
    this.address = '',
    this.price = '',
    this.notes = '',
  });
}
