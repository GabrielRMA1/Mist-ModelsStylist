import '/models/cliente.dart';
import '/services/api_service.dart';

class ClienteService {
  static Future<void> criar({
    required String nome,
    required String email,
    required String telefone,
  }) async {
    final body = {
      'nome': nome,
      'email': email,
      'telefone': telefone,
    };

    await ApiService.post('/clientes', body);
  }

  static Future<List<Cliente>> listarTodos() async {
    final response = await ApiService.get('/clientes');
    
    if (response is List) {
      return response.map((e) => Cliente.fromJson(e)).toList();
    }
    
    return [];
  }

  static Future<Cliente> buscarPorId(int id) async {
    final response = await ApiService.get('/clientes/$id');
    return Cliente.fromJson(response);
  }

  static Future<void> atualizar({
    required int id,
    String? nome,
    String? email,
    String? telefone,
  }) async {
    final body = <String, dynamic>{
      if (nome != null) 'nome': nome,
      if (email != null) 'email': email,
      if (telefone != null) 'telefone': telefone,
    };

    await ApiService.put('/clientes/$id', body);
  }

  static Future<void> deletar(int id) async {
    await ApiService.delete('/clientes/$id');
  }
}
