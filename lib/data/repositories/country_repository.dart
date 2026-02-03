import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/country_model.dart';
import '../models/game_mode.dart';

/// Repository for country data
/// Using real SVG files from assets/maps/
class CountryRepository {
  // Real SVG files from assets/maps/

  static const List<CountryModel> _countries = [
    // Easy - Large, well-known countries
    CountryModel(
      name: 'United States',
      code: 'US',
      svgPath: 'assets/maps/United States.svg',
      difficulty: DifficultyLevel.easy,
      continent: 'North America',
    ),
    CountryModel(
      name: 'Brazil',
      code: 'BR',
      svgPath: 'assets/maps/Brazil.svg',
      difficulty: DifficultyLevel.easy,
      continent: 'South America',
    ),
    CountryModel(
      name: 'China',
      code: 'CN',
      svgPath: 'assets/maps/China.svg',
      difficulty: DifficultyLevel.easy,
      continent: 'Asia',
    ),
    CountryModel(
      name: 'Australia',
      code: 'AU',
      svgPath: 'assets/maps/Australia.svg',
      difficulty: DifficultyLevel.easy,
      continent: 'Oceania',
    ),
    CountryModel(
      name: 'India',
      code: 'IN',
      svgPath: 'assets/maps/India.svg',
      difficulty: DifficultyLevel.easy,
      continent: 'Asia',
    ),
    CountryModel(
      name: 'Canada',
      code: 'CA',
      svgPath: 'assets/maps/Canada.svg',
      difficulty: DifficultyLevel.easy,
      continent: 'North America',
    ),

    // Medium - Recognizable countries
    CountryModel(
      name: 'Japan',
      code: 'JP',
      svgPath: 'assets/maps/Japan.svg',
      difficulty: DifficultyLevel.medium,
      continent: 'Asia',
    ),
    CountryModel(
      name: 'France',
      code: 'FR',
      svgPath: 'assets/maps/France.svg',
      difficulty: DifficultyLevel.medium,
      continent: 'Europe',
    ),
    CountryModel(
      name: 'Germany',
      code: 'DE',
      svgPath: 'assets/maps/Germany.svg',
      difficulty: DifficultyLevel.medium,
      continent: 'Europe',
    ),
    CountryModel(
      name: 'Argentina',
      code: 'AR',
      svgPath: 'assets/maps/Argentina.svg',
      difficulty: DifficultyLevel.medium,
      continent: 'South America',
    ),
    CountryModel(
      name: 'South Africa',
      code: 'ZA',
      svgPath: 'assets/maps/South Africa.svg',
      difficulty: DifficultyLevel.medium,
      continent: 'Africa',
    ),
    CountryModel(
      name: 'Egypt',
      code: 'EG',
      svgPath: 'assets/maps/Egypt.svg',
      difficulty: DifficultyLevel.medium,
      continent: 'Africa',
    ),
    CountryModel(
      name: 'Pakistan',
      code: 'PK',
      svgPath: 'assets/maps/Pakistan.svg',
      difficulty: DifficultyLevel.medium,
      continent: 'Asia',
    ),
    CountryModel(
      name: 'Iran',
      code: 'IR',
      svgPath: 'assets/maps/Iran.svg',
      difficulty: DifficultyLevel.medium,
      continent: 'Asia',
    ),
    CountryModel(
      name: 'Bangladesh',
      code: 'BD',
      svgPath: 'assets/maps/Bangladesh.svg',
      difficulty: DifficultyLevel.medium,
      continent: 'Asia',
    ),

    // Hard - Smaller or more complex shapes
    CountryModel(
      name: 'Finland',
      code: 'FI',
      svgPath: 'assets/maps/Finland.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Europe',
    ),
    CountryModel(
      name: 'New Zealand',
      code: 'NZ',
      svgPath: 'assets/maps/New Zealand.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Oceania',
    ),
    CountryModel(
      name: 'Türkiye',
      code: 'TR',
      svgPath: 'assets/maps/Türkiye.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Europe/Asia',
    ),
    CountryModel(
      name: 'Belgium',
      code: 'BE',
      svgPath: 'assets/maps/Belgium.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Europe',
    ),
    CountryModel(
      name: 'Philippines',
      code: 'PH',
      svgPath: 'assets/maps/Philippines.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Asia',
    ),
    CountryModel(
      name: 'Afghanistan',
      code: 'AF',
      svgPath: 'assets/maps/Afghanistan.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Asia',
    ),
    CountryModel(
      name: 'Cambodia',
      code: 'KH',
      svgPath: 'assets/maps/Cambodia.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Asia',
    ),
    CountryModel(
      name: 'Cuba',
      code: 'CU',
      svgPath: 'assets/maps/Cuba.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'North America',
    ),
    CountryModel(
      name: 'Azerbaijan',
      code: 'AZ',
      svgPath: 'assets/maps/Azerbaijan.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Asia',
    ),
    CountryModel(
      name: 'Albania',
      code: 'AL',
      svgPath: 'assets/maps/Albania.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Europe',
    ),
    CountryModel(
      name: 'Bhutan',
      code: 'BT',
      svgPath: 'assets/maps/Bhutan.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Asia',
    ),
    CountryModel(
      name: 'Bahrain',
      code: 'BH',
      svgPath: 'assets/maps/Bahrain.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Asia',
    ),
    CountryModel(
      name: 'Algeria',
      code: 'DZ',
      svgPath: 'assets/maps/Algeria.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Africa',
    ),
    CountryModel(
      name: 'Angola',
      code: 'AO',
      svgPath: 'assets/maps/Angola.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Africa',
    ),
    CountryModel(
      name: 'Andorra',
      code: 'AD',
      svgPath: 'assets/maps/Andorra.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Europe',
    ),
    CountryModel(
      name: 'Palestine',
      code: 'PS',
      svgPath: 'assets/maps/Palestine.svg',
      difficulty: DifficultyLevel.hard,
      continent: 'Asia',
    ),
  ];

  /// Get all countries
  List<CountryModel> getAllCountries() {
    return List.from(_countries);
  }

  /// Get countries by difficulty
  List<CountryModel> getCountriesByDifficulty(DifficultyLevel difficulty) {
    return _countries.where((c) => c.difficulty == difficulty).toList();
  }

  /// Get a random country
  CountryModel getRandomCountry() {
    final randomIndex =
        DateTime.now().millisecondsSinceEpoch % _countries.length;
    return _countries[randomIndex];
  }

  /// Get random countries excluding specific ones
  List<CountryModel> getRandomCountries(
    int count, {
    List<String> exclude = const [],
  }) {
    final available =
        _countries.where((c) => !exclude.contains(c.code)).toList();

    if (available.length <= count) {
      return available;
    }

    available.shuffle();
    return available.take(count).toList();
  }

  /// Get country by code
  CountryModel? getCountryByCode(String code) {
    try {
      return _countries.firstWhere((c) => c.code == code);
    } catch (e) {
      return null;
    }
  }
}

/// Provider for country repository
final countryRepositoryProvider = Provider<CountryRepository>((ref) {
  return CountryRepository();
});
