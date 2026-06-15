import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gold_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
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
                style: TextStyle(
                  color: Colors.grey.shade600,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                "Conectando você aos melhores estilistas profissionais.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 40),

              GoldButton(
                text: "Entrar",
                onPressed: () {},
              ),

              TextButton(
                onPressed: () {},
                child: const Text("Criar conta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}