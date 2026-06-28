import 'api_client.dart';
import 'cookie_storage.dart';

class AuthService {
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

    return AuthSession.fromJson(data);
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

    return AuthSession.fromJson(data);
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } finally {
      await _cookieStorage.clear();
    }
  }

  Future<AuthSession?> checkAuth() async {
    try {
      final data = await _apiClient.get('/auth/check-auth') as Map<String, dynamic>;
      return AuthSession.fromJson(data);
    } on ApiException {
      await _cookieStorage.clear();
      return null;
    }
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
}
