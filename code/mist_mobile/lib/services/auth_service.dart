import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';
import 'cookie_storage.dart';

class AuthService {
  static const _sessionKey = 'auth_session';

  AuthService({ApiClient? apiClient, CookieStorage? cookieStorage})
      : _apiClient = apiClient ?? ApiClient(),
        _cookieStorage = cookieStorage ?? CookieStorage();

  final ApiClient _apiClient;
  final CookieStorage _cookieStorage;

  Future<AuthSession> login({
    required String email,
    required String senha,
  }) async {
    final data = await _apiClient.post(
      '/auth/login',
      body: {
        'email': email,
        'senha': senha,
      },
    ) as Map<String, dynamic>;

    final session = AuthSession.fromJson(data);
    await _saveSession(session);

    return session;
  }

  Future<AuthSession> signup({
    required String nome,
    required String email,
    required String senha,
    required String role,
    String? telefone,
    String? especialidade,
    String? descricao,
  }) async {
    final body = <String, dynamic>{
      'nome': nome,
      'email': email,
      'senha': senha,
      'role': role,
      if (telefone != null && telefone.isNotEmpty) 'telefone': telefone,
      if (especialidade != null && especialidade.isNotEmpty)
        'especialidade': especialidade,
      if (descricao != null && descricao.isNotEmpty) 'descricao': descricao,
    };

    final data = await _apiClient.post('/auth/signup', body: body)
        as Map<String, dynamic>;

    final session = AuthSession.fromJson(data);
    await _saveSession(session);

    return session;
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } on ApiException {
      // Mesmo se o cookie ja estiver invalido no backend, o app precisa sair.
    } finally {
      await _cookieStorage.clear();
      await clearSession();
    }
  }

  Future<AuthSession?> checkAuth() async {
    try {
      final data = await _apiClient.get('/auth/check-auth') as Map<String, dynamic>;
      final current = await currentSession();
      final session = AuthSession.fromJson(data).copyWith(
        email: current?.email,
        profile: data['profile'] as Map<String, dynamic>? ?? current?.profile,
      );
      await _saveSession(session);
      return session;
    } on ApiException {
      await _cookieStorage.clear();
      await clearSession();
      return null;
    }
  }

  Future<AuthSession?> currentSession() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_sessionKey);
    if (raw == null || raw.isEmpty) return null;

    return AuthSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> clearSession() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_sessionKey);
  }

  Future<void> _saveSession(AuthSession session) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_sessionKey, jsonEncode(session.toJson()));
  }
}

class AuthSession {
  const AuthSession({
    required this.authenticated,
    required this.userId,
    required this.role,
    this.email,
    this.profile,
  });

  final bool authenticated;
  final int userId;
  final String role;
  final String? email;
  final Map<String, dynamic>? profile;

  int? get profileId => profile?['id'] as int?;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};

    return AuthSession(
      authenticated: json['authenticated'] as bool? ?? true,
      userId: user['id'] as int? ?? 0,
      role: user['role']?.toString() ?? '',
      email: user['email']?.toString(),
      profile: json['profile'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authenticated': authenticated,
      'user': {
        'id': userId,
        'email': email,
        'role': role,
      },
      'profile': profile,
    };
  }

  AuthSession copyWith({
    bool? authenticated,
    int? userId,
    String? role,
    String? email,
    Map<String, dynamic>? profile,
  }) {
    return AuthSession(
      authenticated: authenticated ?? this.authenticated,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      email: email ?? this.email,
      profile: profile ?? this.profile,
    );
  }
}
