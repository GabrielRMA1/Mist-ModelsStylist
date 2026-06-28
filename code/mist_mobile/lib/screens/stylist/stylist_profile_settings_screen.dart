import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../login_screen.dart';

class StylistProfileSettingsScreen extends StatelessWidget {
  const StylistProfileSettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

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
                Row(
                  children: const [
                    Expanded(child: _StatBox(value: '4.9', label: 'Avaliação')),
                    SizedBox(width: 10),
                    Expanded(child: _StatBox(value: '87', label: 'Avaliações')),
                    SizedBox(width: 10),
                    Expanded(child: _StatBox(value: '34', label: 'Atendimentos')),
                  ],
                ),
                const SizedBox(height: 20),
                const _SectionLabel('Perfil profissional'),
                _MenuTile(
                  icon: Icons.edit_outlined,
                  label: 'Editar dados pessoais',
                  onTap: () {},
                ),
                _MenuTile(
                  icon: Icons.design_services_outlined,
                  label: 'Gerenciar serviços e preços',
                  onTap: () {},
                ),
                _MenuTile(
                  icon: Icons.image_outlined,
                  label: 'Portfólio de trabalhos',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                const _SectionLabel('Disponibilidade'),
                _MenuTile(
                  icon: Icons.schedule_outlined,
                  label: 'Horários de atendimento',
                  onTap: () {},
                ),
                _MenuTile(
                  icon: Icons.event_busy_outlined,
                  label: 'Bloquear datas',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                const _SectionLabel('Conta'),
                _MenuTile(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Dados de pagamento',
                  onTap: () {},
                ),
                _MenuTile(
                  icon: Icons.notifications_outlined,
                  label: 'Notificações',
                  onTap: () {},
                ),
                _MenuTile(
                  icon: Icons.help_outline,
                  label: 'Ajuda e suporte',
                  onTap: () {},
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

  Widget _buildHeader() {
    return Container(
      color: AppColors.dark,
      width: double.infinity,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Meu Perfil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'IM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Isabela Moura',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Consultoria de Estilo',
                style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12),
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
