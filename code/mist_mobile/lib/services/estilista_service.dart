import '../models/stylist.dart';
import 'api_client.dart';

class EstilistaService {
  EstilistaService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<Stylist>> listarTodos() async {
    final data = await _apiClient.get('/estilistas') as List<dynamic>;
    return data
        .map((item) => Stylist.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Stylist> buscarPorId(int id) async {
    final data = await _apiClient.get('/estilistas/$id') as Map<String, dynamic>;
    return Stylist.fromJson(data);
  }
}
