import '/models/estilista.dart';
import '/services/api_service.dart';

class EstilistaService {
  static Future<List<Estilista>> listarTodos() async {
    final response = await ApiService.get('/estilistas');
    
    if (response is List) {
      return response.map((e) => Estilista.fromJson(e)).toList();
    }
    
    return [];
  }

  static Future<Estilista> buscarPorId(int id) async {
    final response = await ApiService.get('/estilistas/$id');
    return Estilista.fromJson(response);
  }

  static Future<List<Estilista>> buscarPorEspecialidade(String especialidade) async {
    final response = await ApiService.get('/estilistas?especialidade=$especialidade');
    
    if (response is List) {
      return response.map((e) => Estilista.fromJson(e)).toList();
    }
    
    return [];
  }
}
