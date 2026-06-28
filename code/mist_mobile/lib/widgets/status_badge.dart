import 'package:flutter/material.dart';
import '../models/booking_status.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final c = _colors();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: c.dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: TextStyle(
              color: c.text,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  _StatusColors _colors() {
    switch (status) {
      case BookingStatus.pending:
        return _StatusColors(AppColors.pendingBg, AppColors.pendingText, AppColors.pendingDot);
      case BookingStatus.accepted:
        return _StatusColors(AppColors.acceptedBg, AppColors.acceptedText, AppColors.acceptedDot);
      case BookingStatus.refused:
        return _StatusColors(AppColors.refusedBg, AppColors.refusedText, AppColors.refusedDot);
      case BookingStatus.inProgress:
        return _StatusColors(AppColors.inProgressBg, AppColors.inProgressText, AppColors.inProgressDot);
      case BookingStatus.done:
        return _StatusColors(AppColors.doneBg, AppColors.doneText, AppColors.doneDot);
    }
  }
}

class _StatusColors {
  final Color bg, text, dot;
  const _StatusColors(this.bg, this.text, this.dot);
}
