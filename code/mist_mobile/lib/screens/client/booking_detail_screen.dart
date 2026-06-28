import 'package:flutter/material.dart';

import '../../models/booking.dart';
import '../../models/booking_status.dart';
import '../../theme/app_theme.dart';
import '../../widgets/status_badge.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Detalhe do Agendamento'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.goldLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        booking.stylistInitials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.stylist,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        StatusBadge(status: booking.status),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.design_services_outlined,
              label: 'Serviço',
              value: booking.service,
            ),
            const Divider(color: AppColors.border, height: 1),
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Data e horário',
              value: '${booking.date} às ${booking.time}',
            ),
            if (booking.address.isNotEmpty) ...[
              const Divider(color: AppColors.border, height: 1),
              _DetailRow(
                icon: Icons.location_on_outlined,
                label: 'Local do atendimento',
                value: booking.address,
              ),
            ],
            if (booking.price.isNotEmpty) ...[
              const Divider(color: AppColors.border, height: 1),
              _DetailRow(
                icon: Icons.attach_money,
                label: 'Valor',
                value: booking.price,
              ),
            ],
            if (booking.notes.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Text(
                'Observações',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  booking.notes,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.dark,
                    height: 1.7,
                  ),
                ),
              ),
            ],
            if (booking.status == BookingStatus.pending) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53935),
                    side: const BorderSide(color: Color(0xFFE53935)),
                  ),
                  child: const Text('Cancelar solicitação'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.gold),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
