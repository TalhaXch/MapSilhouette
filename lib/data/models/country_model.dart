import 'package:equatable/equatable.dart';
import 'game_mode.dart';

/// Represents a country with its map silhouette data
class CountryModel extends Equatable {
  final String name;
  final String code; // ISO country code
  final String svgPath; // Path to SVG asset or inline SVG path data
  final DifficultyLevel difficulty;
  final String continent;

  const CountryModel({
    required this.name,
    required this.code,
    required this.svgPath,
    required this.difficulty,
    required this.continent,
  });

  @override
  List<Object?> get props => [name, code, svgPath, difficulty, continent];
}
