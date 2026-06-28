import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/session_helpers.dart';
import '../../theme/app_theme.dart';
import '../login_screen.dart';
import 'client_bookings_screen.dart';
import 'client_favorites_screen.dart';
import 'client_home_screen.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  final _authService = AuthService();
  late Future<AuthSession?> _sessionFuture;

  @override
  void initState() {
    super.initState();
    _sessionFuture = _authService.currentSession();
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
      MaterialPageRoute(builder: (_) => const ClientHomeScreen()),
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
                const _SectionLabel('Conta'),
                _MenuTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Meus agendamentos',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ClientBookingsScreen(),
                    ),
                  ),
                ),
                _MenuTile(
                  icon: Icons.favorite_outline,
                  label: 'Estilistas favoritos',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ClientFavoritesScreen(),
                    ),
                  ),
                ),
                _MenuTile(
                  icon: Icons.edit_outlined,
                  label: 'Editar dados pessoais',
                  onTap: () => _soon('Editar dados pessoais'),
                ),
                const SizedBox(height: 16),
                const _SectionLabel('Preferências'),
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
    final name = sessionName(session, fallback: 'Cliente');
    final initials = sessionInitials(session);
    final subtitle = sessionSubtitle(session);

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
