import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/service_request.dart';
import '../../models/booking_status.dart';
import '../../widgets/status_badge.dart';
import 'request_detail_screen.dart';
import 'stylist_profile_settings_screen.dart';

class StylistDashboardScreen extends StatefulWidget {
  const StylistDashboardScreen({super.key});

  @override
  State<StylistDashboardScreen> createState() =>
      _StylistDashboardScreenState();
}

class _StylistDashboardScreenState extends State<StylistDashboardScreen> {
  List<ServiceRequest> get _pending =>
      mockRequests.where((r) => r.status == BookingStatus.pending).toList();

  List<ServiceRequest> get _others =>
      mockRequests.where((r) => r.status != BookingStatus.pending).toList();

  int get _inProgressCount =>
      mockRequests.where((r) => r.status == BookingStatus.inProgress).length;

  int get _doneCount =>
      mockRequests.where((r) => r.status == BookingStatus.done).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Solicitações pendentes',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.dark)),
                const SizedBox(height: 10),
                ..._pending.map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _RequestCard(
                        request: r,
                        highlighted: true,
                        onTap: () => _openDetail(r),
                      ),
                    )),
                const SizedBox(height: 8),
                const Text('Outros atendimentos',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.dark)),
                const SizedBox(height: 10),
                ..._others.map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _RequestCard(
                        request: r,
                        highlighted: false,
                        onTap: () => _openDetail(r),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.dark,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bem-vinda de volta',
                          style: TextStyle(
                              color: Color(0xFFAAAAAA), fontSize: 12)),
                      SizedBox(height: 2),
                      Text('Isabela Moura',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StylistProfileSettingsScreen(),
                      ),
                    ),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                          color: AppColors.gold, shape: BoxShape.circle),
                      child: const Center(
                        child: Text('IM',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _StatCard(value: '${_pending.length}', label: 'Pendentes'),
                  const SizedBox(width: 10),
                  _StatCard(value: '$_inProgressCount', label: 'Em andamento'),
                  const SizedBox(width: 10),
                  _StatCard(value: '$_doneCount', label: 'Concluídos'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openDetail(ServiceRequest r) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RequestDetailScreen(request: r)),
    );
    setState(() {});
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF888888), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final ServiceRequest request;
  final bool highlighted;
  final VoidCallback onTap;

  const _RequestCard({
    required this.request,
    required this.highlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: highlighted ? AppColors.gold : AppColors.border,
            width: highlighted ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(request.client,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.dark)),
                ),
                StatusBadge(status: request.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(request.service,
                style: const TextStyle(fontSize: 12, color: AppColors.muted)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 12, color: AppColors.muted),
                const SizedBox(width: 4),
                Text('${request.date} às ${request.time}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
