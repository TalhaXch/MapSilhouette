import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Timer widget with color feedback
class TimerWidget extends StatelessWidget {
  final int timeRemaining;

  const TimerWidget({super.key, required this.timeRemaining});

  @override
  Widget build(BuildContext context) {
    Color timerColor;
    if (timeRemaining <= 3) {
      timerColor = AppColors.timerDanger;
    } else if (timeRemaining <= 5) {
      timerColor = AppColors.timerWarning;
    } else {
      timerColor = AppColors.timerNormal;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: timerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: timerColor, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: timerColor, size: 20),
          const SizedBox(width: 4),
          Text(
            '${timeRemaining}s',
            style: TextStyle(
              color: timerColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
