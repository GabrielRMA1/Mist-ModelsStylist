import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/agendamento.dart';
import '../../services/agendamento_service.dart';

class ClientBookingsScreen extends StatefulWidget {
  const ClientBookingsScreen({super.key});

  @override
  State<ClientBookingsScreen> createState() => _ClientBookingsScreenState();
}

class _ClientBookingsScreenState extends State<ClientBookingsScreen> {
  List<Agendamento> agendamentos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAgendamentos();
  }

  Future<void> _loadAgendamentos() async {
    try {
      setState(() => _isLoading = true);
      final data = await AgendamentoService.listarTodos();
      setState(() {
        agendamentos = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar agendamentos: $e')),
        );
      }
    }
  }

  Future<void> _refreshAgendamentos() async {
    await _loadAgendamentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text("Meus Agendamentos"),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.dark,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : agendamentos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 64,
                    color: AppColors.muted.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum agendamento',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Procure por um estilista e agende um serviço',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Encontrar Estilista'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshAgendamentos,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: agendamentos.length,
                itemBuilder: (context, index) {
                  final booking = agendamentos[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _formatServiceType(booking.tipoServico),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              StatusBadge(status: booking.status.toLowerCase()),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "com ${booking.nomeEstilista ?? 'Estilista'}",
                            style: const TextStyle(color: AppColors.muted),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "📅 ${DateFormat('dd/MM/yyyy').format(booking.data)} às ${DateFormat('HH:mm').format(booking.data)}",
                            style: const TextStyle(color: AppColors.muted),
                          ),
                          if (booking.descricao != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                booking.descricao!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.muted,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          if (booking.status == "ACEITO")
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: SizedBox(
                                height: 40,
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    // TODO: Ver detalhes do agendamento
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.gold,
                                    side: const BorderSide(
                                      color: AppColors.gold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text("Ver detalhes"),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  String _formatServiceType(String type) {
    const map = {
      'CONSULTORIA_ESTILO': 'Consultoria de Estilo',
      'MONTAGEM_LOOK': 'Montagem de Look',
      'ROUPA_SOB_MEDIDA': 'Roupa Sob Medida',
      'ACOMPANHAMENTO_EVENTO': 'Acompanhamento de Evento',
      'OUTRO': 'Outro',
    };
    return map[type] ?? type;
  }
}
