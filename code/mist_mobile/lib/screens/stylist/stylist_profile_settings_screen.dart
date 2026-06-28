import 'package:flutter/material.dart';

import '../../models/booking_status.dart';
import '../../models/service_request.dart';
import '../../services/agendamento_service.dart';
import '../../services/auth_service.dart';
import '../../services/session_helpers.dart';
import '../../theme/app_theme.dart';
import '../login_screen.dart';
import 'stylist_dashboard_screen.dart';

class StylistProfileSettingsScreen extends StatefulWidget {
  const StylistProfileSettingsScreen({super.key});

  @override
  State<StylistProfileSettingsScreen> createState() =>
      _StylistProfileSettingsScreenState();
}

class _StylistProfileSettingsScreenState
    extends State<StylistProfileSettingsScreen> {
  final _authService = AuthService();
  final _agendamentoService = AgendamentoService();
  late Future<AuthSession?> _sessionFuture;
  late Future<List<ServiceRequest>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _sessionFuture = _authService.currentSession();
    _requestsFuture = _loadRequests();
  }

  Future<List<ServiceRequest>> _loadRequests() async {
    final session = await _authService.currentSession();
    final estilistaId = session?.profileId;

    if (estilistaId == null) return [];

    return _agendamentoService.listarPorEstilista(estilistaId);
  }

  Future<void> _logout(BuildContext context) async {
    await _authService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StylistDashboardScreen()),
    );
  }

  void _soon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label em breve.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder<AuthSession?>(
            future: _sessionFuture,
            builder: (context, snapshot) => _buildHeader(snapshot.data),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                FutureBuilder<List<ServiceRequest>>(
                  future: _requestsFuture,
                  builder: (context, snapshot) {
                    final requests = snapshot.data ?? [];
                    final doneCount = requests
                        .where((request) => request.status == BookingStatus.done)
                        .length;

                    return Row(
                      children: [
                        const Expanded(
                          child: _StatBox(value: '-', label: 'Avaliação'),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: _StatBox(value: '-', label: 'Avaliações'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatBox(
                            value: '$doneCount',
                            label: 'Atendimentos',
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                const _SectionLabel('Perfil profissional'),
                _MenuTile(
                  icon: Icons.edit_outlined,
                  label: 'Editar dados pessoais',
                  onTap: () => _soon('Editar dados pessoais'),
                ),
                _MenuTile(
                  icon: Icons.design_services_outlined,
                  label: 'Gerenciar serviços e preços',
                  onTap: () => _soon('Gerenciar serviços e preços'),
                ),
                _MenuTile(
                  icon: Icons.image_outlined,
                  label: 'Portfólio de trabalhos',
                  onTap: () => _soon('Portfólio de trabalhos'),
                ),
                const SizedBox(height: 16),
                const _SectionLabel('Disponibilidade'),
                _MenuTile(
                  icon: Icons.schedule_outlined,
                  label: 'Horários de atendimento',
                  onTap: () => _soon('Horários de atendimento'),
                ),
                _MenuTile(
                  icon: Icons.event_busy_outlined,
                  label: 'Bloquear datas',
                  onTap: () => _soon('Bloquear datas'),
                ),
                const SizedBox(height: 16),
                const _SectionLabel('Conta'),
                _MenuTile(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Dados de pagamento',
                  onTap: () => _soon('Dados de pagamento'),
                ),
                _MenuTile(
                  icon: Icons.notifications_outlined,
                  label: 'Notificações',
                  onTap: () => _soon('Notificações'),
                ),
                _MenuTile(
                  icon: Icons.help_outline,
                  label: 'Ajuda e suporte',
                  onTap: () => _soon('Ajuda e suporte'),
                ),
                const SizedBox(height: 12),
                _MenuTile(
                  icon: Icons.logout,
                  label: 'Sair',
                  destructive: true,
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AuthSession? session) {
    final name = sessionName(session, fallback: 'Estilista');
    final subtitle = sessionSubtitle(session);
    final initials = sessionInitials(session, fallback: 'E');

    return Container(
      color: AppColors.dark,
      width: double.infinity,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _goBack,
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.gold),
                  ),
                  const Text(
                    'Meu Perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.muted,
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? const Color(0xFFE53935) : AppColors.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: destructive ? color : AppColors.gold),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        trailing: Icon(Icons.chevron_right, size: 18, color: color),
      ),
    );
  }
}
