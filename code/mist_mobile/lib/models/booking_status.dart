enum BookingStatus { pending, accepted, refused, inProgress, done }

extension BookingStatusExt on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pendente';
      case BookingStatus.accepted:
        return 'Aceito';
      case BookingStatus.refused:
        return 'Recusado';
      case BookingStatus.inProgress:
        return 'Em andamento';
      case BookingStatus.done:
        return 'Concluído';
    }
  }
}

BookingStatus bookingStatusFromApi(String? value) {
  switch (value) {
    case 'ACEITO':
      return BookingStatus.accepted;
    case 'RECUSADO':
    case 'CANCELADO':
      return BookingStatus.refused;
    case 'CONCLUIDO':
      return BookingStatus.done;
    case 'PENDENTE':
    default:
      return BookingStatus.pending;
  }
}

String bookingStatusToApi(BookingStatus status) {
  switch (status) {
    case BookingStatus.accepted:
      return 'ACEITO';
    case BookingStatus.refused:
      return 'RECUSADO';
    case BookingStatus.done:
      return 'CONCLUIDO';
    case BookingStatus.inProgress:
      return 'ACEITO';
    case BookingStatus.pending:
      return 'PENDENTE';
  }
}
