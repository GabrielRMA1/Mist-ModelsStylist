import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;

    switch (status) {
      case "aceito":
        bg = const Color(0xFFE8F5EC);
        textColor = const Color(0xFF1A6B35);
        break;

      case "pendente":
        bg = const Color(0xFFFFF7E6);
        textColor = const Color(0xFF8B5E00);
        break;

      case "concluido":
        bg = const Color(0xFFF0F0F0);
        textColor = const Color(0xFF444444);
        break;

      default:
        bg = Colors.grey.shade200;
        textColor = Colors.black;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}