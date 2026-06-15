import '/services/api_service.dart';
import '/services/user_storage_service.dart';

class AuthService {
  static Future<void> signup({
    required String nome,
    required String email,
    required String senha,
    required String role,
    String? telefone,
    String? especialidade,
    String? descricao,
  }) async {
    final body = {
      'nome': nome,
      'email': email,
      'senha': senha,
      'role': role,
      if (telefone != null) 'telefone': telefone,
      if (especialidade != null) 'especialidade': especialidade,
      if (descricao != null) 'descricao': descricao,
    };

    final response = await ApiService.post('/auth/signup', body);

    if (response['token'] != null) {
      await ApiService.saveToken(response['token']);

      if (response['user'] != null && response['profile'] != null) {
        await UserStorageService.saveUser(
          user: response['user'],
          profile: response['profile'],
        );
      }
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final response = await ApiService.post('/auth/login', {
      'email': email,
      'senha': senha,
    });

    if (response['token'] != null) {
      await ApiService.saveToken(response['token']);

      if (response['user'] != null && response['profile'] != null) {
        await UserStorageService.saveUser(
          user: response['user'],
          profile: response['profile'],
        );
      }
    }

    return response;
  }

  static Future<void> logout() async {
    try {
      await ApiService.post('/auth/logout', {});
    } catch (e) {
      // Mesmo com erro, limpa o token
    } finally {
      await ApiService.clearToken();
      await UserStorageService.clearUser();
    }
  }

  static Future<bool> isAuthenticated() async {
    await ApiService.loadToken();
    return ApiService.getToken() != null;
  }

  static Future<Map<String, dynamic>?> checkAuth() async {
    try {
      await ApiService.loadToken();
      if (ApiService.getToken() == null) return null;

      final response = await ApiService.get('/auth/check-auth');
      return response;
    } catch (e) {
      await ApiService.clearToken();
      await UserStorageService.clearUser();
      return null;
    }
  }
}
