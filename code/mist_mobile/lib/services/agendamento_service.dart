import '../models/booking.dart';
import '../models/booking_status.dart';
import '../models/service_request.dart';
import 'api_client.dart';

class AgendamentoService {
  AgendamentoService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<Booking>> listarPorCliente(int clienteId) async {
    final data =
        await _apiClient.get('/agendamentos/cliente/$clienteId') as List<dynamic>;

    return data
        .map((item) => Booking.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<ServiceRequest>> listarPorEstilista(int estilistaId) async {
    final data = await _apiClient.get('/agendamentos/estilista/$estilistaId')
        as List<dynamic>;

    return data
        .map((item) => ServiceRequest.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Booking> criar({
    required int clienteId,
    required int estilistaId,
    required DateTime data,
    required String tipoServico,
    String? descricao,
  }) async {
    final response = await _apiClient.post(
      '/agendamentos',
      body: {
        'clienteId': clienteId,
        'estilistaId': estilistaId,
        'data': data.toIso8601String(),
        'tipoServico': tipoServico,
        if (descricao != null && descricao.isNotEmpty) 'descricao': descricao,
      },
    ) as Map<String, dynamic>;

    return Booking.fromJson(response);
  }

  Future<ServiceRequest> atualizarStatus({
    required int id,
    required BookingStatus status,
  }) async {
    final response = await _apiClient.patch(
      '/agendamentos/$id/status',
      body: {
        'status': bookingStatusToApi(status),
      },
    ) as Map<String, dynamic>;

    return ServiceRequest.fromJson(response);
  }

  Future<void> cancelar(int id) async {
    await _apiClient.patch(
      '/agendamentos/$id/status',
      body: {
        'status': 'CANCELADO',
      },
    );
  }
}
