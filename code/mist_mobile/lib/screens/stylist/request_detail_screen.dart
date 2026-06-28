import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/service_request.dart';
import '../../models/booking_status.dart';
import '../../widgets/status_badge.dart';
import '../shared/confirmation_screen.dart';
import 'stylist_dashboard_screen.dart';

class RequestDetailScreen extends StatelessWidget {
  final ServiceRequest request;

  const RequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Detalhe da Solicitação'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Client info card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.goldLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                        color: AppColors.gold, shape: BoxShape.circle),
                    child: Center(
                      child: Text(request.clientInitials,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.client,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.dark)),
                      const SizedBox(height: 4),
                      StatusBadge(status: request.status),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _DetailRow(label: 'Serviço solicitado', value: request.service),
            const Divider(color: AppColors.border, height: 1),
            _DetailRow(
                label: 'Data e horário',
                value: '${request.date} às ${request.time}'),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text('Descrição da necessidade',
                  style: TextStyle(fontSize: 12, color: AppColors.muted)),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(request.description,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.dark, height: 1.7)),
            ),
            const SizedBox(height: 24),
            // Action buttons
            if (request.status == BookingStatus.pending)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _refuse(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE53935),
                        side: const BorderSide(
                            color: Color(0xFFE53935), width: 1.5),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text('Recusar',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _accept(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E9E52),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text('Aceitar',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            if (request.status == BookingStatus.accepted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    request.status = BookingStatus.done;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B6FE8),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Marcar como Concluído',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _accept(BuildContext context) {
    request.status = BookingStatus.accepted;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmationScreen(
          message: 'Agendamento aceito!',
          subtitle:
              'O cliente será notificado e o atendimento está confirmado.',
          buttonLabel: 'Voltar ao painel',
          onContinue: (ctx) => Navigator.pushAndRemoveUntil(
            ctx,
            MaterialPageRoute(
                builder: (_) => const StylistDashboardScreen()),
            (r) => false,
          ),
        ),
      ),
      (r) => false,
    );
  }

  void _refuse(BuildContext context) {
    request.status = BookingStatus.refused;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmationScreen(
          message: 'Agendamento recusado.',
          subtitle: 'O cliente foi notificado sobre a recusa.',
          buttonLabel: 'Voltar ao painel',
          onContinue: (ctx) => Navigator.pushAndRemoveUntil(
            ctx,
            MaterialPageRoute(
                builder: (_) => const StylistDashboardScreen()),
            (r) => false,
          ),
        ),
      ),
      (r) => false,
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dark)),
        ],
      ),
    );
  }
}
