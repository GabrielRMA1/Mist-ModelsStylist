import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // Aguardar um tempo para mostrar a splash
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Verificar se está autenticado
    final isAuthenticated = await AuthService.isAuthenticated();

    if (!mounted) return;

    if (isAuthenticated) {
      // Verificar auth no servidor
      final authData = await AuthService.checkAuth();
      if (mounted) {
        if (authData != null) {
          Navigator.of(context).pushReplacementNamed('/cliente-home');
        } else {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: Center(
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
                  "M",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "MIST",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                letterSpacing: 3,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "MODEL STYLIST",
              style: TextStyle(color: Colors.grey.shade600, letterSpacing: 2),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ],
        ),
      ),
    );
  }
}
