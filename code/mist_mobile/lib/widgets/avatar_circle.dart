import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AvatarCircle extends StatelessWidget {
  final String initials;
  final double size;
  final double fontSize;

  const AvatarCircle({
    super.key,
    required this.initials,
    this.size = 46,
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.goldLight,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold, width: 2),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: AppColors.gold,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
