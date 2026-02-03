# 🚀 Quick Start Guide - MapSilhouette

## Get Started in 3 Steps

### 1️⃣ Install Dependencies
```bash
flutter pub get
```

### 2️⃣ Run the App
```bash
flutter run
```

### 3️⃣ Start Playing! 🎮

---

## 🎮 How to Play

1. **Choose Your Mode**
   - Classic: Endless questions
   - Timed Challenge: 10 questions
   - Practice: No timer

2. **Guess the Country**
   - Look at the silhouette
   - Pick from 4 options
   - Answer before time runs out!

3. **Earn Points**
   - 100 points per correct answer
   - Extra points for speed
   - Build your streak!

---

## 📱 Platform-Specific Run

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows
```

---

## 🔧 Build for Release

```bash
# Android APK
flutter build apk --release

# iOS App
flutter build ios --release

# Web App
flutter build web --release
```

---

## 📚 Project Documentation

- **README.md** - Overview and features
- **IMPLEMENTATION.md** - Technical details
- **PROJECT_SUMMARY.md** - Complete summary

---

## 🎯 Key Files to Explore

```
lib/
├── main.dart                    ← App entry point
├── ui/screens/game_screen.dart  ← Main gameplay
├── logic/game_controller.dart   ← Game logic
└── data/repositories/           ← Country data
    country_repository.dart
```

---

## 🎨 Customize

### Change Colors
Edit: `lib/core/theme/app_theme.dart`

### Modify Game Rules
Edit: `lib/core/constants/game_constants.dart`

### Add Countries
Edit: `lib/data/repositories/country_repository.dart`

---

## ✅ Requirements

- Flutter SDK: 3.7.2+
- Dart SDK: Latest
- Device/Emulator: Android, iOS, or Web

---

**That's it! You're ready to play! 🎉**

For questions or customization, check the full documentation in IMPLEMENTATION.md
