import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gold_button.dart';

class ConfirmationScreen extends StatelessWidget {
  final String message;
  final String subtitle;
  final String buttonLabel;
  final void Function(BuildContext) onContinue;

  const ConfirmationScreen({
    super.key,
    required this.message,
    required this.subtitle,
    required this.buttonLabel,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.goldLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.check, color: AppColors.gold, size: 36),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.muted,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                GoldButton(
                  label: buttonLabel,
                  onPressed: () => onContinue(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
