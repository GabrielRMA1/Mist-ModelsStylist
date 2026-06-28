enum BookingStatus { pending, accepted, refused, inProgress, done }

extension BookingStatusExt on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:    return 'Pendente';
      case BookingStatus.accepted:   return 'Aceito';
      case BookingStatus.refused:    return 'Recusado';
      case BookingStatus.inProgress: return 'Em andamento';
      case BookingStatus.done:       return 'Concluído';
    }
  }
}
