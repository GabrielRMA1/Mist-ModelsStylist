import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/booking_status.dart';
import '../../models/service_request.dart';
import '../../services/agendamento_service.dart';
import '../../services/auth_service.dart';
import '../../services/session_helpers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/status_badge.dart';
import 'request_detail_screen.dart';
import 'stylist_profile_settings_screen.dart';

class StylistDashboardScreen extends StatefulWidget {
  const StylistDashboardScreen({super.key});

  @override
  State<StylistDashboardScreen> createState() => _StylistDashboardScreenState();
}

class _StylistDashboardScreenState extends State<StylistDashboardScreen> {
  final _authService = AuthService();
  final _agendamentoService = AgendamentoService();

  late Future<List<ServiceRequest>> _requestsFuture;
  late Future<AuthSession?> _sessionFuture;
  Timer? _pollingTimer;
  Set<int> _knownRequestIds = {};
  bool _hasLoadedRequests = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _sessionFuture = _authService.currentSession();
    _requestsFuture = _refreshRequests();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _refreshRequestsInBackground(),
    );
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<List<ServiceRequest>> _loadRequests() async {
    final session = await _authService.currentSession();
    final estilistaId = session?.profileId;

    if (estilistaId == null) {
      throw Exception('Estilista não encontrado na sessão.');
    }

    return _agendamentoService.listarPorEstilista(estilistaId);
  }

  Future<List<ServiceRequest>> _refreshRequests({bool notify = false}) async {
    final requests = await _loadRequests();
    _notifyNewRequests(requests, notify: notify);
    return requests;
  }

  Future<void> _refreshRequestsInBackground() async {
    if (_isRefreshing) return;

    _isRefreshing = true;

    try {
      final requests = await _refreshRequests(notify: true);

      if (!mounted) return;

      setState(() {
        _requestsFuture = Future.value(requests);
      });
    } catch (_) {
      // Polling silencioso: a tela principal continua exibindo o ultimo estado.
    } finally {
      _isRefreshing = false;
    }
  }

  void _notifyNewRequests(
    List<ServiceRequest> requests, {
    required bool notify,
  }) {
    final requestIds = requests.map((request) => request.id).toSet();
    final newPendingRequests = requests.where(
      (request) =>
          !_knownRequestIds.contains(request.id) &&
          request.status == BookingStatus.pending,
    );

    if (notify && _hasLoadedRequests && mounted && newPendingRequests.isNotEmpty) {
      final count = newPendingRequests.length;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            count == 1
                ? 'Nova solicitacao de agendamento recebida.'
                : '$count novas solicitacoes de agendamento recebidas.',
          ),
        ),
      );
    }

    _knownRequestIds = requestIds;
    _hasLoadedRequests = true;
  }

  List<ServiceRequest> _pending(List<ServiceRequest> requests) {
    return requests
        .where((request) => request.status == BookingStatus.pending)
        .toList();
  }

  List<ServiceRequest> _others(List<ServiceRequest> requests) {
    return requests
        .where((request) => request.status != BookingStatus.pending)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ServiceRequest>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          final requests = snapshot.data ?? [];

          return Column(
            children: [
              _buildHeader(requests),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return _ErrorState(
                        message: snapshot.error.toString(),
                        onRetry: () => setState(() {
                          _requestsFuture = _refreshRequests();
                        }),
                      );
                    }

                    final pending = _pending(requests);
                    final others = _others(requests);

                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Text(
                          'Solicitações pendentes',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (pending.isEmpty)
                          const _EmptyText('Nenhuma solicitação pendente.'),
                        ...pending.map(
                          (request) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _RequestCard(
                              request: request,
                              highlighted: true,
                              onTap: () => _openDetail(request),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Outros atendimentos',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (others.isEmpty)
                          const _EmptyText('Nenhum outro atendimento.'),
                        ...others.map(
                          (request) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _RequestCard(
                              request: request,
                              highlighted: false,
                              onTap: () => _openDetail(request),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(List<ServiceRequest> requests) {
    final pendingCount = _pending(requests).length;
    final acceptedCount = requests
        .where((request) => request.status == BookingStatus.accepted)
        .length;
    final doneCount =
        requests.where((request) => request.status == BookingStatus.done).length;

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
                  FutureBuilder<AuthSession?>(
                    future: _sessionFuture,
                    builder: (context, snapshot) {
                      final name = sessionName(snapshot.data, fallback: '');

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name.isEmpty
                                ? 'Bem-vinda de volta'
                                : 'Bem-vinda de volta',
                            style: const TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            name.isEmpty ? 'Painel do estilista' : name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
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
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: FutureBuilder<AuthSession?>(
                          future: _sessionFuture,
                          builder: (context, snapshot) {
                            return Text(
                              sessionInitials(snapshot.data, fallback: 'E'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _StatCard(value: '$pendingCount', label: 'Pendentes'),
                  const SizedBox(width: 10),
                  _StatCard(value: '$acceptedCount', label: 'Aceitos'),
                  const SizedBox(width: 10),
                  _StatCard(value: '$doneCount', label: 'Concluídos'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openDetail(ServiceRequest request) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RequestDetailScreen(request: request)),
    );

    if (!mounted) return;

    setState(() {
      _requestsFuture = _refreshRequests();
    });
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

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
            Text(
              value,
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF888888), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.highlighted,
    required this.onTap,
  });

  final ServiceRequest request;
  final bool highlighted;
  final VoidCallback onTap;

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
                  child: Text(
                    request.client,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.dark,
                    ),
                  ),
                ),
                StatusBadge(status: request.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              request.service,
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 4),
                Text(
                  '${request.date} às ${request.time}',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: AppColors.muted),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
