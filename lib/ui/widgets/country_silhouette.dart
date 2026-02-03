import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/country_model.dart';

/// Widget to display country map silhouette
class CountrySilhouette extends StatelessWidget {
  final CountryModel country;
  final bool isRevealed;

  const CountrySilhouette({
    super.key,
    required this.country,
    this.isRevealed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.silhouetteBackground,
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SvgPicture.asset(
                country.svgPath,
                colorFilter: const ColorFilter.mode(
                  AppColors.silhouette,
                  BlendMode.srcIn,
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
          if (isRevealed)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  country.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
