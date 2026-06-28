import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/gold_button.dart';
import 'client/client_home_screen.dart';
import 'signup_screen.dart';
import 'stylist/stylist_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final session = await _authService.login(
        email: _emailController.text.trim(),
        senha: _passwordController.text,
      );

      if (!mounted) return;
      _goToHome(session);
    } catch (error) {
      if (!mounted) return;
      _showError(error.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToHome(AuthSession session) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => session.role == 'ESTILISTA'
            ? const StylistDashboardScreen()
            : const ClientHomeScreen(),
      ),
      (route) => false,
    );
  }

  void _goToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE53935),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'MIST',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                'MODEL STYLIST',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 36),
              const _FieldLabel('E-mail'),
              const SizedBox(height: 4),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 14, color: AppColors.dark),
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Senha'),
              const SizedBox(height: 4),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(fontSize: 14, color: AppColors.dark),
                decoration: const InputDecoration(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Esqueci minha senha',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GoldButton(
                label: _isLoading ? 'Entrando...' : 'Entrar',
                onPressed: _isLoading ? () {} : _login,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Nao tem conta? ',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                  GestureDetector(
                    onTap: _goToSignup,
                    child: const Text(
                      'Cadastre-se',
                      style: TextStyle(fontSize: 12, color: AppColors.gold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: AppColors.muted),
      ),
    );
  }
}
