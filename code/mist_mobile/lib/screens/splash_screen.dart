import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/gold_button.dart';
import 'client/client_home_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'stylist/stylist_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AuthService();
  bool _checkingSession = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final session = await _authService.checkAuth();

    if (!mounted) return;

    if (session != null) {
      _goToHome(session);
      return;
    }

    setState(() => _checkingSession = false);
  }

  void _goToHome(AuthSession session) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => session.role == 'ESTILISTA'
            ? const StylistDashboardScreen()
            : const ClientHomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'M',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'MIST',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'MODEL STYLIST',
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Conectando você aos melhores estilistas profissionais.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 40),
                if (_checkingSession)
                  const CircularProgressIndicator(color: AppColors.gold)
                else ...[
                  GoldButton(
                    label: 'Entrar',
                    onPressed: () => _goToLogin(context),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => _goToSignup(context),
                    child: const Text(
                      'Criar conta',
                      style: TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _goToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }
}
