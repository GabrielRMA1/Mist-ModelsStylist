import 'auth_service.dart';

String sessionName(AuthSession? session, {String fallback = 'Usuario'}) {
  return session?.profile?['nome']?.toString() ?? fallback;
}

String sessionSubtitle(AuthSession? session) {
  if (session?.role == 'ESTILISTA') {
    return session?.profile?['especialidade']?.toString() ??
        session?.email ??
        'Estilista';
  }

  return session?.profile?['telefone']?.toString() ?? session?.email ?? 'Cliente';
}

String sessionInitials(AuthSession? session, {String fallback = 'U'}) {
  final name = sessionName(session, fallback: '');
  if (name.isEmpty) return fallback;

  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();

  if (parts.isEmpty) return fallback;
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();

  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
