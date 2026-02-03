import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/country_model.dart';

/// Answer button widget
class AnswerButton extends StatelessWidget {
  final CountryModel country;
  final VoidCallback? onPressed;
  final bool isSelected;
  final bool isCorrect;
  final bool showFeedback;

  const AnswerButton({
    super.key,
    required this.country,
    this.onPressed,
    this.isSelected = false,
    this.isCorrect = false,
    this.showFeedback = false,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? borderColor;

    if (showFeedback) {
      if (isCorrect) {
        backgroundColor = AppColors.correctLight;
        borderColor = AppColors.correct;
      } else if (isSelected && !isCorrect) {
        backgroundColor = AppColors.incorrectLight;
        borderColor = AppColors.incorrect;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: borderColor ?? AppColors.primary.withOpacity(0.3),
              width: 2,
            ),
          ),
          elevation: isSelected ? 4 : 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showFeedback && isCorrect)
              const Icon(
                Icons.check_circle,
                color: AppColors.correct,
                size: 18,
              ),
            if (showFeedback && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: AppColors.incorrect, size: 18),
            if (showFeedback && (isCorrect || (isSelected && !isCorrect)))
              const SizedBox(width: 4),
            Expanded(
              child: Text(
                country.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
