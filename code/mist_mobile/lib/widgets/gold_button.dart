import 'package:flutter/material.dart';

class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool outline;

  const GoldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.outline = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outline) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(onPressed: onPressed, child: Text(label)),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}
