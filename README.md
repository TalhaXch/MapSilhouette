# MapSilhouette 🗺️

A production-ready Flutter geography quiz game where players guess countries by their map silhouettes.

## 🎮 Game Features

### Game Modes
- **Classic Mode**: Endless questions until time runs out
- **Timed Challenge**: Fixed number of questions (10) with scoring
- **Practice Mode**: No timer, educational focus for learning

### Core Gameplay
- Country silhouettes displayed using CustomPainter
- 4 multiple-choice answers per question
- 10-second countdown timer (except in Practice mode)
- Instant visual feedback (green for correct, red for incorrect)
- Score calculation with time bonus
- Difficulty progression (easy → medium → hard)
- Streak tracking

### Scoring System
- Base points: 100 per correct answer
- Time bonus: 10 points per second remaining
- Best streak tracking
- High score persistence

## 🏗️ Architecture

### Clean Architecture Structure
```
lib/
├── core/
│   ├── constants/       # Game constants and configuration
│   └── theme/          # App theme, colors, and styles
├── data/
│   ├── models/         # Data models (Country, Question, GameMode)
│   ├── repositories/   # Data repositories
│   └── services/       # Persistence service
├── logic/
│   ├── game_controller.dart  # Game logic and state management
│   └── game_state.dart       # Game state definition
├── ui/
│   ├── screens/        # Game screens (Splash, Home, Game, GameOver)
│   └── widgets/        # Reusable widgets
└── main.dart
```

### State Management
- **Riverpod** for state management
- Clean separation of business logic and UI
- StateNotifier pattern for game controller
- Provider pattern for dependencies

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

### Build for Release

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

## 📦 Dependencies

- `flutter_riverpod: ^2.4.10` - State management
- `shared_preferences: ^2.2.2` - Data persistence
- `equatable: ^2.0.5` - Value equality
- `flutter_svg: ^2.0.10` - SVG support

## 🎯 Game Flow

1. **Splash Screen** → Animated app logo
2. **Home Screen** → Mode selection and statistics
3. **Game Screen** → Main gameplay with timer and scoring
4. **Game Over Screen** → Final statistics and replay

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web

## 👨‍💻 Built With

Flutter following clean architecture principles and production-ready practices.
