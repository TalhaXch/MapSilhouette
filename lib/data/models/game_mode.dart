/// Represents different game modes
enum GameMode {
  classic('Classic Mode', 'Endless questions until time runs out'),
  timedChallenge('Timed Challenge', 'Fixed number of questions'),
  practice('Practice Mode', 'No timer, educational focus');

  const GameMode(this.title, this.description);

  final String title;
  final String description;
}

/// Difficulty levels for countries
enum DifficultyLevel {
  easy(1),
  medium(2),
  hard(3);

  const DifficultyLevel(this.level);

  final int level;
}
