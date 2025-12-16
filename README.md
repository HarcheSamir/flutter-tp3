# TP2: Advanced State Management & APIs in Flutter

This project demonstrates advanced Flutter concepts including State Management (Provider & BLoC), API integration (REST), Streams, Futures, and UI theming/animations.

## 📋 Prerequisites

Before running the project, ensure you have the following installed:

- **Flutter SDK**: version `^3.10.1` or higher.
- **Dart SDK**.
- **IDE**: VS Code or Android Studio.

## 🚀 Installation

1. **Clone the repository** (or extract the project folder):
   ```bash
   git clone <repository_url>
   cd tp2
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

---

## 🏃 How to Run

Since this project contains multiple exercises (Quiz Provider, Quiz BLoC, Weather App) within a single app structure, **you must select which screen to load in `lib/main.dart`**.

### 1. Run Exercise 1: Quiz (Provider)

To test the Provider implementation:

1. Open `lib/main.dart`.
2. Uncomment the **Provider** section and comment out the others:
   ```dart
   // TP2-Exercice1-Q1: Providers
   home: const QuizScreenProvider(),
   ```
3. Run the app: `flutter run`

### 2. Run Exercise 1: Quiz (BLoC)

To test the BLoC implementation:

1. Open `lib/main.dart`.
2. Uncomment the **BLoC** section:
   ```dart
   // TP2-Exercice1-Q2: BLoC
   home: BlocProvider(
     create: (context) => QuizBloc()..add(LoadQuiz()),
     child: const QuizScreenBloc(),
   ),
   ```
3. Run the app: `flutter run`

### 3. Run Exercise 2: Weather App (API)

To test the Weather Application:

1. Open `lib/main.dart`.
2. Uncomment the **Weather** section:
   ```dart
   // TP2-Exercice2-Q2
   home: const WeatherScreen(),
   ```
3. Run the app: `flutter run`

---

## 📂 Project Architecture

The project follows a Clean Architecture approach to separate concerns:

```
lib/
├── business_logic/      # Logic layer (BLoC events & states)
│   └── quiz/            # Quiz BLoC implementation
├── data/                # Data layer
│   ├── models/          # Data models (WeatherModel, Question)
│   ├── providers/       # ChangeNotifier providers (QuizProvider)
│   └── repositories/    # API calls (WeatherRepository)
├── presentation/        # UI layer
│   ├── screens/         # Application screens (Quiz, Weather)
│   └── widgets/         # Reusable widgets
└── main.dart            # Entry point & Routing
```

## 📦 Dependencies

- **provider**: ^6.0.5 (State Management)
- **flutter_bloc**: ^8.1.3 (State Management)
- **equatable**: ^2.0.5 (Value equality for BLoC)
- **http**: ^1.1.0 (API Requests)
- **intl**: ^0.17.0 (Date Formatting)
- **font_awesome_flutter**: ^10.6.0 (Icons)

## 🔑 API Configuration

The Weather App uses **OpenWeatherMap**.

The API Key is currently hardcoded for testing purposes in:
`lib/data/repositories/weather_repository.dart`

> **Note**: If the weather data does not load, ensure the device has an active internet connection.

## 👤 Author

**Samir HARCHE**  
Development Mobile / IoT