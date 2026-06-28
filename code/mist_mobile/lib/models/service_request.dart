import 'booking.dart';
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

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    final date = DateTime.tryParse(json['data']?.toString() ?? '');
    final client = json['cliente'] as Map<String, dynamic>?;
    final clientName = client?['nome']?.toString() ?? 'Cliente';

    return ServiceRequest(
      id: json['id'] as int? ?? 0,
      client: clientName,
      clientInitials: _initials(clientName),
      service: serviceLabelFromApi(json['tipoServico']?.toString()),
      date: date == null ? '' : _dateLabel(date),
      time: date == null ? '' : _timeLabel(date),
      description: json['descricao']?.toString() ?? '',
      status: bookingStatusFromApi(json['status']?.toString()),
    );
  }

  static String _dateLabel(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  static String _timeLabel(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  static String _initials(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'CL';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
