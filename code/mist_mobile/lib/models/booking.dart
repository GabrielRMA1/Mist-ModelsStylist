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

  factory Booking.fromJson(Map<String, dynamic> json) {
    final date = DateTime.tryParse(json['data']?.toString() ?? '');
    final stylist = json['estilista'] as Map<String, dynamic>?;
    final stylistName = stylist?['nome']?.toString() ?? 'Estilista';

    return Booking(
      id: json['id'] as int? ?? 0,
      stylist: stylistName,
      stylistInitials: _initials(stylistName),
      service: serviceLabelFromApi(json['tipoServico']?.toString()),
      date: date == null ? '' : _dateLabel(date),
      time: date == null ? '' : _timeLabel(date),
      status: bookingStatusFromApi(json['status']?.toString()),
      notes: json['descricao']?.toString() ?? '',
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

    if (parts.isEmpty) return 'MS';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

String serviceLabelFromApi(String? value) {
  switch (value) {
    case 'CONSULTORIA_ESTILO':
      return 'Consultoria de Estilo';
    case 'MONTAGEM_LOOK':
      return 'Montagem de Look';
    case 'ROUPA_SOB_MEDIDA':
      return 'Roupa Sob Medida';
    case 'ACOMPANHAMENTO_EVENTO':
      return 'Acompanhamento de Evento';
    case 'OUTRO':
    default:
      return 'Outro';
  }
}

String serviceTypeToApi(String service) {
  switch (service) {
    case 'Consultoria de Estilo':
      return 'CONSULTORIA_ESTILO';
    case 'Montagem de Look':
      return 'MONTAGEM_LOOK';
    case 'Peça Sob Medida':
    case 'Roupa Sob Medida':
      return 'ROUPA_SOB_MEDIDA';
    case 'Look para Evento':
    case 'Acompanhamento de Evento':
      return 'ACOMPANHAMENTO_EVENTO';
    default:
      return 'OUTRO';
  }
}
