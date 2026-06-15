import '/models/agendamento.dart';
import '/services/api_service.dart';
import '/services/user_storage_service.dart';

class AgendamentoService {
  static Future<List<Agendamento>> listarTodos() async {
    final response = await ApiService.get('/agendamentos');

    if (response is List) {
      return response.map((e) => Agendamento.fromJson(e)).toList();
    }

    return [];
  }

  static Future<Agendamento> buscarPorId(int id) async {
    final response = await ApiService.get('/agendamentos/$id');
    return Agendamento.fromJson(response);
  }

  static Future<Agendamento> criar({
    required int estilistaId,
    required DateTime data,
    required String tipoServico,
    String? descricao,
  }) async {
    final clienteId = await UserStorageService.getClienteId();

    if (clienteId == null) {
      throw Exception('Cliente ID não encontrado. Faça login novamente.');
    }

    final body = {
      'clienteId': clienteId,
      'estilistaId': estilistaId,
      'data': data.toIso8601String(),
      'tipoServico': tipoServico,
      if (descricao != null) 'descricao': descricao,
    };

    final response = await ApiService.post('/agendamentos', body);
    return Agendamento.fromJson(response);
  }

  static Future<void> atualizar({required int id, String? status}) async {
    final body = <String, dynamic>{if (status != null) 'status': status};

    await ApiService.put('/agendamentos/$id', body);
  }

  static Future<List<Agendamento>> listarPorCliente(int clienteId) async {
    final response = await ApiService.get('/agendamentos/cliente/$clienteId');

    if (response is List) {
      return response.map((e) => Agendamento.fromJson(e)).toList();
    }

    return [];
  }
}
